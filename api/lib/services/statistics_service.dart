import 'package:supabase/supabase.dart';

class StatisticsService {
  StatisticsService(this._client);

  final SupabaseClient _client;

  Future<Map<String, int>> buyerStats({
    required String companyId,
    String? userId,
    DateTime? from,
    DateTime? to,
  }) async {
    final openCount = await _countInquiries(
      companyId: companyId,
      userId: userId,
      from: from,
      to: to,
      status: 'open',
    );
    final closedCount = await _countInquiries(
      companyId: companyId,
      userId: userId,
      from: from,
      to: to,
      status: 'closed',
    );
    return {
      'open': openCount,
      'closed': closedCount,
    };
  }

  Future<Map<String, int>> providerStats({
    required String companyId,
    DateTime? from,
    DateTime? to,
  }) async {
    final openCount = await _countOffers(
      companyId: companyId,
      from: from,
      to: to,
      status: 'open',
    );
    final createdCount = await _countOffers(
      companyId: companyId,
      from: from,
      to: to,
      status: 'offer_uploaded',
    );
    final lostCount = await _countOffers(
      companyId: companyId,
      from: from,
      to: to,
      status: 'rejected',
    );
    final wonCount = await _countOffers(
      companyId: companyId,
      from: from,
      to: to,
      status: 'accepted',
    );
    return {
      'open': openCount,
      'offer_created': createdCount,
      'lost': lostCount,
      'won': wonCount,
      'ignored': 0,
    };
  }

  Future<Map<String, int>> consultantStatusStats({
    DateTime? from,
    DateTime? to,
  }) async {
    final openCount =
        await _countInquiries(from: from, to: to, status: 'open');
    final closedCount =
        await _countInquiries(from: from, to: to, status: 'closed');
    return {
      'open': openCount,
      'closed': closedCount,
    };
  }

  Future<int> _countInquiries({
    String? companyId,
    String? userId,
    DateTime? from,
    DateTime? to,
    required String status,
  }) async {
    var query = _client.from('inquiries').select('id').eq('status', status);
    if (companyId != null) {
      query = query.eq('buyer_company_id', companyId);
    }
    if (userId != null) {
      query = query.eq('created_by_user_id', userId);
    }
    if (from != null) {
      query = query.gte('created_at', from.toIso8601String());
    }
    if (to != null) {
      query = query.lte('created_at', to.toIso8601String());
    }
    final rows = await query as List<dynamic>;
    return rows.length;
  }

  Future<int> _countOffers({
    required String companyId,
    DateTime? from,
    DateTime? to,
    required String status,
  }) async {
    var query = _client
        .from('offers')
        .select('id')
        .eq('provider_company_id', companyId)
        .eq('status', status);
    if (from != null) {
      query = query.gte('created_at', from.toIso8601String());
    }
    if (to != null) {
      query = query.lte('created_at', to.toIso8601String());
    }
    final rows = await query as List<dynamic>;
    return rows.length;
  }
}
