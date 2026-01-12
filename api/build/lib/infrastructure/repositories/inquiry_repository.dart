import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class InquiryRepository {
  InquiryRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(InquiryRecord inquiry) async {
    await _client.from('inquiries').insert({
      'id': inquiry.id,
      'buyer_company_id': inquiry.buyerCompanyId,
      'created_by_user_id': inquiry.createdByUserId,
      'status': inquiry.status,
      'branch_id': inquiry.branchId,
      'category_id': inquiry.categoryId,
      'product_tags_json': inquiry.productTags,
      'deadline': inquiry.deadline.toIso8601String(),
      'delivery_zips': inquiry.deliveryZips,
      'number_of_providers': inquiry.numberOfProviders,
      'description': inquiry.description,
      'pdf_path': inquiry.pdfPath,
      'provider_criteria_json': inquiry.providerCriteria.toJson(),
      'contact_json': inquiry.contactInfo.toJson(),
      'notified_at': inquiry.notifiedAt?.toIso8601String(),
      'created_at': inquiry.createdAt.toIso8601String(),
      'updated_at': inquiry.updatedAt.toIso8601String(),
    });
  }

  Future<InquiryRecord?> findById(String id) async {
    final rows =
        await _client.from('inquiries').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<List<InquiryRecord>> listByBuyerCompany(String companyId) async {
    final rows = await _client
        .from('inquiries')
        .select()
        .eq('buyer_company_id', companyId)
        .order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<List<InquiryRecord>> listAll({String? status}) async {
    var query = _client.from('inquiries').select();
    if (status != null) {
      query = query.eq('status', status);
    }
    final rows =
        await query.order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<List<InquiryRecord>> listAssignedToProvider(
    String providerCompanyId,
  ) async {
    final rows = await _client
        .from('inquiries')
        .select('*, inquiry_assignments!inner(*)')
        .eq('inquiry_assignments.provider_company_id', providerCompanyId)
        .order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<void> updateStatus(String id, String status) async {
    await _client.from('inquiries').update({
      'status': status,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> markNotified(String id, DateTime notifiedAt) async {
    await _client.from('inquiries').update({
      'notified_at': notifiedAt.toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> assignToProviders({
    required String inquiryId,
    required String assignedByUserId,
    required List<String> providerCompanyIds,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    for (final providerCompanyId in providerCompanyIds) {
      await _client.from('inquiry_assignments').insert({
        'id': '${inquiryId}_$providerCompanyId',
        'inquiry_id': inquiryId,
        'provider_company_id': providerCompanyId,
        'assigned_at': now,
        'assigned_by_user_id': assignedByUserId,
      });
    }
  }

  InquiryRecord _mapRow(Map<String, dynamic> row) {
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
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }
}
