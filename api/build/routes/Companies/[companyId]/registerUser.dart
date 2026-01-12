// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/mappings.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final repo = context.read<UserRepository>();
  final auth = context.read<AuthService>();
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final email = (jsonBody['email'] as String? ?? '').toLowerCase();
  if (repo.findByEmail(email) != null) {
    return Response.json(statusCode: 400, body: 'E-mail already used.');
  }
  final now = DateTime.now().toUtc();
  final user = UserRecord(
    id: const Uuid().v4(),
    companyId: companyId,
    email: email,
    firstName: jsonBody['firstName'] as String? ?? '',
    lastName: jsonBody['lastName'] as String? ?? '',
    salutation: jsonBody['salutation'] as String? ?? '',
    title: jsonBody['title'] as String?,
    telephoneNr: jsonBody['telephoneNr'] as String?,
    roles: (jsonBody['roles'] as List<dynamic>? ?? [2])
        .map((e) => e is int ? roleFromWire(e) : e.toString())
        .toList(),
    isActive: true,
    emailConfirmed: false,
    lastLoginRole: null,
    createdAt: now,
    updatedAt: now,
  );
  repo.create(user);
  await auth.createRegistrationToken(user);
  return Response(statusCode: 200);
}
