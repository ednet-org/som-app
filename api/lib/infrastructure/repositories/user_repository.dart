import '../../models/models.dart';
import '../db.dart';

class UserRepository {
  UserRepository(this._db);

  final Database _db;

  void create(UserRecord user) {
    _db.execute(
      '''
      INSERT INTO users (
        id, company_id, email, password_hash, first_name, last_name,
        salutation, title, telephone_nr, roles_json, is_active,
        email_confirmed, last_login_role, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        user.id,
        user.companyId,
        user.email,
        user.passwordHash,
        user.firstName,
        user.lastName,
        user.salutation,
        user.title,
        user.telephoneNr,
        encodeJson(user.roles),
        user.isActive ? 1 : 0,
        user.emailConfirmed ? 1 : 0,
        user.lastLoginRole,
        user.createdAt.toIso8601String(),
        user.updatedAt.toIso8601String(),
      ],
    );
  }

  UserRecord? findById(String id) {
    final rows = _db.select('SELECT * FROM users WHERE id = ?', [id]);
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  UserRecord? findByEmail(String email) {
    final rows = _db.select(
      'SELECT * FROM users WHERE lower(email) = lower(?)',
      [email],
    );
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  List<UserRecord> listByCompany(String companyId) {
    final rows = _db.select(
      'SELECT * FROM users WHERE company_id = ? ORDER BY email',
      [companyId],
    );
    return rows.map(_mapRow).toList();
  }

  List<UserRecord> listAdminsByCompany(String companyId) {
    final rows = _db.select(
      'SELECT * FROM users WHERE company_id = ? AND roles_json LIKE ?',
      [companyId, '%admin%'],
    );
    return rows.map(_mapRow).toList();
  }

  List<UserRecord> listByRole(String role) {
    final rows = _db.select(
      'SELECT * FROM users WHERE roles_json LIKE ?',
      ['%$role%'],
    );
    return rows.map(_mapRow).toList();
  }

  void update(UserRecord user) {
    _db.execute(
      '''
      UPDATE users SET
        email = ?,
        first_name = ?,
        last_name = ?,
        salutation = ?,
        title = ?,
        telephone_nr = ?,
        roles_json = ?,
        is_active = ?,
        email_confirmed = ?,
        last_login_role = ?,
        updated_at = ?
      WHERE id = ?
      ''',
      [
        user.email,
        user.firstName,
        user.lastName,
        user.salutation,
        user.title,
        user.telephoneNr,
        encodeJson(user.roles),
        user.isActive ? 1 : 0,
        user.emailConfirmed ? 1 : 0,
        user.lastLoginRole,
        user.updatedAt.toIso8601String(),
        user.id,
      ],
    );
  }

  void setPassword(String userId, String passwordHash) {
    _db.execute(
      'UPDATE users SET password_hash = ?, updated_at = ? WHERE id = ?',
      [passwordHash, DateTime.now().toUtc().toIso8601String(), userId],
    );
  }

  void confirmEmail(String userId) {
    _db.execute(
      'UPDATE users SET email_confirmed = 1, updated_at = ? WHERE id = ?',
      [DateTime.now().toUtc().toIso8601String(), userId],
    );
  }

  void deactivate(String userId) {
    _db.execute(
      'UPDATE users SET is_active = 0, updated_at = ? WHERE id = ?',
      [DateTime.now().toUtc().toIso8601String(), userId],
    );
  }

  void updateLastLoginRole(String userId, String role) {
    _db.execute(
      'UPDATE users SET last_login_role = ?, updated_at = ? WHERE id = ?',
      [role, DateTime.now().toUtc().toIso8601String(), userId],
    );
  }

  void deleteById(String userId) {
    _db.execute('DELETE FROM users WHERE id = ?', [userId]);
  }

  UserRecord _mapRow(Map<String, Object?> row) {
    return UserRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      email: row['email'] as String,
      firstName: row['first_name'] as String,
      lastName: row['last_name'] as String,
      salutation: row['salutation'] as String,
      title: row['title'] as String?,
      telephoneNr: row['telephone_nr'] as String?,
      roles: (decodeJsonList(row['roles_json'] as String))
          .map((e) => e.toString())
          .toList(),
      isActive: (row['is_active'] as int) == 1,
      emailConfirmed: (row['email_confirmed'] as int) == 1,
      lastLoginRole: row['last_login_role'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      passwordHash: row['password_hash'] as String?,
    );
  }
}
