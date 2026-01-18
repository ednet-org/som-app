import 'package:supabase/supabase.dart';

class CompanyTaxonomyRepository {
  CompanyTaxonomyRepository(this._client);

  final SupabaseClient _client;

  Future<void> replaceCompanyBranches({
    required String companyId,
    required List<String> branchIds,
    required String source,
    double? confidence,
    String status = 'active',
  }) async {
    await _client.from('company_branches').delete().eq('company_id', companyId);
    if (branchIds.isEmpty) {
      return;
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final records = branchIds
        .map((branchId) => {
              'company_id': companyId,
              'branch_id': branchId,
              'source': source,
              'confidence': confidence,
              'status': status,
              'created_at': now,
              'updated_at': now,
            })
        .toList();
    await _client.from('company_branches').insert(records);
  }

  Future<void> replaceCompanyCategories({
    required String companyId,
    required List<String> categoryIds,
    required String source,
    double? confidence,
    String status = 'active',
  }) async {
    await _client
        .from('company_categories')
        .delete()
        .eq('company_id', companyId);
    if (categoryIds.isEmpty) {
      return;
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final records = categoryIds
        .map((categoryId) => {
              'company_id': companyId,
              'category_id': categoryId,
              'source': source,
              'confidence': confidence,
              'status': status,
              'created_at': now,
              'updated_at': now,
            })
        .toList();
    await _client.from('company_categories').insert(records);
  }

  Future<List<String>> listCompanyIdsByBranch(
    String branchId, {
    String status = 'active',
  }) async {
    final rows = await _client
        .from('company_branches')
        .select('company_id')
        .eq('branch_id', branchId)
        .eq('status', status) as List<dynamic>;
    return rows
        .map((row) => (row as Map<String, dynamic>)['company_id'] as String)
        .toList();
  }

  Future<List<String>> listCompanyIdsByCategory(
    String categoryId, {
    String status = 'active',
  }) async {
    final rows = await _client
        .from('company_categories')
        .select('company_id')
        .eq('category_id', categoryId)
        .eq('status', status) as List<dynamic>;
    return rows
        .map((row) => (row as Map<String, dynamic>)['company_id'] as String)
        .toList();
  }

  Future<void> upsertCompanyBranch({
    required String companyId,
    required String branchId,
    required String source,
    double? confidence,
    String status = 'pending',
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client.from('company_branches').upsert(
      {
        'company_id': companyId,
        'branch_id': branchId,
        'source': source,
        'confidence': confidence,
        'status': status,
        'created_at': now,
        'updated_at': now,
      },
      onConflict: 'company_id,branch_id',
    );
  }

  Future<void> upsertCompanyCategory({
    required String companyId,
    required String categoryId,
    required String source,
    double? confidence,
    String status = 'pending',
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client.from('company_categories').upsert(
      {
        'company_id': companyId,
        'category_id': categoryId,
        'source': source,
        'confidence': confidence,
        'status': status,
        'created_at': now,
        'updated_at': now,
      },
      onConflict: 'company_id,category_id',
    );
  }
}
