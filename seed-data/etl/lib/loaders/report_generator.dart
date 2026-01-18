/// Report generator.
/// Generates report.md with statistics and attribution.
library;

import 'dart:io';

import '../config/data_sources.dart';
import '../transformers/pii_filter.dart';
import 'manifest_generator.dart';

/// Deduplication statistics.
class DedupeStats {
  DedupeStats({
    required this.beforeCount,
    required this.afterCount,
    required this.mergedCount,
  });

  final int beforeCount;
  final int afterCount;
  final int mergedCount;
}

/// Generates markdown reports.
class ReportGenerator {
  ReportGenerator({required this.outputDir});

  final String outputDir;

  /// Generate and write report.
  Future<void> generate({
    required Manifest manifest,
    required DedupeStats dedupeStats,
    required PiiAuditReport piiReport,
    required Map<String, int> categoryDistribution,
  }) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('# Austrian B2B Business Seed Database Report');
    buffer.writeln();
    buffer.writeln('Generated: ${manifest.generatedAt}');
    buffer.writeln();

    // Summary
    buffer.writeln('## Summary');
    buffer.writeln();
    buffer.writeln('| Metric | Value |');
    buffer.writeln('|--------|-------|');
    buffer.writeln('| Total Entities | ${manifest.totals.totalEntities} |');
    buffer
        .writeln('| Deduplication Merges | ${manifest.totals.dedupeMerges} |');
    buffer.writeln('| Output File | ${manifest.outputFile.filename} |');
    buffer.writeln(
        '| File Size | ${_formatBytes(manifest.outputFile.sizeBytes)} |');
    buffer.writeln();

    // Data Sources
    buffer.writeln('## Data Sources');
    buffer.writeln();
    for (final source in manifest.sources) {
      buffer.writeln('### ${source.name}');
      buffer.writeln();
      buffer.writeln('- **ID**: ${source.id}');
      buffer.writeln('- **URL**: ${source.url}');
      buffer.writeln('- **License**: ${source.license}');
      if (source.licenseUrl != null) {
        buffer.writeln('- **License URL**: ${source.licenseUrl}');
      }
      buffer.writeln('- **Fetched**: ${source.fetchedAt}');
      buffer.writeln('- **Records**: ${source.recordCount}');
      buffer.writeln();
    }

    // Distribution by Bundesland
    if (manifest.totals.entitiesByBundesland.isNotEmpty) {
      buffer.writeln('## Distribution by Bundesland');
      buffer.writeln();
      buffer.writeln('| Bundesland | Count |');
      buffer.writeln('|------------|-------|');

      final sorted = manifest.totals.entitiesByBundesland.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in sorted) {
        buffer.writeln('| ${entry.key} | ${entry.value} |');
      }
      buffer.writeln();
    }

    // Distribution by Provider Type
    if (manifest.totals.entitiesByProviderType.isNotEmpty) {
      buffer.writeln('## Distribution by Provider Type');
      buffer.writeln();
      buffer.writeln('| Provider Type | Count |');
      buffer.writeln('|---------------|-------|');

      final sorted = manifest.totals.entitiesByProviderType.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in sorted) {
        buffer.writeln('| ${entry.key} | ${entry.value} |');
      }
      buffer.writeln();
    }

    // Top Categories
    if (categoryDistribution.isNotEmpty) {
      buffer.writeln('## Top 50 SOM Categories');
      buffer.writeln();
      buffer.writeln('| Category | Count |');
      buffer.writeln('|----------|-------|');

      final sorted = categoryDistribution.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in sorted.take(50)) {
        buffer.writeln('| ${entry.key} | ${entry.value} |');
      }
      buffer.writeln();
    }

    // Deduplication Statistics
    buffer.writeln('## Deduplication Statistics');
    buffer.writeln();
    buffer.writeln('| Metric | Value |');
    buffer.writeln('|--------|-------|');
    buffer.writeln('| Before Deduplication | ${dedupeStats.beforeCount} |');
    buffer.writeln('| After Deduplication | ${dedupeStats.afterCount} |');
    buffer.writeln('| Total Merges | ${dedupeStats.mergedCount} |');
    buffer.writeln();

    // PII Audit Summary
    buffer.writeln('## PII Audit Summary');
    buffer.writeln();
    buffer.writeln('| Contact Type | Allowed | Filtered |');
    buffer.writeln('|--------------|---------|----------|');
    buffer.writeln(
        '| Phone Numbers | ${piiReport.allowedPhones} | ${piiReport.filteredPhones} |');
    buffer.writeln(
        '| Email Addresses | ${piiReport.allowedEmails} | ${piiReport.filteredEmails} |');
    buffer.writeln('| Websites | ${piiReport.allowedWebsites} | - |');
    buffer.writeln();

    if (piiReport.filteredReasons.isNotEmpty) {
      buffer.writeln('### Filtering Reasons');
      buffer.writeln();
      buffer.writeln('| Reason | Count |');
      buffer.writeln('|--------|-------|');

      for (final entry in piiReport.filteredReasons.entries) {
        buffer.writeln('| ${entry.key} | ${entry.value} |');
      }
      buffer.writeln();
    }

    // Output File Details
    buffer.writeln('## Output File');
    buffer.writeln();
    buffer.writeln('| Property | Value |');
    buffer.writeln('|----------|-------|');
    buffer.writeln('| Filename | ${manifest.outputFile.filename} |');
    buffer.writeln('| Size | ${_formatBytes(manifest.outputFile.sizeBytes)} |');
    buffer.writeln('| Records | ${manifest.outputFile.recordCount} |');
    buffer.writeln('| SHA256 | `${manifest.outputFile.sha256Hash}` |');
    buffer.writeln();

    // Attribution
    buffer.writeln('## Attribution & Licensing');
    buffer.writeln();
    buffer.writeln('### OpenStreetMap Data (ODbL-1.0)');
    buffer.writeln();
    buffer.writeln(OsmDataSource.attribution);
    buffer.writeln();
    buffer.writeln(
        'This database contains information derived from OpenStreetMap,');
    buffer
        .writeln('which is available under the Open Database License (ODbL).');
    buffer.writeln(
        'Any rights in individual contents of the database are licensed');
    buffer.writeln('under the Database Contents License.');
    buffer.writeln();
    buffer.writeln('Full license: ${OsmDataSource.licenseUrl}');
    buffer.writeln();
    buffer.writeln('### Firmenbuch Data (CC-BY-4.0)');
    buffer.writeln();
    buffer.writeln(FirmenbuchDataSource.attribution);
    buffer.writeln();
    buffer.writeln(
        'This database contains information from the Austrian Business Register');
    buffer.writeln(
        '(Firmenbuch), available under Creative Commons Attribution 4.0.');
    buffer.writeln();
    buffer.writeln('Full license: ${FirmenbuchDataSource.licenseUrl}');
    buffer.writeln();

    // Write report
    final file = File('$outputDir/report.md');
    await file.writeAsString(buffer.toString());
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
