import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class RequestAuth {
  RequestAuth({required this.userId, required this.companyId, required this.roles, required this.activeRole});
  final String userId;
  final String companyId;
  final List<String> roles;
  final String activeRole;
}

RequestAuth? parseAuth(RequestContext context, {required String secret}) {
  final header = context.request.headers['authorization'];
  if (header == null || !header.startsWith('Bearer ')) {
    return null;
  }
  final token = header.substring(7);
  final jwt = JWT.verify(token, SecretKey(secret));
  final payload = jwt.payload as Map<String, dynamic>;
  return RequestAuth(
    userId: payload['sub'] as String,
    companyId: payload['companyId'] as String,
    roles: (payload['roles'] as List<dynamic>).map((e) => e.toString()).toList(),
    activeRole: payload['activeRole'] as String,
  );
}
