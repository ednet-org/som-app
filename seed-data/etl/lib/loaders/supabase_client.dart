/// Supabase client utilities for database seeding.
library;

import 'dart:async';

import 'package:supabase/supabase.dart';

import 'seed_config.dart';

/// Wrapper for Supabase client with batch operations.
class SeedSupabaseClient {
  SeedSupabaseClient._(this._client, this._config);

  /// Initialize Supabase client from configuration.
  static Future<SeedSupabaseClient> initialize(SeedConfig config) async {
    final client = SupabaseClient(
      config.supabaseUrl,
      config.supabaseServiceKey,
    );
    return SeedSupabaseClient._(client, config);
  }

  final SupabaseClient _client;
  final SeedConfig _config;

  /// Get the underlying Supabase client.
  SupabaseClient get client => _client;

  /// Batch upsert records with retry logic.
  ///
  /// [table] - Target table name.
  /// [records] - List of records to upsert.
  /// [conflictColumn] - Column(s) to use for conflict detection.
  /// [onProgress] - Callback for progress reporting.
  Future<BatchUpsertResult> batchUpsert({
    required String table,
    required List<Map<String, dynamic>> records,
    required String conflictColumn,
    void Function(int processed, int total)? onProgress,
  }) async {
    if (_config.dryRun) {
      return BatchUpsertResult(
        inserted: 0,
        updated: 0,
        errors: [],
        dryRun: true,
        total: records.length,
      );
    }

    var inserted = 0;
    var updated = 0;
    final errors = <BatchError>[];
    final total = records.length;

    for (var i = 0; i < records.length; i += _config.batchSize) {
      final end = (i + _config.batchSize).clamp(0, records.length);
      final batch = records.sublist(i, end);

      try {
        await _upsertBatchWithRetry(
          table: table,
          batch: batch,
          conflictColumn: conflictColumn,
        );
        // Assume all records in batch were successful
        // Supabase doesn't distinguish insert vs update in upsert response
        updated += batch.length;
      } on PostgrestException catch (e) {
        errors.add(BatchError(
          batchIndex: i ~/ _config.batchSize,
          message: e.message,
          details: e.details?.toString(),
        ));
      } catch (e) {
        errors.add(BatchError(
          batchIndex: i ~/ _config.batchSize,
          message: e.toString(),
        ));
      }

      onProgress?.call(end, total);
    }

    return BatchUpsertResult(
      inserted: inserted,
      updated: updated,
      errors: errors,
      dryRun: false,
      total: total,
    );
  }

  Future<void> _upsertBatchWithRetry({
    required String table,
    required List<Map<String, dynamic>> batch,
    required String conflictColumn,
    int maxRetries = 3,
  }) async {
    var attempts = 0;
    while (true) {
      try {
        await _client.from(table).upsert(
              batch,
              onConflict: conflictColumn,
            );
        return;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
        // Exponential backoff: 1s, 2s, 4s
        await Future<void>.delayed(Duration(seconds: 1 << (attempts - 1)));
      }
    }
  }

  /// Count records in a table with optional filter.
  Future<int> count(String table, {Map<String, dynamic>? filter}) async {
    var query = _client.from(table).select();
    if (filter != null) {
      for (final entry in filter.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }
    final response = await query.count(CountOption.exact);
    return response.count;
  }

  /// Get counts grouped by a column.
  Future<Map<String, int>> countGroupBy(String table, String column) async {
    final response =
        await _client.from(table).select(column).not(column, 'is', null);

    final counts = <String, int>{};
    for (final row in response) {
      final value = row[column] as String?;
      if (value != null) {
        counts[value] = (counts[value] ?? 0) + 1;
      }
    }
    return counts;
  }

  /// Close the client connection.
  Future<void> close() async {
    await _client.dispose();
  }
}

/// Result of a batch upsert operation.
class BatchUpsertResult {
  BatchUpsertResult({
    required this.inserted,
    required this.updated,
    required this.errors,
    required this.dryRun,
    required this.total,
  });

  final int inserted;
  final int updated;
  final List<BatchError> errors;
  final bool dryRun;
  final int total;

  int get successful => total - errors.length * 500; // Approximate
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    if (dryRun) {
      return 'BatchUpsertResult(dryRun: $total records validated)';
    }
    final buffer = StringBuffer('BatchUpsertResult(processed: $total');
    if (hasErrors) {
      buffer.write(', errors: ${errors.length} batches');
    }
    buffer.writeln(')');
    if (hasErrors) {
      const maxSamples = 5;
      final samples = errors.take(maxSamples).toList();
      buffer
          .writeln('  Error samples (${samples.length} of ${errors.length}):');
      for (final error in samples) {
        buffer.writeln('    $error');
      }
      if (errors.length > maxSamples) {
        buffer.writeln('    ...');
      }
    }
    return buffer.toString().trimRight();
  }
}

/// Error from a batch operation.
class BatchError {
  BatchError({
    required this.batchIndex,
    required this.message,
    this.details,
  });

  final int batchIndex;
  final String message;
  final String? details;

  @override
  String toString() =>
      'Batch $batchIndex: $message${details != null ? ' ($details)' : ''}';
}
