import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class OfferRepository {
  OfferRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(OfferRecord offer) async {
    await _client.from('offers').insert({
      'id': offer.id,
      'inquiry_id': offer.inquiryId,
      'provider_company_id': offer.providerCompanyId,
      'provider_user_id': offer.providerUserId,
      'status': offer.status,
      'pdf_path': offer.pdfPath,
      'forwarded_at': offer.forwardedAt?.toIso8601String(),
      'resolved_at': offer.resolvedAt?.toIso8601String(),
      'buyer_decision': offer.buyerDecision,
      'provider_decision': offer.providerDecision,
      'created_at': offer.createdAt.toIso8601String(),
    });
  }

  Future<List<OfferRecord>> listByInquiry(String inquiryId) async {
    final rows = await _client
        .from('offers')
        .select()
        .eq('inquiry_id', inquiryId)
        .order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<OfferRecord?> findById(String id) async {
    final rows =
        await _client.from('offers').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> updateStatus({
    required String id,
    required String status,
    String? buyerDecision,
    String? providerDecision,
    DateTime? forwardedAt,
    DateTime? resolvedAt,
  }) async {
    await _client.from('offers').update({
      'status': status,
      'buyer_decision': buyerDecision,
      'provider_decision': providerDecision,
      'forwarded_at': forwardedAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    }).eq('id', id);
  }

  Future<int> countByProvider({
    required String companyId,
    String? status,
  }) async {
    var query =
        _client.from('offers').select('id').eq('provider_company_id', companyId);
    if (status != null) {
      query = query.eq('status', status);
    }
    final rows = await query as List<dynamic>;
    return rows.length;
  }

  OfferRecord _mapRow(Map<String, dynamic> row) {
    return OfferRecord(
      id: row['id'] as String,
      inquiryId: row['inquiry_id'] as String,
      providerCompanyId: row['provider_company_id'] as String,
      providerUserId: row['provider_user_id'] as String?,
      status: row['status'] as String,
      pdfPath: row['pdf_path'] as String?,
      forwardedAt: parseDateOrNull(row['forwarded_at']),
      resolvedAt: parseDateOrNull(row['resolved_at']),
      buyerDecision: row['buyer_decision'] as String?,
      providerDecision: row['provider_decision'] as String?,
      createdAt: parseDate(row['created_at']),
    );
  }
}
