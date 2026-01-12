import '../db.dart';

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
  BranchRepository(this._db);

  final Database _db;

  void createBranch(BranchRecord branch) {
    _db.execute(
      'INSERT INTO branches (id, name) VALUES (?, ?)',
      [branch.id, branch.name],
    );
  }

  void createCategory(CategoryRecord category) {
    _db.execute(
      'INSERT INTO categories (id, branch_id, name) VALUES (?, ?, ?)',
      [category.id, category.branchId, category.name],
    );
  }

  List<BranchRecord> listBranches() {
    final rows = _db.select('SELECT * FROM branches ORDER BY name');
    return rows
        .map((row) => BranchRecord(
              id: row['id'] as String,
              name: row['name'] as String,
            ))
        .toList();
  }

  List<CategoryRecord> listCategories(String branchId) {
    final rows = _db.select(
      'SELECT * FROM categories WHERE branch_id = ? ORDER BY name',
      [branchId],
    );
    return rows
        .map((row) => CategoryRecord(
              id: row['id'] as String,
              branchId: row['branch_id'] as String,
              name: row['name'] as String,
            ))
        .toList();
  }

  BranchRecord? findBranchByName(String name) {
    final rows = _db.select(
      'SELECT * FROM branches WHERE lower(name) = lower(?) LIMIT 1',
      [name],
    );
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first;
    return BranchRecord(id: row['id'] as String, name: row['name'] as String);
  }

  CategoryRecord? findCategory(String branchId, String name) {
    final rows = _db.select(
      'SELECT * FROM categories WHERE branch_id = ? AND lower(name) = lower(?) LIMIT 1',
      [branchId, name],
    );
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first;
    return CategoryRecord(
      id: row['id'] as String,
      branchId: row['branch_id'] as String,
      name: row['name'] as String,
    );
  }

  void deleteBranch(String branchId) {
    _db.execute('DELETE FROM categories WHERE branch_id = ?', [branchId]);
    _db.execute('DELETE FROM branches WHERE id = ?', [branchId]);
  }

  void deleteCategory(String categoryId) {
    _db.execute('DELETE FROM categories WHERE id = ?', [categoryId]);
  }
}
