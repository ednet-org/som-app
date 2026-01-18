/// OSM tag to SOM taxonomy mapper.
/// Maps OpenStreetMap tags to SOM branch/category taxonomy.
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

import '../models/business_entity.dart';

/// Result of taxonomy mapping.
class TaxonomyMappingResult {
  const TaxonomyMappingResult({
    required this.taxonomy,
    required this.providerType,
    this.naceCode,
  });

  final Taxonomy taxonomy;
  final ProviderType providerType;
  final NaceCode? naceCode;
}

/// Mapping rule from YAML.
class _MappingRule {
  _MappingRule({
    required this.osmTags,
    required this.branchId,
    required this.branchName,
    required this.categoryId,
    required this.categoryName,
    required this.providerType,
    required this.productTags,
    this.naceCode,
    this.naceDescription,
  });

  final Map<String, String> osmTags;
  final String branchId;
  final String branchName;
  final String categoryId;
  final String categoryName;
  final String providerType;
  final List<String> productTags;
  final String? naceCode;
  final String? naceDescription;
}

/// Maps OSM tags to SOM taxonomy using YAML mapping files.
class OsmToSomTaxonomyMapper {
  OsmToSomTaxonomyMapper._(this._rules);

  final List<_MappingRule> _rules;

  /// Load mappings from YAML file.
  static Future<OsmToSomTaxonomyMapper> fromYamlFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return fromYamlString(content);
  }

  /// Load mappings from YAML string.
  static OsmToSomTaxonomyMapper fromYamlString(String yaml) {
    final doc = loadYaml(yaml) as YamlMap;
    final mappings = doc['mappings'] as YamlList;

    final rules = <_MappingRule>[];
    for (final mapping in mappings) {
      final m = mapping as YamlMap;
      final osmTags = <String, String>{};

      final tagsYaml = m['osm_tags'] as YamlMap;
      for (final entry in tagsYaml.entries) {
        osmTags[entry.key as String] = entry.value as String;
      }

      final productTagsYaml = m['product_tags'] as YamlList?;
      final productTags =
          productTagsYaml?.map((e) => e as String).toList() ?? [];

      rules.add(_MappingRule(
        osmTags: osmTags,
        branchId: m['branch_id'] as String,
        branchName: m['branch_name'] as String,
        categoryId: m['category_id'] as String,
        categoryName: m['category_name'] as String,
        providerType: m['provider_type'] as String,
        productTags: productTags,
        naceCode: m['nace_code'] as String?,
        naceDescription: m['nace_description'] as String?,
      ));
    }

    return OsmToSomTaxonomyMapper._(rules);
  }

  /// Map OSM tags to taxonomy.
  TaxonomyMappingResult? map(Map<String, String> osmTags) {
    // Find best matching rule
    _MappingRule? bestMatch;
    var bestScore = 0;
    final matchedTags = <String>[];

    for (final rule in _rules) {
      var score = 0;
      final currentMatchedTags = <String>[];

      for (final entry in rule.osmTags.entries) {
        final osmValue = osmTags[entry.key];
        if (osmValue != null && osmValue == entry.value) {
          score++;
          currentMatchedTags.add('${entry.key}=${entry.value}');
        }
      }

      // Must match all tags in the rule
      if (score == rule.osmTags.length && score > bestScore) {
        bestScore = score;
        bestMatch = rule;
        matchedTags
          ..clear()
          ..addAll(currentMatchedTags);
      }
    }

    if (bestMatch == null) {
      return null;
    }

    // Calculate confidence based on match quality
    final confidence = bestScore >= 2 ? 1.0 : 0.9;

    final taxonomy = Taxonomy(
      branchId: bestMatch.branchId,
      branchName: bestMatch.branchName,
      categoryId: bestMatch.categoryId,
      categoryName: bestMatch.categoryName,
      productTags: bestMatch.productTags,
      inference: TaxonomyInference(
        method: InferenceMethod.osmTagMapping,
        confidence: confidence,
        matchedTags: matchedTags,
      ),
    );

    NaceCode? naceCode;
    if (bestMatch.naceCode != null) {
      naceCode = NaceCode(
        code: bestMatch.naceCode!,
        description: bestMatch.naceDescription,
        primary: true,
      );
    }

    return TaxonomyMappingResult(
      taxonomy: taxonomy,
      providerType: ProviderType.fromJson(bestMatch.providerType),
      naceCode: naceCode,
    );
  }
}
