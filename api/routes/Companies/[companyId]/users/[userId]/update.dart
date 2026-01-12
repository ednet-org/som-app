import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/mappings.dart';

Future<Response> onRequest(RequestContext context, String companyId, String userId) async {
  if (context.request.method != HttpMethod.put) {
    return Response(statusCode: 405);
  }
  final repo = context.read<UserRepository>();
  final existing = await repo.findById(userId);
  if (existing == null || existing.companyId != companyId) {
    return Response(statusCode: 404);
  }
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final updated = UserRecord(
    id: existing.id,
    companyId: existing.companyId,
    email: (jsonBody['email'] as String? ?? existing.email).toLowerCase(),
    firstName: jsonBody['firstName'] as String? ?? existing.firstName,
    lastName: jsonBody['lastName'] as String? ?? existing.lastName,
    salutation: jsonBody['salutation'] as String? ?? existing.salutation,
    title: jsonBody['title'] as String? ?? existing.title,
    telephoneNr: jsonBody['telephoneNr'] as String? ?? existing.telephoneNr,
    roles: (jsonBody['roles'] as List<dynamic>? ?? existing.roles)
        .map((e) => e is int ? roleFromWire(e) : e.toString())
        .toList(),
    isActive: existing.isActive,
    emailConfirmed: existing.emailConfirmed,
    lastLoginRole: existing.lastLoginRole,
    createdAt: existing.createdAt,
    updatedAt: DateTime.now().toUtc(),
    passwordHash: existing.passwordHash,
  );
  if (existing.roles.contains('admin') && !updated.roles.contains('admin')) {
    final admins = await repo.listAdminsByCompany(companyId);
    if (admins.length <= 1) {
      return Response.json(
        statusCode: 400,
        body: 'At least one admin user is required.',
      );
    }
  }
  await repo.update(updated);
  return Response.json(body: updated.toDtoJson());
}
