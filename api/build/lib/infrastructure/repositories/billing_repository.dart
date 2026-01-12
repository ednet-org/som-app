import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class BillingRepository {
  BillingRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(BillingRecord record) async {
    await _client.from('billing_records').insert({
      'id': record.id,
      'company_id': record.companyId,
      'amount_in_subunit': record.amountInSubunit,
      'currency': record.currency,
      'status': record.status,
      'period_start': record.periodStart.toIso8601String(),
      'period_end': record.periodEnd.toIso8601String(),
      'created_at': record.createdAt.toIso8601String(),
      'paid_at': record.paidAt?.toIso8601String(),
    });
  }

  Future<List<BillingRecord>> list({String? companyId}) async {
    var query = _client.from('billing_records').select();
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }
    final rows =
        await query.order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<BillingRecord?> findById(String id) async {
    final rows = await _client.from('billing_records').select().eq('id', id)
        as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> update(BillingRecord record) async {
    await _client.from('billing_records').update({
      'amount_in_subunit': record.amountInSubunit,
      'currency': record.currency,
      'status': record.status,
      'period_start': record.periodStart.toIso8601String(),
      'period_end': record.periodEnd.toIso8601String(),
      'paid_at': record.paidAt?.toIso8601String(),
    }).eq('id', record.id);
  }

  BillingRecord _mapRow(Map<String, dynamic> row) {
    return BillingRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      amountInSubunit: row['amount_in_subunit'] as int,
      currency: row['currency'] as String,
      status: row['status'] as String,
      periodStart: parseDate(row['period_start']),
      periodEnd: parseDate(row['period_end']),
      createdAt: parseDate(row['created_at']),
      paidAt: parseDateOrNull(row['paid_at']),
    );
  }
}
