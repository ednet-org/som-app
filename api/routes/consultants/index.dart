import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final userRepo = context.read<UserRepository>();
  if (context.request.method == HttpMethod.get) {
    final consultants = userRepo.listByRole('consultant');
    return Response.json(
      body: consultants.map((user) => user.toDtoJson()).toList(),
    );
  }
  if (context.request.method == HttpMethod.post) {
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final email = (body['email'] as String? ?? '').toLowerCase();
    if (userRepo.findByEmail(email) != null) {
      return Response.json(statusCode: 400, body: 'E-mail already used.');
    }
    final companyRepo = context.read<CompanyRepository>();
    final systemCompany = companyRepo.findByRegistrationNr('SYSTEM');
    if (systemCompany == null) {
      return Response(statusCode: 500);
    }
    final now = DateTime.now().toUtc();
    final user = UserRecord(
      id: const Uuid().v4(),
      companyId: systemCompany.id,
      email: email,
      firstName: body['firstName'] as String? ?? '',
      lastName: body['lastName'] as String? ?? '',
      salutation: body['salutation'] as String? ?? '',
      title: body['title'] as String?,
      telephoneNr: body['telephoneNr'] as String?,
      roles: const ['consultant'],
      isActive: true,
      emailConfirmed: false,
      lastLoginRole: 'consultant',
      createdAt: now,
      updatedAt: now,
    );
    userRepo.create(user);
    await context.read<AuthService>().createRegistrationToken(user);
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
