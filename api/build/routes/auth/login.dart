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
    return Response.json(statusCode: 400, body: error.message);
  }
}
