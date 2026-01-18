import 'package:supabase/supabase.dart';

import '../../utils/name_normalizer.dart';

class BranchRecord {
  BranchRecord({
    required this.id,
    required this.name,
    required this.status,
    this.externalId,
    this.normalizedName,
  });
  final String id;
  final String name;
  final String status;
  final String? externalId;
  final String? normalizedName;
}

class CategoryRecord {
  CategoryRecord({
    required this.id,
    required this.branchId,
    required this.name,
    required this.status,
    this.externalId,
    this.normalizedName,
  });
  final String id;
  final String branchId;
  final String name;
  final String status;
  final String? externalId;
  final String? normalizedName;
}

class BranchRepository {
  BranchRepository(this._client);

  final SupabaseClient _client;

  Future<BranchRecord?> findBranchById(String branchId) async {
    final rows = await _client
        .from('branches')
        .select()
        .eq('id', branchId)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return BranchRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      status: row['status'] as String? ?? 'active',
      externalId: row['external_id'] as String?,
      normalizedName: row['normalized_name'] as String?,
    );
  }

  Future<void> createBranch(BranchRecord branch) async {
    await _client.from('branches').insert({
      'id': branch.id,
      'name': branch.name,
      'external_id': branch.externalId,
      'normalized_name': branch.normalizedName ?? normalizeName(branch.name),
      'status': branch.status,
    });
  }

  Future<void> updateBranchName(String branchId, String name) async {
    await updateBranch(branchId, name: name);
  }

  Future<void> createCategory(CategoryRecord category) async {
    await _client.from('categories').insert({
      'id': category.id,
      'branch_id': category.branchId,
      'name': category.name,
      'external_id': category.externalId,
      'normalized_name':
          category.normalizedName ?? normalizeName(category.name),
      'status': category.status,
    });
  }

  Future<CategoryRecord?> findCategoryById(String categoryId) async {
    final rows = await _client
        .from('categories')
        .select()
        .eq('id', categoryId)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return CategoryRecord(
      id: row['id'] as String,
      branchId: row['branch_id'] as String,
      name: row['name'] as String,
      status: row['status'] as String? ?? 'active',
      externalId: row['external_id'] as String?,
      normalizedName: row['normalized_name'] as String?,
    );
  }

  Future<void> updateCategoryName(String categoryId, String name) async {
    await updateCategory(categoryId, name: name);
  }

  Future<List<BranchRecord>> listBranches() async {
    final rows =
        await _client.from('branches').select().order('name') as List<dynamic>;
    return rows
        .map((row) => BranchRecord(
              id: (row as Map<String, dynamic>)['id'] as String,
              name: row['name'] as String,
              status: row['status'] as String? ?? 'active',
              externalId: row['external_id'] as String?,
              normalizedName: row['normalized_name'] as String?,
            ))
        .toList();
  }

  Future<List<CategoryRecord>> listCategories(String branchId) async {
    final rows = await _client
        .from('categories')
        .select()
        .eq('branch_id', branchId)
        .order('name') as List<dynamic>;
    return rows
        .map((row) => CategoryRecord(
              id: (row as Map<String, dynamic>)['id'] as String,
              branchId: row['branch_id'] as String,
              name: row['name'] as String,
              status: row['status'] as String? ?? 'active',
              externalId: row['external_id'] as String?,
              normalizedName: row['normalized_name'] as String?,
            ))
        .toList();
  }

  Future<BranchRecord?> findBranchByName(String name) async {
    return findBranchByNormalizedName(normalizeName(name));
  }

  Future<BranchRecord?> findBranchByNormalizedName(String normalized) async {
    final rows = await _client
        .from('branches')
        .select()
        .eq('normalized_name', normalized)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return BranchRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      status: row['status'] as String? ?? 'active',
      externalId: row['external_id'] as String?,
      normalizedName: row['normalized_name'] as String?,
    );
  }

  Future<CategoryRecord?> findCategory(String branchId, String name) async {
    return findCategoryByNormalizedName(branchId, normalizeName(name));
  }

  Future<CategoryRecord?> findCategoryByNormalizedName(
    String branchId,
    String normalized,
  ) async {
    final rows = await _client
        .from('categories')
        .select()
        .eq('branch_id', branchId)
        .eq('normalized_name', normalized)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return CategoryRecord(
      id: row['id'] as String,
      branchId: row['branch_id'] as String,
      name: row['name'] as String,
      status: row['status'] as String? ?? 'active',
      externalId: row['external_id'] as String?,
      normalizedName: row['normalized_name'] as String?,
    );
  }

  Future<void> updateBranch(
    String branchId, {
    String? name,
    String? status,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) {
      payload['name'] = name;
      payload['normalized_name'] = normalizeName(name);
    }
    if (status != null) {
      payload['status'] = status;
    }
    if (payload.isEmpty) {
      return;
    }
    await _client.from('branches').update(payload).eq('id', branchId);
  }

  Future<void> updateCategory(
    String categoryId, {
    String? name,
    String? status,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) {
      payload['name'] = name;
      payload['normalized_name'] = normalizeName(name);
    }
    if (status != null) {
      payload['status'] = status;
    }
    if (payload.isEmpty) {
      return;
    }
    await _client.from('categories').update(payload).eq('id', categoryId);
  }

  Future<void> deleteBranch(String branchId) async {
    await _client.from('categories').delete().eq('branch_id', branchId);
    await _client.from('branches').delete().eq('id', branchId);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _client.from('categories').delete().eq('id', categoryId);
  }
}
