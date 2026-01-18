import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class RoleRepository {
  RoleRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(RoleRecord role) async {
    await _client.from('roles').insert({
      'id': role.id,
      'name': role.name,
      'description': role.description,
      'created_at': role.createdAt.toIso8601String(),
      'updated_at': role.updatedAt.toIso8601String(),
    });
  }

  Future<List<RoleRecord>> listAll() async {
    final rows =
        await _client.from('roles').select().order('name') as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<RoleRecord?> findById(String id) async {
    final rows =
        await _client.from('roles').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<RoleRecord?> findByName(String name) async {
    final rows = await _client
        .from('roles')
        .select()
        .ilike('name', name)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> update(RoleRecord role) async {
    await _client.from('roles').update({
      'name': role.name,
      'description': role.description,
      'updated_at': role.updatedAt.toIso8601String(),
    }).eq('id', role.id);
  }

  Future<void> delete(String id) async {
    await _client.from('roles').delete().eq('id', id);
  }

  RoleRecord _mapRow(Map<String, dynamic> row) {
    return RoleRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      description: row['description'] as String?,
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }
}
