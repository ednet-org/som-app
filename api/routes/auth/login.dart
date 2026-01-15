import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = context.read<AuthService>();
  final body = await context.request.body();
  Map<String, dynamic> jsonBody;
  try {
    jsonBody = jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return Response.json(statusCode: 400, body: 'Invalid request body');
  }
  final email = (jsonBody['email'] as String? ?? '').trim();
  final password = jsonBody['password'] as String? ?? '';
  try {
    final tokens = await auth.login(emailAddress: email, password: password);
    return Response.json(
      body: {
        'token': tokens.accessToken,
        'refreshToken': tokens.refreshToken,
      },
    );
  } on AuthException catch (error) {
    final users = context.read<UserRepository>();
    final audit = context.read<AuditService>();
    final user = await users.findByEmail(email.toLowerCase());
    await audit.log(
      action: 'auth.login_failed',
      entityType: 'user',
      entityId: user?.id ?? email,
      actorId: user?.id,
      metadata: {
        'email': email,
        'reason': error.message,
      },
    );
    return Response.json(statusCode: 400, body: error.message);
  }
}
