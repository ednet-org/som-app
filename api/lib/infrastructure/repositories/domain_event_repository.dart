import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class DomainEventRepository {
  DomainEventRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(DomainEventRecord event) async {
    await _client.from('domain_events').insert({
      'id': event.id,
      'type': event.type,
      'status': event.status,
      'entity_type': event.entityType,
      'entity_id': event.entityId,
      'actor_id': event.actorId,
      'payload': event.payload,
      'created_at': event.createdAt.toIso8601String(),
    });
  }

  Future<List<DomainEventRecord>> listRecent({int limit = 50}) async {
    final rows = await _client
        .from('domain_events')
        .select()
        .order('created_at', ascending: false)
        .limit(limit) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  DomainEventRecord _mapRow(Map<String, dynamic> row) {
    return DomainEventRecord(
      id: row['id'] as String,
      type: row['type'] as String,
      status: row['status'] as String,
      entityType: row['entity_type'] as String,
      entityId: row['entity_id'] as String,
      actorId: row['actor_id'] as String?,
      payload: row['payload'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(row['created_at'] as String).toUtc(),
    );
  }
}
