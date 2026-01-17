/// Loader for companies table.
library;

import '../mappers/entity_to_record.dart';
import '../models/business_entity.dart';
import 'seed_config.dart';
import 'supabase_client.dart';

/// Loads business entities into the companies table.
class CompanyLoader {
  CompanyLoader({
    required SeedSupabaseClient client,
    required SeedConfig config,
  })  : _client = client,
        _config = config,
        _mapper = EntityToRecordMapper();

  final SeedSupabaseClient _client;
  final SeedConfig _config;
  final EntityToRecordMapper _mapper;

  /// Load entities into companies table.
  ///
  /// Returns the result of the batch upsert operation.
  Future<CompanyLoadResult> load({
    required List<BusinessEntity> entities,
    void Function(int processed, int total, String message)? onProgress,
  }) async {
    onProgress?.call(0, entities.length, 'Mapping entities to company records...');

    // Map entities to company records
    final records = <Map<String, dynamic>>[];
    final stats = MappingStats();

    for (final entity in entities) {
      records.add(_mapper.toCompanyRecord(entity));
      stats.addEntity(entity);
    }

    onProgress?.call(0, entities.length, 'Upserting ${records.length} companies...');

    // Perform batch upsert
    final result = await _client.batchUpsert(
      table: 'companies',
      records: records,
      conflictColumn: 'external_id',
      onProgress: (processed, total) {
        final pct = (processed / total * 100).toStringAsFixed(1);
        onProgress?.call(processed, total, 'Companies: $processed/$total ($pct%)');
      },
    );

    return CompanyLoadResult(
      batchResult: result,
      stats: stats,
      dryRun: _config.dryRun,
    );
  }

  /// Verify company counts in database.
  Future<CompanyVerification> verify() async {
    final totalCount = await _client.count('companies');
    final seededCount = await _client.count('companies', filter: {'type': 'seeded'});
    final registeredCount = await _client.count(
      'companies',
      filter: {'type': 'registered'},
    );

    return CompanyVerification(
      totalCount: totalCount,
      seededCount: seededCount,
      registeredCount: registeredCount,
    );
  }
}

/// Result of company load operation.
class CompanyLoadResult {
  CompanyLoadResult({
    required this.batchResult,
    required this.stats,
    required this.dryRun,
  });

  final BatchUpsertResult batchResult;
  final MappingStats stats;
  final bool dryRun;

  bool get success => !batchResult.hasErrors;

  @override
  String toString() {
    if (dryRun) {
      return 'CompanyLoadResult (dry run):\n$stats';
    }
    return 'CompanyLoadResult:\n'
        '  $batchResult\n'
        '$stats';
  }
}

/// Company verification result.
class CompanyVerification {
  CompanyVerification({
    required this.totalCount,
    required this.seededCount,
    required this.registeredCount,
  });

  final int totalCount;
  final int seededCount;
  final int registeredCount;

  @override
  String toString() {
    return 'Companies in database:\n'
        '  Total: $totalCount\n'
        '  Seeded: $seededCount\n'
        '  Registered: $registeredCount';
  }
}
