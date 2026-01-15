import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class AuditLogRepository {
  AuditLogRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(AuditLogRecord entry) async {
    await _client.from('audit_log').insert({
      'id': entry.id,
      'actor_id': entry.actorId,
      'action': entry.action,
      'entity_type': entry.entityType,
      'entity_id': entry.entityId,
      'metadata': entry.metadata,
      'created_at': entry.createdAt.toIso8601String(),
    });
  }

  Future<List<AuditLogRecord>> listRecent({int limit = 100}) async {
    final rows = await _client
        .from('audit_log')
        .select()
        .order('created_at', ascending: false)
        .limit(limit) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  AuditLogRecord _mapRow(Map<String, dynamic> row) {
    return AuditLogRecord(
      id: row['id'] as String,
      actorId: row['actor_id'] as String?,
      action: row['action'] as String,
      entityType: row['entity_type'] as String,
      entityId: row['entity_id'] as String,
      metadata: row['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(row['created_at'] as String).toUtc(),
    );
  }
}
