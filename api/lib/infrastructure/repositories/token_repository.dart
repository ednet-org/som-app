import '../db.dart';

class TokenRecord {
  TokenRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.tokenHash,
    required this.expiresAt,
    required this.createdAt,
    this.usedAt,
  });

  final String id;
  final String userId;
  final String type;
  final String tokenHash;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? usedAt;
}

class RefreshTokenRecord {
  RefreshTokenRecord({
    required this.id,
    required this.userId,
    required this.tokenHash,
    required this.expiresAt,
    required this.createdAt,
    this.revokedAt,
  });

  final String id;
  final String userId;
  final String tokenHash;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? revokedAt;
}

class TokenRepository {
  TokenRepository(this._db);

  final Database _db;

  void create(TokenRecord record) {
    _db.execute(
      '''
      INSERT INTO user_tokens (
        id, user_id, type, token_hash, expires_at, created_at, used_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        record.id,
        record.userId,
        record.type,
        record.tokenHash,
        record.expiresAt.toIso8601String(),
        record.createdAt.toIso8601String(),
        record.usedAt?.toIso8601String(),
      ],
    );
  }

  TokenRecord? findValidByHash(String type, String tokenHash) {
    final rows = _db.select(
      '''
      SELECT * FROM user_tokens
      WHERE type = ? AND token_hash = ? AND used_at IS NULL
      ''',
      [type, tokenHash],
    );
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  List<TokenRecord> findExpiringSoon(String type, DateTime before) {
    final rows = _db.select(
      '''
      SELECT * FROM user_tokens
      WHERE type = ? AND used_at IS NULL AND expires_at <= ?
      ''',
      [type, before.toIso8601String()],
    );
    return rows.map(_mapRow).toList();
  }

  void markUsed(String id, DateTime usedAt) {
    _db.execute(
      'UPDATE user_tokens SET used_at = ? WHERE id = ?',
      [usedAt.toIso8601String(), id],
    );
  }

  void deleteExpired(DateTime now) {
    _db.execute(
      'DELETE FROM user_tokens WHERE used_at IS NULL AND expires_at < ?',
      [now.toIso8601String()],
    );
  }

  void createRefresh(RefreshTokenRecord record) {
    _db.execute(
      '''
      INSERT INTO refresh_tokens (
        id, user_id, token_hash, expires_at, created_at, revoked_at
      ) VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [
        record.id,
        record.userId,
        record.tokenHash,
        record.expiresAt.toIso8601String(),
        record.createdAt.toIso8601String(),
        record.revokedAt?.toIso8601String(),
      ],
    );
  }

  RefreshTokenRecord? findRefreshByHash(String tokenHash) {
    final rows = _db.select(
      'SELECT * FROM refresh_tokens WHERE token_hash = ?',
      [tokenHash],
    );
    if (rows.isEmpty) {
      return null;
    }
    return _mapRefreshRow(rows.first);
  }

  void revokeRefresh(String id, DateTime revokedAt) {
    _db.execute(
      'UPDATE refresh_tokens SET revoked_at = ? WHERE id = ?',
      [revokedAt.toIso8601String(), id],
    );
  }

  TokenRecord _mapRow(Map<String, Object?> row) {
    return TokenRecord(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      type: row['type'] as String,
      tokenHash: row['token_hash'] as String,
      expiresAt: DateTime.parse(row['expires_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      usedAt: row['used_at'] == null
          ? null
          : DateTime.parse(row['used_at'] as String),
    );
  }

  RefreshTokenRecord _mapRefreshRow(Map<String, Object?> row) {
    return RefreshTokenRecord(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      tokenHash: row['token_hash'] as String,
      expiresAt: DateTime.parse(row['expires_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      revokedAt: row['revoked_at'] == null
          ? null
          : DateTime.parse(row['revoked_at'] as String),
    );
  }
}
