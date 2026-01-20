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
      'last_login_company_id': user.lastLoginCompanyId,
      'failed_login_attempts': user.failedLoginAttempts,
      'last_failed_login_at': user.lastFailedLoginAt?.toIso8601String(),
      'locked_at': user.lockedAt?.toIso8601String(),
      'lock_reason': user.lockReason,
      'removed_at': user.removedAt?.toIso8601String(),
      'removed_by_user_id': user.removedByUserId,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    });
    await addUserToCompany(
      userId: user.id,
      companyId: user.companyId,
      roles: user.roles,
      updateUserRoles: false,
    );
  }

  Future<UserRecord?> findById(String id, {String? companyId}) async {
    final rows =
        await _client.from('users').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final user = _mapRow(rows.first as Map<String, dynamic>);
    if (companyId == null) {
      return user;
    }
    final membership =
        await findCompanyRole(userId: user.id, companyId: companyId);
    if (membership == null) {
      return null;
    }
    return _withCompanyRoles(user, companyId, membership.roles);
  }

  Future<UserRecord?> findByIdWithCompany(
    String id,
    String companyId,
  ) async {
    return findById(id, companyId: companyId);
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
    final memberships = await _client
        .from('user_company_roles')
        .select()
        .eq('company_id', companyId) as List<dynamic>;
    if (memberships.isEmpty) {
      return [];
    }
    final userIds =
        memberships.map((row) => row['user_id'] as String).toList();
    final rows = await _client
        .from('users')
        .select()
        .inFilter('id', userIds) as List<dynamic>;
    final userMap = {
      for (final row in rows)
        (row as Map<String, dynamic>)['id'] as String:
            _mapRow(row as Map<String, dynamic>)
    };
    final results = <UserRecord>[];
    for (final membership in memberships) {
      final row = membership as Map<String, dynamic>;
      final userId = row['user_id'] as String;
      final user = userMap[userId];
      if (user == null) {
        continue;
      }
      final roles =
          decodeJsonList(row['roles_json']).map((e) => e.toString()).toList();
      results.add(_withCompanyRoles(user, companyId, roles));
    }
    results.sort((a, b) => a.email.compareTo(b.email));
    return results;
  }

  Future<List<UserRecord>> listAdminsByCompany(String companyId) async {
    final users = await listByCompany(companyId);
    return users.where((user) => user.roles.contains('admin')).toList();
  }

  Future<List<UserRecord>> listByRole(String role) async {
    final rows = await _client.from('users').select() as List<dynamic>;
    return rows
        .map((row) => _mapRow(row as Map<String, dynamic>))
        .where((user) => user.roles.contains(role))
        .toList();
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
      'last_login_company_id': user.lastLoginCompanyId,
      'failed_login_attempts': user.failedLoginAttempts,
      'last_failed_login_at': user.lastFailedLoginAt?.toIso8601String(),
      'locked_at': user.lockedAt?.toIso8601String(),
      'lock_reason': user.lockReason,
      'removed_at': user.removedAt?.toIso8601String(),
      'removed_by_user_id': user.removedByUserId,
      'updated_at': user.updatedAt.toIso8601String(),
    }).eq('id', user.id);
    await updateCompanyRoles(
      userId: user.id,
      companyId: user.companyId,
      roles: user.roles,
    );
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

  Future<void> markRemoved({
    required String userId,
    required String removedByUserId,
  }) async {
    await _client.from('users').update({
      'is_active': false,
      'removed_at': DateTime.now().toUtc().toIso8601String(),
      'removed_by_user_id': removedByUserId,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> updateLastLoginRole(
    String userId,
    String role, {
    String? companyId,
  }) async {
    await _client.from('users').update({
      'last_login_role': role,
      if (companyId != null) 'last_login_company_id': companyId,
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
      roles:
          decodeJsonList(row['roles_json']).map((e) => e.toString()).toList(),
      isActive: row['is_active'] as bool? ?? false,
      emailConfirmed: row['email_confirmed'] as bool? ?? false,
      lastLoginRole: row['last_login_role'] as String?,
      lastLoginCompanyId: row['last_login_company_id'] as String?,
      failedLoginAttempts: row['failed_login_attempts'] as int? ?? 0,
      lastFailedLoginAt: parseDateOrNull(row['last_failed_login_at']),
      lockedAt: parseDateOrNull(row['locked_at']),
      lockReason: row['lock_reason'] as String?,
      removedAt: parseDateOrNull(row['removed_at']),
      removedByUserId: row['removed_by_user_id'] as String?,
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
      passwordHash: row['password_hash'] as String?,
    );
  }

  Future<UserCompanyRoleRecord?> findCompanyRole({
    required String userId,
    required String companyId,
  }) async {
    final rows = await _client
        .from('user_company_roles')
        .select()
        .eq('user_id', userId)
        .eq('company_id', companyId)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapCompanyRole(rows.first as Map<String, dynamic>);
  }

  Future<List<UserCompanyRoleRecord>> listCompanyRolesForUser(
    String userId,
  ) async {
    final rows = await _client
        .from('user_company_roles')
        .select()
        .eq('user_id', userId) as List<dynamic>;
    return rows
        .map((row) => _mapCompanyRole(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> addUserToCompany({
    required String userId,
    required String companyId,
    required List<String> roles,
    bool updateUserRoles = true,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client.from('user_company_roles').upsert({
      'user_id': userId,
      'company_id': companyId,
      'roles_json': roles,
      'created_at': now,
      'updated_at': now,
    }, onConflict: 'user_id,company_id');
    if (updateUserRoles) {
      final existing = await findById(userId);
      if (existing != null) {
        final mergedRoles = {...existing.roles, ...roles}.toList();
        await _client.from('users').update({
          'roles_json': mergedRoles,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', userId);
      }
    }
  }

  Future<void> updateCompanyRoles({
    required String userId,
    required String companyId,
    required List<String> roles,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client.from('user_company_roles').upsert({
      'user_id': userId,
      'company_id': companyId,
      'roles_json': roles,
      'updated_at': now,
      'created_at': now,
    }, onConflict: 'user_id,company_id');
  }

  UserCompanyRoleRecord _mapCompanyRole(Map<String, dynamic> row) {
    return UserCompanyRoleRecord(
      userId: row['user_id'] as String,
      companyId: row['company_id'] as String,
      roles:
          decodeJsonList(row['roles_json']).map((e) => e.toString()).toList(),
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }

  UserRecord _withCompanyRoles(
    UserRecord user,
    String companyId,
    List<String> roles,
  ) {
    return user.copyWith(companyId: companyId, roles: roles);
  }
}
