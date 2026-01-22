import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../infrastructure/repositories/user_repository.dart';
import 'jwks_service.dart';

class RequestAuth {
  RequestAuth(
      {required this.userId,
      required this.companyId,
      required this.roles,
      required this.activeRole});
  final String userId;
  final String companyId;
  final List<String> roles;
  final String activeRole;
}

Future<RequestAuth?> parseAuth(
  RequestContext context, {
  required String supabaseUrl,
  required UserRepository users,
}) async {
  final header = context.request.headers['authorization'];
  if (header == null || !header.startsWith('Bearer ')) {
    return null;
  }
  final token = header.substring(7);
  try {
    // Supabase projects created after May 2025 use asymmetric JWT signing (ES256/RS256)
    // We need to fetch the public key from the JWKS endpoint for verification.

    // Extract the key ID from the JWT header
    final kid = _extractKeyId(token);

    // Get the public key from the JWKS service
    final jwksService = getJwksService(supabaseUrl);
    final publicKey = await jwksService.getPublicKey(kid: kid);

    if (publicKey == null) {
      // Fallback: public key not available
      return null;
    }

    // Verify the JWT with the public key
    final jwt = JWT.verify(token, publicKey);
    final payload = jwt.payload as Map<String, dynamic>;
    final userId = payload['sub'] as String?;
    if (userId == null) {
      return null;
    }
    final user = await users.findById(userId);
    if (user == null || !user.isActive || user.lockedAt != null) {
      return null;
    }
    var activeCompanyId = user.lastLoginCompanyId ?? user.companyId;
    var membership = await users.findCompanyRole(
      userId: user.id,
      companyId: activeCompanyId,
    );
    if (membership == null && activeCompanyId != user.companyId) {
      activeCompanyId = user.companyId;
      membership = await users.findCompanyRole(
        userId: user.id,
        companyId: activeCompanyId,
      );
    }
    final roles = membership?.roles ?? user.roles;
    final lastRole = user.lastLoginRole;
    final activeRole = (lastRole != null && roles.contains(lastRole))
        ? lastRole
        : (roles.isNotEmpty ? roles.first : '');
    return RequestAuth(
      userId: user.id,
      companyId: activeCompanyId,
      roles: roles,
      activeRole: activeRole,
    );
  } on JWTException {
    return null;
  }
}

/// Extract the key ID (kid) from the JWT header.
///
/// The kid is used to find the correct public key from the JWKS.
String? _extractKeyId(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final headerBase64 = parts[0];
    final headerJson = utf8.decode(
      base64Url.decode(base64Url.normalize(headerBase64)),
    );
    final header = json.decode(headerJson) as Map<String, dynamic>;
    return header['kid'] as String?;
  } catch (_) {
    return null;
  }
}
