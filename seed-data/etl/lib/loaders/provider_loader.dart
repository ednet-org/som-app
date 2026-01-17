/// Loader for provider_profiles table.
library;

import '../mappers/entity_to_record.dart';
import '../models/business_entity.dart';
import 'seed_config.dart';
import 'supabase_client.dart';

/// Loads business entities into the provider_profiles table.
class ProviderLoader {
  ProviderLoader({
    required SeedSupabaseClient client,
    required SeedConfig config,
  })  : _client = client,
        _config = config,
        _mapper = EntityToRecordMapper();

  final SeedSupabaseClient _client;
  final SeedConfig _config;
  final EntityToRecordMapper _mapper;

  /// Load entities into provider_profiles table.
  ///
  /// Must be called after companies are loaded, as provider_profiles
  /// references companies via foreign key.
  Future<ProviderLoadResult> load({
    required List<BusinessEntity> entities,
    void Function(int processed, int total, String message)? onProgress,
  }) async {
    onProgress?.call(0, entities.length, 'Mapping entities to provider records...');

    // Map entities to provider profile records
    final records = <Map<String, dynamic>>[];
    final typeStats = <String, int>{};

    for (final entity in entities) {
      final companyId = _mapper.generateCompanyId(entity.id);
      records.add(_mapper.toProviderProfileRecord(entity, companyId));

      final typeKey = entity.providerType.toJson();
      typeStats[typeKey] = (typeStats[typeKey] ?? 0) + 1;
    }

    onProgress?.call(0, entities.length, 'Upserting ${records.length} provider profiles...');

    // Perform batch upsert
    final result = await _client.batchUpsert(
      table: 'provider_profiles',
      records: records,
      conflictColumn: 'company_id',
      onProgress: (processed, total) {
        final pct = (processed / total * 100).toStringAsFixed(1);
        onProgress?.call(processed, total, 'Providers: $processed/$total ($pct%)');
      },
    );

    return ProviderLoadResult(
      batchResult: result,
      byType: typeStats,
      dryRun: _config.dryRun,
    );
  }

  /// Verify provider counts in database.
  Future<ProviderVerification> verify() async {
    final totalCount = await _client.count('provider_profiles');
    final seededCount = await _client.count(
      'provider_profiles',
      filter: {'status': 'seeded'},
    );

    // Get counts by provider type
    final byType = await _client.countGroupBy('provider_profiles', 'provider_type');

    return ProviderVerification(
      totalCount: totalCount,
      seededCount: seededCount,
      byType: byType,
    );
  }
}

/// Result of provider load operation.
class ProviderLoadResult {
  ProviderLoadResult({
    required this.batchResult,
    required this.byType,
    required this.dryRun,
  });

  final BatchUpsertResult batchResult;
  final Map<String, int> byType;
  final bool dryRun;

  bool get success => !batchResult.hasErrors;

  @override
  String toString() {
    final buffer = StringBuffer();
    if (dryRun) {
      buffer.writeln('ProviderLoadResult (dry run):');
    } else {
      buffer.writeln('ProviderLoadResult:');
      buffer.writeln('  $batchResult');
    }
    buffer.writeln('  By provider type:');
    for (final entry in byType.entries) {
      buffer.writeln('    ${entry.key}: ${entry.value}');
    }
    return buffer.toString();
  }
}

/// Provider verification result.
class ProviderVerification {
  ProviderVerification({
    required this.totalCount,
    required this.seededCount,
    required this.byType,
  });

  final int totalCount;
  final int seededCount;
  final Map<String, int> byType;

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('Provider profiles in database:')
      ..writeln('  Total: $totalCount')
      ..writeln('  Seeded: $seededCount')
      ..writeln('  By provider type:');
    for (final entry in byType.entries) {
      buffer.writeln('    ${entry.key}: ${entry.value}');
    }
    return buffer.toString();
  }
}
