import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final _log = Logger('JwksService');

/// Service for fetching and caching JWKS (JSON Web Key Set) from Supabase.
///
/// Supabase projects created after May 2025 use asymmetric JWT signing (ES256/RS256)
/// instead of symmetric HS256. This service fetches the public keys from the JWKS
/// endpoint for JWT verification.
class JwksService {
  JwksService({required this.supabaseUrl});

  final String supabaseUrl;

  /// Cached JWKS keys by key ID
  final Map<String, JWTKey> _keyCache = {};

  /// Cache expiration time
  DateTime? _cacheExpiry;

  /// Cache TTL - 1 hour
  static const _cacheTtl = Duration(hours: 1);

  /// Get the JWKS endpoint URL
  String get jwksUrl => '$supabaseUrl/auth/v1/.well-known/jwks.json';

  /// Fetch the public key for JWT verification.
  ///
  /// Returns the key matching the given [kid] (key ID), or any available key
  /// if [kid] is null.
  Future<JWTKey?> getPublicKey({String? kid}) async {
    // Check if cache is valid
    if (_cacheExpiry != null &&
        DateTime.now().isBefore(_cacheExpiry!) &&
        _keyCache.isNotEmpty) {
      if (kid != null && _keyCache.containsKey(kid)) {
        return _keyCache[kid];
      }
      if (kid == null && _keyCache.isNotEmpty) {
        return _keyCache.values.first;
      }
    }

    // Fetch fresh JWKS
    await _fetchJwks();

    if (kid != null) {
      return _keyCache[kid];
    }
    return _keyCache.isNotEmpty ? _keyCache.values.first : null;
  }

  /// Fetch JWKS from Supabase and update cache
  Future<void> _fetchJwks() async {
    try {
      _log.info('Fetching JWKS from $jwksUrl');
      final response = await http.get(Uri.parse(jwksUrl));

      if (response.statusCode != 200) {
        _log.severe('Failed to fetch JWKS: ${response.statusCode}');
        return;
      }

      final jwks = json.decode(response.body) as Map<String, dynamic>;
      final keys = jwks['keys'] as List<dynamic>?;

      if (keys == null || keys.isEmpty) {
        _log.warning('No keys found in JWKS response');
        return;
      }

      _keyCache.clear();

      for (final keyData in keys) {
        final jwk = keyData as Map<String, dynamic>;
        final kid = jwk['kid'] as String?;

        try {
          final key = JWTKey.fromJWK(jwk);
          if (kid != null) {
            _keyCache[kid] = key;
            _log.info('Cached key: $kid (${jwk['alg']})');
          }
        } catch (e) {
          _log.warning('Failed to parse JWK: $e');
        }
      }

      _cacheExpiry = DateTime.now().add(_cacheTtl);
      _log.info('JWKS cache updated with ${_keyCache.length} keys');
    } catch (e, st) {
      _log.severe('Error fetching JWKS', e, st);
    }
  }

  /// Clear the JWKS cache (useful for testing or force refresh)
  void clearCache() {
    _keyCache.clear();
    _cacheExpiry = null;
  }
}

/// Global JWKS service instance (initialized from middleware)
JwksService? _jwksService;

/// Get or create the JWKS service singleton
JwksService getJwksService(String supabaseUrl) {
  _jwksService ??= JwksService(supabaseUrl: supabaseUrl);
  return _jwksService!;
}
