import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class CancellationRepository {
  CancellationRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(SubscriptionCancellationRecord record) async {
    await _client.from('subscription_cancellations').insert({
      'id': record.id,
      'company_id': record.companyId,
      'requested_by_user_id': record.requestedByUserId,
      'reason': record.reason,
      'status': record.status,
      'requested_at': record.requestedAt.toIso8601String(),
      'effective_end_date': record.effectiveEndDate?.toIso8601String(),
      'resolved_at': record.resolvedAt?.toIso8601String(),
    });
  }

  Future<List<SubscriptionCancellationRecord>> list({
    String? companyId,
    String? status,
  }) async {
    var query = _client.from('subscription_cancellations').select();
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }
    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }
    final rows =
        await query.order('requested_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<SubscriptionCancellationRecord?> findById(String id) async {
    final rows = await _client
        .from('subscription_cancellations')
        .select()
        .eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> update(SubscriptionCancellationRecord record) async {
    await _client.from('subscription_cancellations').update({
      'status': record.status,
      'resolved_at': record.resolvedAt?.toIso8601String(),
      'effective_end_date': record.effectiveEndDate?.toIso8601String(),
    }).eq('id', record.id);
  }

  SubscriptionCancellationRecord _mapRow(Map<String, dynamic> row) {
    return SubscriptionCancellationRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      requestedByUserId: row['requested_by_user_id'] as String,
      reason: row['reason'] as String?,
      status: row['status'] as String,
      requestedAt: parseDate(row['requested_at']),
      effectiveEndDate: parseDateOrNull(row['effective_end_date']),
      resolvedAt: parseDateOrNull(row['resolved_at']),
    );
  }
}
