// ignore_for_file: file_names

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final params = context.request.uri.queryParameters;
  final userId = params['userId'];
  final companyId = params['companyId'];
  if (userId == null) {
    return Response(statusCode: 400);
  }
  final userRepo = context.read<UserRepository>();
  final companyRepo = context.read<CompanyRepository>();
  final user = userRepo.findById(userId);
  if (user == null) {
    return Response(statusCode: 404);
  }
  final resolvedCompanyId = companyId ?? user.companyId;
  final company = companyRepo.findById(resolvedCompanyId);
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
      'companyId': company.id,
      'companyName': company.name,
      'companyAddress': company.address.toJson(),
    },
  );
}
