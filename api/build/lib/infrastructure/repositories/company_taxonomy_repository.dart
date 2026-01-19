import 'package:supabase/supabase.dart';

import '../../models/models.dart';

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

  Future<CompanyTaxonomyRecord> fetchCompanyTaxonomy(
    String companyId, {
    String? status,
  }) async {
    final branchesMap = await listBranchAssignmentsForCompanies(
      [companyId],
      status: status,
    );
    final categoriesMap = await listCategoryAssignmentsForCompanies(
      [companyId],
      status: status,
    );
    return CompanyTaxonomyRecord(
      companyId: companyId,
      branches: branchesMap[companyId] ?? const [],
      categories: categoriesMap[companyId] ?? const [],
    );
  }

  Future<Map<String, List<CompanyBranchAssignmentRecord>>>
      listBranchAssignmentsForCompanies(
    List<String> companyIds, {
    String? status,
  }) async {
    if (companyIds.isEmpty) {
      return {};
    }
    var query = _client.from('company_branches').select(
          'company_id,branch_id,source,confidence,status',
        );
    query = query.inFilter('company_id', companyIds);
    if (status != null) {
      query = query.eq('status', status);
    }
    final rows = await query as List<dynamic>;
    final branchIds = rows
        .map((row) => (row as Map<String, dynamic>)['branch_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    final branchNames = await _loadBranchNames(branchIds);
    final result = <String, List<CompanyBranchAssignmentRecord>>{};
    for (final entry in rows.cast<Map<String, dynamic>>()) {
      final companyId = entry['company_id'] as String;
      final branchId = entry['branch_id'] as String;
      final source = entry['source'] as String? ?? 'unknown';
      final confidence = _asDouble(entry['confidence']);
      final statusValue = entry['status'] as String? ?? 'active';
      final assignment = CompanyBranchAssignmentRecord(
        branchId: branchId,
        branchName: branchNames[branchId] ?? branchId,
        source: source,
        confidence: confidence,
        status: statusValue,
      );
      (result[companyId] ??= []).add(assignment);
    }
    return result;
  }

  Future<Map<String, List<CompanyCategoryAssignmentRecord>>>
      listCategoryAssignmentsForCompanies(
    List<String> companyIds, {
    String? status,
  }) async {
    if (companyIds.isEmpty) {
      return {};
    }
    var query = _client.from('company_categories').select(
          'company_id,category_id,source,confidence,status',
        );
    query = query.inFilter('company_id', companyIds);
    if (status != null) {
      query = query.eq('status', status);
    }
    final rows = await query as List<dynamic>;
    final categoryIds = rows
        .map((row) => (row as Map<String, dynamic>)['category_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    final categoryInfo = await _loadCategoryInfo(categoryIds);
    final branchIds =
        categoryInfo.values.map((info) => info.branchId).toSet().toList();
    final branchNames = await _loadBranchNames(branchIds);
    final result = <String, List<CompanyCategoryAssignmentRecord>>{};
    for (final entry in rows.cast<Map<String, dynamic>>()) {
      final companyId = entry['company_id'] as String;
      final categoryId = entry['category_id'] as String;
      final source = entry['source'] as String? ?? 'unknown';
      final confidence = _asDouble(entry['confidence']);
      final statusValue = entry['status'] as String? ?? 'active';
      final info = categoryInfo[categoryId];
      final branchId = info?.branchId ?? '';
      final branchName = branchNames[branchId] ?? branchId;
      final assignment = CompanyCategoryAssignmentRecord(
        categoryId: categoryId,
        categoryName: info?.name ?? categoryId,
        branchId: branchId,
        branchName: branchName,
        source: source,
        confidence: confidence,
        status: statusValue,
      );
      (result[companyId] ??= []).add(assignment);
    }
    return result;
  }

  double? _asDouble(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  Future<Map<String, String>> _loadBranchNames(List<String> ids) async {
    if (ids.isEmpty) {
      return {};
    }
    final rows = await _client
        .from('branches')
        .select('id,name')
        .inFilter('id', ids) as List<dynamic>;
    return {
      for (final row in rows.cast<Map<String, dynamic>>())
        row['id'] as String: row['name'] as String,
    };
  }

  Future<Map<String, _CategoryInfo>> _loadCategoryInfo(
    List<String> ids,
  ) async {
    if (ids.isEmpty) {
      return {};
    }
    final rows = await _client
        .from('categories')
        .select('id,name,branch_id')
        .inFilter('id', ids) as List<dynamic>;
    return {
      for (final row in rows.cast<Map<String, dynamic>>())
        row['id'] as String: _CategoryInfo(
          name: row['name'] as String,
          branchId: row['branch_id'] as String,
        ),
    };
  }
}

class _CategoryInfo {
  _CategoryInfo({required this.name, required this.branchId});

  final String name;
  final String branchId;
}
