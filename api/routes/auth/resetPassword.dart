// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = context.read<AuthService>();
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final email = (jsonBody['email'] as String? ?? '').trim();
  final token = jsonBody['token'] as String? ?? '';
  final password = jsonBody['password'] as String? ?? '';
  final confirmPassword = jsonBody['confirmPassword'] as String? ?? '';
  try {
    await auth.resetPassword(
      emailAddress: email,
      token: token,
      password: password,
      confirmPassword: confirmPassword,
    );
    return Response(statusCode: 200);
  } on AuthException catch (error) {
    return Response.json(statusCode: 400, body: error.message);
  }
}
