// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/services/registration_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET', defaultValue: 'som_dev_secret'),
    users: context.read(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final registration = context.read<RegistrationService>();
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final companyJson = body['company'] as Map<String, dynamic>? ?? {};
  final usersJson = body['users'] as List<dynamic>? ?? [];
  try {
    await registration.registerCompany(
      companyJson: companyJson,
      usersJson: usersJson,
      allowIncomplete: true,
    );
    return Response(statusCode: 200);
  } on RegistrationException catch (error) {
    return Response.json(statusCode: 400, body: error.message);
  }
}
