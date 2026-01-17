/// Provider type mapper.
/// Maps OSM tags to provider types when no specific taxonomy mapping exists.
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

import '../models/business_entity.dart';

/// Mapping rule for provider types.
class _ProviderTypeRule {
  _ProviderTypeRule({
    required this.tagKey,
    this.tagValue,
    required this.providerType,
    this.exceptions = const [],
  });

  final String tagKey;
  final String? tagValue; // null means any value
  final ProviderType providerType;
  final List<_ExceptionRule> exceptions;
}

/// Exception rule within a provider type mapping.
class _ExceptionRule {
  _ExceptionRule({
    required this.value,
    required this.providerType,
  });

  final String value;
  final ProviderType providerType;
}

/// Maps OSM tags to provider types.
class ProviderTypeMapper {
  ProviderTypeMapper._(this._rules, this._defaultType);

  final List<_ProviderTypeRule> _rules;
  final ProviderType _defaultType;

  /// Load mappings from YAML file.
  static Future<ProviderTypeMapper> fromYamlFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return fromYamlString(content);
  }

  /// Load mappings from YAML string.
  static ProviderTypeMapper fromYamlString(String yaml) {
    final doc = loadYaml(yaml) as YamlMap;
    final mappings = doc['mappings'] as YamlList;
    final defaultStr = doc['default_provider_type'] as String? ?? 'UNKNOWN';

    final rules = <_ProviderTypeRule>[];
    for (final mapping in mappings) {
      final m = mapping as YamlMap;

      final exceptions = <_ExceptionRule>[];
      final exceptionsYaml = m['exceptions'] as YamlList?;
      if (exceptionsYaml != null) {
        for (final e in exceptionsYaml) {
          final ex = e as YamlMap;
          exceptions.add(_ExceptionRule(
            value: ex['value'] as String,
            providerType: ProviderType.fromJson(ex['provider_type'] as String),
          ));
        }
      }

      rules.add(_ProviderTypeRule(
        tagKey: m['tag_key'] as String,
        tagValue: m['tag_value'] as String?,
        providerType: ProviderType.fromJson(m['provider_type'] as String),
        exceptions: exceptions,
      ));
    }

    return ProviderTypeMapper._(rules, ProviderType.fromJson(defaultStr));
  }

  /// Map OSM tags to provider type.
  ProviderType map(Map<String, String> osmTags) {
    for (final rule in _rules) {
      final tagValue = osmTags[rule.tagKey];
      if (tagValue == null) continue;

      // Check if rule matches this tag
      if (rule.tagValue != null && rule.tagValue != '*' && rule.tagValue != tagValue) {
        continue;
      }

      // Check exceptions
      for (final exception in rule.exceptions) {
        if (tagValue == exception.value) {
          return exception.providerType;
        }
      }

      return rule.providerType;
    }

    return _defaultType;
  }

  /// Create a simple mapper without YAML.
  static ProviderTypeMapper simple() {
    return ProviderTypeMapper._(
      [
        // Shop = HAENDLER (with wholesale exception)
        _ProviderTypeRule(
          tagKey: 'shop',
          providerType: ProviderType.haendler,
          exceptions: [
            _ExceptionRule(value: 'wholesale', providerType: ProviderType.grosshaendler),
          ],
        ),
        // Craft = DIENSTLEISTER
        _ProviderTypeRule(
          tagKey: 'craft',
          providerType: ProviderType.dienstleister,
        ),
        // Office = DIENSTLEISTER
        _ProviderTypeRule(
          tagKey: 'office',
          providerType: ProviderType.dienstleister,
        ),
        // Amenity = DIENSTLEISTER (with fuel exception)
        _ProviderTypeRule(
          tagKey: 'amenity',
          providerType: ProviderType.dienstleister,
          exceptions: [
            _ExceptionRule(value: 'fuel', providerType: ProviderType.haendler),
          ],
        ),
        // Industrial = HERSTELLER (with warehouse exception)
        _ProviderTypeRule(
          tagKey: 'industrial',
          providerType: ProviderType.hersteller,
          exceptions: [
            _ExceptionRule(value: 'warehouse', providerType: ProviderType.dienstleister),
          ],
        ),
        // man_made=works = HERSTELLER
        _ProviderTypeRule(
          tagKey: 'man_made',
          tagValue: 'works',
          providerType: ProviderType.hersteller,
        ),
        // Tourism = DIENSTLEISTER
        _ProviderTypeRule(
          tagKey: 'tourism',
          providerType: ProviderType.dienstleister,
        ),
      ],
      ProviderType.unknown,
    );
  }
}
