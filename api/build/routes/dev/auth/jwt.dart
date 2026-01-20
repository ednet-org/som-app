// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';

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
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final email = (jsonBody['email'] as String? ?? '').trim().toLowerCase();
  if (email.isEmpty) {
    return Response.json(statusCode: 400, body: {'error': 'email required'});
  }
  final user = await context.read<UserRepository>().findByEmail(email);
  if (user == null) {
    return Response.json(statusCode: 404, body: {'error': 'user not found'});
  }
  const secret = String.fromEnvironment(
    'SUPABASE_JWT_SECRET',
    defaultValue: 'som_dev_secret',
  );
  final jwt = JWT(
    {
      'sub': user.id,
      'email': user.email,
      'role': user.roles.isNotEmpty ? user.roles.first : '',
    },
    issuer: 'som-dev',
  );
  final token = jwt.sign(
    SecretKey(secret),
    expiresIn: const Duration(hours: 2),
  );
  return Response.json(body: {'token': token});
}
