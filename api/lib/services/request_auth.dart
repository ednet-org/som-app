import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../infrastructure/repositories/user_repository.dart';

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
  required String secret,
  required UserRepository users,
}) async {
  final header = context.request.headers['authorization'];
  if (header == null || !header.startsWith('Bearer ')) {
    return null;
  }
  final token = header.substring(7);
  try {
    final jwt = JWT.verify(token, SecretKey(secret));
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
