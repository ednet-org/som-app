// ignore_for_file: file_names

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  final params = context.request.uri.queryParameters;
  final userId = params['userId'];
  final companyId = params['companyId'];
  if (userId == null) {
    return Response(statusCode: 400);
  }
  final userRepo = context.read<UserRepository>();
  final companyRepo = context.read<CompanyRepository>();
  final user = await userRepo.findById(userId);
  if (user == null) {
    return Response(statusCode: 404);
  }
  final isAdmin = authResult.roles.contains('admin') &&
      authResult.companyId == user.companyId;
  final isSelf = authResult.userId == userId;
  if (!isAdmin && !isSelf && !authResult.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final resolvedCompanyId = companyId ?? user.companyId;
  final company = await companyRepo.findById(resolvedCompanyId);
  if (company == null) {
    return Response(statusCode: 404);
  }
  return Response.json(
    body: {
      'userId': user.id,
      'salutation': user.salutation,
      'title': user.title,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'telephoneNr': user.telephoneNr,
      'emailAddress': user.email,
      'roles': user.roles,
      'activeRole':
          user.lastLoginRole ?? (user.roles.isNotEmpty ? user.roles.first : ''),
      'companyId': company.id,
      'companyName': company.name,
      'companyAddress': company.address.toJson(),
      'companyType': companyTypeToWire(company.type),
    },
  );
}
