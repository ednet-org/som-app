// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final userRepo = context.read<UserRepository>();
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET', defaultValue: 'som_dev_secret'),
    users: userRepo,
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final role = body['role'] as String? ?? '';
  final user = await userRepo.findById(auth.userId);
  if (user == null || !user.roles.contains(role)) {
    return Response(statusCode: 403);
  }
  await userRepo.updateLastLoginRole(user.id, role);
  return Response.json(body: {'token': context.request.headers['authorization']?.substring(7) ?? ''});
}
