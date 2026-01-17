/// Manifest generator.
/// Generates manifest.json with metadata about the generated data.
library;

import 'dart:convert';
import 'dart:io';

import 'json_shard_writer.dart';

/// Source metadata for manifest.
class SourceInfo {
  SourceInfo({
    required this.id,
    required this.name,
    required this.url,
    required this.license,
    this.licenseUrl,
    required this.fetchedAt,
    required this.recordCount,
  });

  final String id;
  final String name;
  final String url;
  final String license;
  final String? licenseUrl;
  final String fetchedAt;
  final int recordCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'license': license,
        if (licenseUrl != null) 'license_url': licenseUrl,
        'fetched_at': fetchedAt,
        'record_count': recordCount,
      };
}

/// Statistics for manifest.
class ManifestStats {
  ManifestStats({
    required this.totalEntities,
    required this.dedupeMerges,
    this.entitiesByBundesland = const {},
    this.entitiesByProviderType = const {},
    this.entitiesByCategory = const {},
  });

  final int totalEntities;
  final int dedupeMerges;
  final Map<String, int> entitiesByBundesland;
  final Map<String, int> entitiesByProviderType;
  final Map<String, int> entitiesByCategory;

  Map<String, dynamic> toJson() => {
        'entities': totalEntities,
        'dedupe_merges': dedupeMerges,
        if (entitiesByBundesland.isNotEmpty)
          'by_bundesland': entitiesByBundesland,
        if (entitiesByProviderType.isNotEmpty)
          'by_provider_type': entitiesByProviderType,
        if (entitiesByCategory.isNotEmpty) 'by_category': entitiesByCategory,
      };
}

/// Manifest model.
class Manifest {
  Manifest({
    required this.generatedAt,
    required this.sources,
    required this.outputFile,
    required this.totals,
    this.schemaVersion = '1.0.0',
  });

  final String generatedAt;
  final List<SourceInfo> sources;
  final OutputFileInfo outputFile;
  final ManifestStats totals;
  final String schemaVersion;

  Map<String, dynamic> toJson() => {
        'schema_version': schemaVersion,
        'generated_at': generatedAt,
        'sources': sources.map((s) => s.toJson()).toList(),
        'output_file': outputFile.toJson(),
        'totals': totals.toJson(),
      };
}

/// Generates manifest.json files.
class ManifestGenerator {
  ManifestGenerator({required this.outputDir});

  final String outputDir;

  /// Generate and write manifest.
  Future<Manifest> generate({
    required List<SourceInfo> sources,
    required OutputFileInfo outputFile,
    required ManifestStats stats,
  }) async {
    final manifest = Manifest(
      generatedAt: DateTime.now().toUtc().toIso8601String(),
      sources: sources,
      outputFile: outputFile,
      totals: stats,
    );

    // Write manifest file
    final file = File('$outputDir/manifest.json');
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(manifest.toJson()));

    return manifest;
  }
}
