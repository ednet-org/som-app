import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/registration_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _listCompanies(context),
    HttpMethod.post => _registerCompany(context),
    _ => Future.value(Response(statusCode: 405)),
  };
}

Future<Response> _listCompanies(RequestContext context) async {
  final companies = await context.read<CompanyRepository>().listAll();
  final filterType = context.request.uri.queryParameters['type'];
  String? normalizedType = filterType;
  if (filterType != null) {
    final parsed = int.tryParse(filterType);
    if (parsed != null) {
      normalizedType = companyTypeFromWire(parsed);
    }
  }
  final body = companies
      .where((company) =>
          normalizedType == null || company.type == normalizedType)
      .map((company) => {
            'id': company.id,
            'name': company.name,
            'address': company.address.toJson(),
            'uidNr': company.uidNr,
            'registrationNr': company.registrationNr,
            'companySize': companySizeToWire(company.companySize),
            'type': companyTypeToWire(company.type),
            'websiteUrl': company.websiteUrl,
            'status': company.status,
          })
      .toList();
  return Response.json(body: body);
}

Future<Response> _registerCompany(RequestContext context) async {
  final registration = context.read<RegistrationService>();
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final companyJson = jsonBody['company'] as Map<String, dynamic>? ?? {};
  final usersJson = jsonBody['users'] as List<dynamic>? ?? [];
  try {
    final company = await registration.registerCompany(
      companyJson: companyJson,
      usersJson: usersJson,
    );
      await context.read<DomainEventService>().emit(
            type: 'company.registered',
            entityType: 'company',
            entityId: company.id,
          );
    return Response(statusCode: 200);
  } on RegistrationException catch (error) {
    return Response.json(statusCode: 400, body: error.message);
  }
}
