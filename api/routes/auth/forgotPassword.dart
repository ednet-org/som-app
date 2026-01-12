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
  await auth.sendForgotPassword(email);
  return Response.json(body: 'OK');
}
