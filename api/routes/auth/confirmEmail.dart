// ignore_for_file: file_names

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = context.read<AuthService>();
  final params = context.request.uri.queryParameters;
  final token = params['token'] ?? '';
  final email = params['email'] ?? '';
  try {
    await auth.confirmEmail(emailAddress: email, token: token);
    return Response(statusCode: 200);
  } on AuthException catch (error) {
    return Response.json(statusCode: 400, body: error.message);
  }
}
