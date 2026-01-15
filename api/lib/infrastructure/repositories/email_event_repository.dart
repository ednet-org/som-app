import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class EmailEventRepository {
  EmailEventRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(EmailEventRecord event) async {
    await _client.from('email_events').insert({
      'id': event.id,
      'user_id': event.userId,
      'type': event.type,
      'created_at': event.createdAt.toIso8601String(),
    });
  }

  Future<List<EmailEventRecord>> listByUser(String userId) async {
    final rows = await _client
        .from('email_events')
        .select()
        .eq('user_id', userId)
        .order('created_at') as List<dynamic>;
    return rows
        .map((row) => _mapRow(row as Map<String, dynamic>))
        .toList();
  }

  EmailEventRecord _mapRow(Map<String, dynamic> row) {
    return EmailEventRecord(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      type: row['type'] as String,
      createdAt: parseDate(row['created_at']),
    );
  }
}
