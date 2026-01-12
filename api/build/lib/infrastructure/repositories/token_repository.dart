import 'package:supabase/supabase.dart';

import '../../models/models.dart';

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
  TokenRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(TokenRecord record) async {
    await _client.from('user_tokens').insert({
      'id': record.id,
      'user_id': record.userId,
      'type': record.type,
      'token_hash': record.tokenHash,
      'expires_at': record.expiresAt.toIso8601String(),
      'created_at': record.createdAt.toIso8601String(),
      'used_at': record.usedAt?.toIso8601String(),
    });
  }

  Future<TokenRecord?> findValidByHash(String type, String tokenHash) async {
    final rows = await _client
        .from('user_tokens')
        .select()
        .eq('type', type)
        .eq('token_hash', tokenHash)
        .isFilter('used_at', null) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<List<TokenRecord>> findExpiringSoon(
    String type,
    DateTime before,
  ) async {
    final rows = await _client
        .from('user_tokens')
        .select()
        .eq('type', type)
        .isFilter('used_at', null)
        .lte('expires_at', before.toIso8601String()) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<void> markUsed(String id, DateTime usedAt) async {
    await _client.from('user_tokens').update({
      'used_at': usedAt.toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteExpired(DateTime now) async {
    await _client
        .from('user_tokens')
        .delete()
        .isFilter('used_at', null)
        .lt('expires_at', now.toIso8601String());
  }

  Future<void> createRefresh(RefreshTokenRecord record) async {
    await _client.from('refresh_tokens').insert({
      'id': record.id,
      'user_id': record.userId,
      'token_hash': record.tokenHash,
      'expires_at': record.expiresAt.toIso8601String(),
      'created_at': record.createdAt.toIso8601String(),
      'revoked_at': record.revokedAt?.toIso8601String(),
    });
  }

  Future<RefreshTokenRecord?> findRefreshByHash(String tokenHash) async {
    final rows = await _client
        .from('refresh_tokens')
        .select()
        .eq('token_hash', tokenHash) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRefreshRow(rows.first as Map<String, dynamic>);
  }

  Future<void> revokeRefresh(String id, DateTime revokedAt) async {
    await _client.from('refresh_tokens').update({
      'revoked_at': revokedAt.toIso8601String(),
    }).eq('id', id);
  }

  TokenRecord _mapRow(Map<String, dynamic> row) {
    return TokenRecord(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      type: row['type'] as String,
      tokenHash: row['token_hash'] as String,
      expiresAt: parseDate(row['expires_at']),
      createdAt: parseDate(row['created_at']),
      usedAt: parseDateOrNull(row['used_at']),
    );
  }

  RefreshTokenRecord _mapRefreshRow(Map<String, dynamic> row) {
    return RefreshTokenRecord(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      tokenHash: row['token_hash'] as String,
      expiresAt: parseDate(row['expires_at']),
      createdAt: parseDate(row['created_at']),
      revokedAt: parseDateOrNull(row['revoked_at']),
    );
  }
}
