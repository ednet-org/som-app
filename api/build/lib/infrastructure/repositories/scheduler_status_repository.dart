import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class SchedulerStatusRepository {
  SchedulerStatusRepository(this._client);

  final SupabaseClient _client;

  Future<void> recordRun({
    required String jobName,
    required DateTime runAt,
    required bool success,
    String? error,
  }) async {
    final payload = <String, dynamic>{
      'job_name': jobName,
      'last_run_at': runAt.toIso8601String(),
      'updated_at': runAt.toIso8601String(),
    };
    if (success) {
      payload['last_success_at'] = runAt.toIso8601String();
      payload['last_error'] = null;
    } else if (error != null) {
      payload['last_error'] = error;
    }
    await _client.from('scheduler_status').upsert(
          payload,
          onConflict: 'job_name',
        );
  }

  Future<List<SchedulerStatusRecord>> listAll() async {
    final rows = await _client
        .from('scheduler_status')
        .select()
        .order('job_name') as List<dynamic>;
    return rows
        .map((row) => _mapRow(row as Map<String, dynamic>))
        .toList();
  }

  SchedulerStatusRecord _mapRow(Map<String, dynamic> row) {
    return SchedulerStatusRecord(
      jobName: row['job_name'] as String,
      lastRunAt: parseDateOrNull(row['last_run_at']),
      lastSuccessAt: parseDateOrNull(row['last_success_at']),
      lastError: row['last_error'] as String?,
      updatedAt: parseDate(row['updated_at']),
    );
  }
}
