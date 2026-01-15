import 'package:supabase/supabase.dart';

import '../models/models.dart';

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
    final assignmentCount = await _countAssignments(
      companyId: companyId,
      from: from,
      to: to,
    );
    final totalOffers = await _countOffersTotal(
      companyId: companyId,
      from: from,
      to: to,
    );
    final openCount = (assignmentCount - totalOffers).clamp(0, assignmentCount);
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
    final ignoredCount = await _countOffers(
      companyId: companyId,
      from: from,
      to: to,
      status: 'ignored',
    );
    return {
      'open': openCount,
      'offer_created': createdCount,
      'lost': lostCount,
      'won': wonCount,
      'ignored': ignoredCount,
    };
  }

  Future<Map<String, int>> consultantStatusStats({
    DateTime? from,
    DateTime? to,
  }) async {
    final openCount = await _countInquiries(from: from, to: to, status: 'open');
    final closedCount =
        await _countInquiries(from: from, to: to, status: 'closed');
    final wonCount = await _countOffersGlobal(
      from: from,
      to: to,
      status: 'accepted',
    );
    final lostCount = await _countOffersGlobal(
      from: from,
      to: to,
      status: 'rejected',
    );
    return {
      'open': openCount,
      'closed': closedCount,
      'won': wonCount,
      'lost': lostCount,
    };
  }

  Future<Map<String, int>> consultantPeriodStats({
    DateTime? from,
    DateTime? to,
  }) async {
    final inquiries = await _listInquiries(from: from, to: to);
    final Map<String, int> buckets = {};
    for (final inquiry in inquiries) {
      final key =
          '${inquiry.createdAt.year}-${inquiry.createdAt.month.toString().padLeft(2, '0')}';
      buckets[key] = (buckets[key] ?? 0) + 1;
    }
    return buckets;
  }

  Future<Map<String, int>> consultantProviderTypeStats({
    DateTime? from,
    DateTime? to,
  }) async {
    final inquiries = await _listInquiries(from: from, to: to);
    final Map<String, int> buckets = {};
    for (final inquiry in inquiries) {
      final key = inquiry.providerCriteria.providerType ?? 'unknown';
      buckets[key] = (buckets[key] ?? 0) + 1;
    }
    return buckets;
  }

  Future<Map<String, int>> consultantProviderSizeStats({
    DateTime? from,
    DateTime? to,
  }) async {
    final inquiries = await _listInquiries(from: from, to: to);
    final Map<String, int> buckets = {};
    for (final inquiry in inquiries) {
      final key = inquiry.providerCriteria.companySize ?? 'unknown';
      buckets[key] = (buckets[key] ?? 0) + 1;
    }
    return buckets;
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

  Future<int> _countOffersTotal({
    required String companyId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query =
        _client.from('offers').select('id').eq('provider_company_id', companyId);
    if (from != null) {
      query = query.gte('created_at', from.toIso8601String());
    }
    if (to != null) {
      query = query.lte('created_at', to.toIso8601String());
    }
    final rows = await query as List<dynamic>;
    return rows.length;
  }

  Future<int> _countAssignments({
    required String companyId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query = _client
        .from('inquiry_assignments')
        .select('id')
        .eq('provider_company_id', companyId);
    if (from != null) {
      query = query.gte('assigned_at', from.toIso8601String());
    }
    if (to != null) {
      query = query.lte('assigned_at', to.toIso8601String());
    }
    final rows = await query as List<dynamic>;
    return rows.length;
  }

  Future<int> _countOffersGlobal({
    DateTime? from,
    DateTime? to,
    required String status,
  }) async {
    var query = _client.from('offers').select('id').eq('status', status);
    if (from != null) {
      query = query.gte('created_at', from.toIso8601String());
    }
    if (to != null) {
      query = query.lte('created_at', to.toIso8601String());
    }
    final rows = await query as List<dynamic>;
    return rows.length;
  }

  Future<List<InquiryRecord>> _listInquiries({
    DateTime? from,
    DateTime? to,
  }) async {
    var query = _client.from('inquiries').select();
    if (from != null) {
      query = query.gte('created_at', from.toIso8601String());
    }
    if (to != null) {
      query = query.lte('created_at', to.toIso8601String());
    }
    final rows = await query as List<dynamic>;
    return rows.map((row) => _mapInquiry(row as Map<String, dynamic>)).toList();
  }

  InquiryRecord _mapInquiry(Map<String, dynamic> row) {
    return InquiryRecord(
      id: row['id'] as String,
      buyerCompanyId: row['buyer_company_id'] as String,
      createdByUserId: row['created_by_user_id'] as String,
      status: row['status'] as String,
      branchId: row['branch_id'] as String,
      categoryId: row['category_id'] as String,
      productTags: decodeJsonList(row['product_tags_json'])
          .map((e) => e.toString())
          .toList(),
      deadline: parseDate(row['deadline']),
      deliveryZips: decodeStringList(row['delivery_zips']),
      numberOfProviders: row['number_of_providers'] as int,
      description: row['description'] as String?,
      pdfPath: row['pdf_path'] as String?,
      providerCriteria: ProviderCriteria.fromJson(
        decodeJsonMap(row['provider_criteria_json']),
      ),
      contactInfo: ContactInfo.fromJson(
        decodeJsonMap(row['contact_json']),
      ),
      notifiedAt: parseDateOrNull(row['notified_at']),
      assignedAt: parseDateOrNull(row['assigned_at']),
      closedAt: parseDateOrNull(row['closed_at']),
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }
}
