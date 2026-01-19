import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/access_control.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  final repo = context.read<CompanyRepository>();
  if (context.request.method == HttpMethod.get) {
    final authResult = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (authResult == null) {
      return Response(statusCode: 401);
    }
    if (!canAccessCompany(authResult, companyId)) {
      return Response(statusCode: 403);
    }
    final company = await repo.findById(companyId);
    if (company == null) {
      return Response(statusCode: 404);
    }
    return Response.json(
      body: {
        'id': company.id,
        'name': company.name,
        'address': company.address.toJson(),
        'uidNr': company.uidNr,
        'registrationNr': company.registrationNr,
        'companySize': companySizeToWire(company.companySize),
        'type': companyTypeToWire(company.type),
        'websiteUrl': company.websiteUrl,
        'status': company.status,
      },
    );
  }
  if (context.request.method == HttpMethod.put) {
    final authResult = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (authResult == null) {
      return Response(statusCode: 401);
    }
    final allowed = authResult.roles.contains('consultant') ||
        (authResult.roles.contains('admin') &&
            authResult.companyId == companyId);
    if (!allowed) {
      return Response(statusCode: 403);
    }
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final existing = await repo.findById(companyId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    String updatedType = existing.type;
    if (body.containsKey('type')) {
      final rawType = body['type'];
      final parsed =
          rawType is int ? rawType : int.tryParse(rawType?.toString() ?? '');
      if (parsed == null || parsed < 0 || parsed > 2) {
        return Response.json(
          statusCode: 400,
          body: 'Company type is required.',
        );
      }
      updatedType = companyTypeFromWire(parsed);
    }
    final updated = CompanyRecord(
      id: existing.id,
      name: body['name'] as String? ?? existing.name,
      type: updatedType,
      address: body['address'] == null
          ? existing.address
          : Address.fromJson(body['address'] as Map<String, dynamic>),
      uidNr: body['uidNr'] as String? ?? existing.uidNr,
      registrationNr:
          body['registrationNr'] as String? ?? existing.registrationNr,
      companySize: body['companySize'] == null
          ? existing.companySize
          : companySizeFromWire(body['companySize'] as int),
      websiteUrl: body['websiteUrl'] as String? ?? existing.websiteUrl,
      termsAcceptedAt: existing.termsAcceptedAt,
      privacyAcceptedAt: existing.privacyAcceptedAt,
      status: existing.status,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await repo.update(updated);
    await context.read<DomainEventService>().emit(
          type: 'company.updated',
          entityType: 'company',
          entityId: updated.id,
          actorId: authResult.userId,
        );
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.delete) {
    final authResult = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (authResult == null) {
      return Response(statusCode: 401);
    }
    final allowed = authResult.roles.contains('consultant') ||
        (authResult.roles.contains('admin') &&
            authResult.companyId == companyId);
    if (!allowed) {
      return Response(statusCode: 403);
    }
    final existing = await repo.findById(companyId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final updated = CompanyRecord(
      id: existing.id,
      name: existing.name,
      type: existing.type,
      address: existing.address,
      uidNr: existing.uidNr,
      registrationNr: existing.registrationNr,
      companySize: existing.companySize,
      websiteUrl: existing.websiteUrl,
      termsAcceptedAt: existing.termsAcceptedAt,
      privacyAcceptedAt: existing.privacyAcceptedAt,
      status: 'inactive',
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await repo.update(updated);
    final usersRepo = context.read<UserRepository>();
    final users = await usersRepo.listByCompany(companyId);
    for (final user in users) {
      await usersRepo.deactivate(user.id);
    }
    await context.read<DomainEventService>().emit(
          type: 'company.deactivated',
          entityType: 'company',
          entityId: updated.id,
          actorId: authResult.userId,
        );
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
