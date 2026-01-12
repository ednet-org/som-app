import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class UserRepository {
  UserRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(UserRecord user) async {
    await _client.from('users').insert({
      'id': user.id,
      'company_id': user.companyId,
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'salutation': user.salutation,
      'title': user.title,
      'telephone_nr': user.telephoneNr,
      'roles_json': user.roles,
      'is_active': user.isActive,
      'email_confirmed': user.emailConfirmed,
      'last_login_role': user.lastLoginRole,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    });
  }

  Future<UserRecord?> findById(String id) async {
    final rows = await _client.from('users').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<UserRecord?> findByEmail(String email) async {
    final rows = await _client
        .from('users')
        .select()
        .ilike('email', email)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<List<UserRecord>> listByCompany(String companyId) async {
    final rows = await _client
        .from('users')
        .select()
        .eq('company_id', companyId)
        .order('email') as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<List<UserRecord>> listAdminsByCompany(String companyId) async {
    final rows = await _client
        .from('users')
        .select()
        .eq('company_id', companyId)
        .contains('roles_json', ['admin']) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<List<UserRecord>> listByRole(String role) async {
    final rows =
        await _client.from('users').select().contains('roles_json', [role]) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<void> update(UserRecord user) async {
    await _client.from('users').update({
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'salutation': user.salutation,
      'title': user.title,
      'telephone_nr': user.telephoneNr,
      'roles_json': user.roles,
      'is_active': user.isActive,
      'email_confirmed': user.emailConfirmed,
      'last_login_role': user.lastLoginRole,
      'updated_at': user.updatedAt.toIso8601String(),
    }).eq('id', user.id);
  }

  Future<void> setPassword(String userId, String passwordHash) async {
    await _client.from('users').update({
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> confirmEmail(String userId) async {
    await _client.from('users').update({
      'email_confirmed': true,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> deactivate(String userId) async {
    await _client.from('users').update({
      'is_active': false,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> updateLastLoginRole(String userId, String role) async {
    await _client.from('users').update({
      'last_login_role': role,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> deleteById(String userId) async {
    await _client.from('users').delete().eq('id', userId);
  }

  UserRecord _mapRow(Map<String, dynamic> row) {
    return UserRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      email: row['email'] as String,
      firstName: row['first_name'] as String,
      lastName: row['last_name'] as String,
      salutation: row['salutation'] as String,
      title: row['title'] as String?,
      telephoneNr: row['telephone_nr'] as String?,
      roles: decodeJsonList(row['roles_json']).map((e) => e.toString()).toList(),
      isActive: row['is_active'] as bool? ?? false,
      emailConfirmed: row['email_confirmed'] as bool? ?? false,
      lastLoginRole: row['last_login_role'] as String?,
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
      passwordHash: row['password_hash'] as String?,
    );
  }
}
