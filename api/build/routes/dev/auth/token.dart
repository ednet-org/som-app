// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/auth_service.dart';

bool _isDevToolsEnabled() {
  final devFixtures = const bool.fromEnvironment(
        'DEV_FIXTURES',
        defaultValue: false,
      ) ||
      (Platform.environment['DEV_FIXTURES'] ?? '').toLowerCase() == 'true';
  final devTools = const bool.fromEnvironment(
        'DEV_TOOLS',
        defaultValue: false,
      ) ||
      (Platform.environment['DEV_TOOLS'] ?? '').toLowerCase() == 'true';
  final supabaseUrl =
      (Platform.environment['SUPABASE_URL'] ?? '').toLowerCase();
  final isLocalSupabase =
      supabaseUrl.contains('localhost') || supabaseUrl.contains('127.0.0.1');
  return devFixtures || devTools || isLocalSupabase;
}

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  if (!_isDevToolsEnabled()) {
    return Response(statusCode: 404);
  }
  final auth = context.read<AuthService>();
  final users = context.read<UserRepository>();
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final email = (jsonBody['email'] as String? ?? '').trim().toLowerCase();
  final type = (jsonBody['type'] as String? ?? 'confirm_email').trim();
  if (email.isEmpty) {
    return Response.json(statusCode: 400, body: {'error': 'email required'});
  }
  final user = await users.findByEmail(email);
  if (user == null) {
    return Response.json(statusCode: 404, body: {'error': 'user not found'});
  }
  late final String token;
  if (type == 'confirm_email') {
    token = await auth.createRegistrationToken(user);
  } else if (type == 'reset_password') {
    token = await auth.createPasswordResetToken(email);
    if (token.isEmpty) {
      return Response.json(statusCode: 404, body: {'error': 'user not found'});
    }
  } else {
    return Response.json(statusCode: 400, body: {'error': 'invalid type'});
  }
  return Response.json(body: {'token': token});
}
