import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(
    RequestContext context, String companyId, String userId) async {
  if (context.request.method != HttpMethod.put) {
    return Response(statusCode: 405);
  }
  final repo = context.read<UserRepository>();
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: repo,
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  final isAdmin =
      authResult.roles.contains('admin') && authResult.companyId == companyId;
  final isSelf =
      authResult.userId == userId && authResult.companyId == companyId;
  if (!isAdmin && !isSelf) {
    return Response(statusCode: 403);
  }
  final existing = await repo.findById(userId);
  if (existing == null || existing.companyId != companyId) {
    return Response(statusCode: 404);
  }
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final canEditRoles = isAdmin;
  final updatedRoles = canEditRoles
      ? (jsonBody['roles'] as List<dynamic>? ?? existing.roles)
          .map((e) => e is int ? roleFromWire(e) : e.toString())
          .toList()
      : existing.roles;
  final normalizedRoles = _ensureBaseRoles(
    roles: updatedRoles,
    companyType:
        (await context.read<CompanyRepository>().findById(companyId))?.type ??
            'buyer',
  );
  final updated = UserRecord(
    id: existing.id,
    companyId: existing.companyId,
    email: isAdmin
        ? (jsonBody['email'] as String? ?? existing.email).toLowerCase()
        : existing.email,
    firstName: jsonBody['firstName'] as String? ?? existing.firstName,
    lastName: jsonBody['lastName'] as String? ?? existing.lastName,
    salutation: jsonBody['salutation'] as String? ?? existing.salutation,
    title: jsonBody['title'] as String? ?? existing.title,
    telephoneNr: jsonBody['telephoneNr'] as String? ?? existing.telephoneNr,
    roles: normalizedRoles,
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
  if (existing.roles.toSet().difference(updated.roles.toSet()).isNotEmpty ||
      updated.roles.toSet().difference(existing.roles.toSet()).isNotEmpty) {
    await context.read<AuditService>().log(
      action: 'user.roles.updated',
      entityType: 'user',
      entityId: updated.id,
      actorId: authResult.userId,
      metadata: {
        'before': existing.roles,
        'after': updated.roles,
      },
    );
  }
  return Response.json(body: updated.toDtoJson());
}

List<String> _ensureBaseRoles({
  required List<String> roles,
  required String companyType,
}) {
  final normalized = <String>{...roles};
  if (normalized.contains('admin')) {
    if (companyType == 'buyer' || companyType == 'buyer_provider') {
      normalized.add('buyer');
    }
    if (companyType == 'provider' || companyType == 'buyer_provider') {
      normalized.add('provider');
    }
  }
  final ordered = <String>[];
  if (normalized.contains('buyer')) {
    ordered.add('buyer');
  }
  if (normalized.contains('provider')) {
    ordered.add('provider');
  }
  if (normalized.contains('consultant')) {
    ordered.add('consultant');
  }
  if (normalized.contains('admin')) {
    ordered.add('admin');
  }
  for (final role in normalized) {
    if (!ordered.contains(role)) {
      ordered.add(role);
    }
  }
  return ordered;
}
