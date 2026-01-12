import 'package:supabase/supabase.dart';

class BranchRecord {
  BranchRecord({required this.id, required this.name});
  final String id;
  final String name;
}

class CategoryRecord {
  CategoryRecord({required this.id, required this.branchId, required this.name});
  final String id;
  final String branchId;
  final String name;
}

class BranchRepository {
  BranchRepository(this._client);

  final SupabaseClient _client;

  Future<void> createBranch(BranchRecord branch) async {
    await _client.from('branches').insert({
      'id': branch.id,
      'name': branch.name,
    });
  }

  Future<void> createCategory(CategoryRecord category) async {
    await _client.from('categories').insert({
      'id': category.id,
      'branch_id': category.branchId,
      'name': category.name,
    });
  }

  Future<List<BranchRecord>> listBranches() async {
    final rows =
        await _client.from('branches').select().order('name') as List<dynamic>;
    return rows
        .map((row) => BranchRecord(
              id: (row as Map<String, dynamic>)['id'] as String,
              name: row['name'] as String,
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
            ))
        .toList();
  }

  Future<BranchRecord?> findBranchByName(String name) async {
    final rows =
        await _client.from('branches').select().ilike('name', name).limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return BranchRecord(id: row['id'] as String, name: row['name'] as String);
  }

  Future<CategoryRecord?> findCategory(String branchId, String name) async {
    final rows = await _client
        .from('categories')
        .select()
        .eq('branch_id', branchId)
        .ilike('name', name)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return CategoryRecord(
      id: row['id'] as String,
      branchId: row['branch_id'] as String,
      name: row['name'] as String,
    );
  }

  Future<void> deleteBranch(String branchId) async {
    await _client.from('categories').delete().eq('branch_id', branchId);
    await _client.from('branches').delete().eq('id', branchId);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _client.from('categories').delete().eq('id', categoryId);
  }
}
