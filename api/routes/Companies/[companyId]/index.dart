import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/mappings.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  final repo = context.read<CompanyRepository>();
  if (context.request.method == HttpMethod.get) {
    final company = repo.findById(companyId);
    if (company == null) {
      return Response(statusCode: 404);
    }
    return Response.json(
      body: {
        'name': company.name,
        'address': company.address.toJson(),
        'uidNr': company.uidNr,
        'registrationNr': company.registrationNr,
        'companySize': companySizeToWire(company.companySize),
        'type': company.type == 'provider' ? 1 : 0,
        'websiteUrl': company.websiteUrl,
      },
    );
  }
  if (context.request.method == HttpMethod.put) {
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final existing = repo.findById(companyId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final updated = CompanyRecord(
      id: existing.id,
      name: body['name'] as String? ?? existing.name,
      type: existing.type,
      address: body['address'] == null
          ? existing.address
          : Address.fromJson(body['address'] as Map<String, dynamic>),
      uidNr: body['uidNr'] as String? ?? existing.uidNr,
      registrationNr: body['registrationNr'] as String? ?? existing.registrationNr,
      companySize: body['companySize'] == null
          ? existing.companySize
          : companySizeFromWire(body['companySize'] as int),
      websiteUrl: body['websiteUrl'] as String? ?? existing.websiteUrl,
      status: existing.status,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    repo.update(updated);
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.delete) {
    final existing = repo.findById(companyId);
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
      status: 'inactive',
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    repo.update(updated);
    final usersRepo = context.read<UserRepository>();
    final users = usersRepo.listByCompany(companyId);
    for (final user in users) {
      usersRepo.deactivate(user.id);
    }
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
