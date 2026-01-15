// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  final body = await context.request.body();
  Map<String, dynamic> jsonBody;
  try {
    jsonBody = jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return Response.json(statusCode: 400, body: 'Invalid request body');
  }
  final currentPassword = jsonBody['currentPassword'] as String? ?? '';
  final newPassword = jsonBody['newPassword'] as String? ?? '';
  final confirmPassword = jsonBody['confirmPassword'] as String? ?? '';

  final users = context.read<UserRepository>();
  final user = await users.findById(authResult.userId);
  if (user == null) {
    return Response(statusCode: 401);
  }
  final auth = context.read<AuthService>();
  try {
    await auth.changePassword(
      userId: user.id,
      emailAddress: user.email,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    return Response.json(body: {'status': 'changed'});
  } on AuthException catch (error) {
    return Response.json(statusCode: 400, body: error.message);
  }
}
