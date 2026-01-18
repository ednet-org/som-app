import 'package:supabase/supabase.dart';

class CompanyTaxonomyRepository {
  CompanyTaxonomyRepository(this._client);

  final SupabaseClient _client;

  Future<void> replaceCompanyBranches({
    required String companyId,
    required List<String> branchIds,
    required String source,
    double? confidence,
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
              'created_at': now,
              'updated_at': now,
            })
        .toList();
    await _client.from('company_categories').insert(records);
  }

  Future<List<String>> listCompanyIdsByBranch(String branchId) async {
    final rows = await _client
        .from('company_branches')
        .select('company_id')
        .eq('branch_id', branchId) as List<dynamic>;
    return rows
        .map((row) => (row as Map<String, dynamic>)['company_id'] as String)
        .toList();
  }

  Future<List<String>> listCompanyIdsByCategory(String categoryId) async {
    final rows = await _client
        .from('company_categories')
        .select('company_id')
        .eq('category_id', categoryId) as List<dynamic>;
    return rows
        .map((row) => (row as Map<String, dynamic>)['company_id'] as String)
        .toList();
  }
}
