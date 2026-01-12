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
  final authService = context.read<AuthService>();
  final userRepo = context.read<UserRepository>();
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final role = body['role'] as String? ?? '';
  final user = userRepo.findById(auth.userId);
  if (user == null || !user.roles.contains(role)) {
    return Response(statusCode: 403);
  }
  userRepo.updateLastLoginRole(user.id, role);
  final token = authService.issueAccessToken(user, role: role);
  return Response.json(body: {'token': token});
}
