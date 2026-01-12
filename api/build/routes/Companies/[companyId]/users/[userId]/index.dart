import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';

Future<Response> onRequest(RequestContext context, String companyId, String userId) async {
  final repo = context.read<UserRepository>();
  if (context.request.method == HttpMethod.get) {
    final user = repo.findById(userId);
    if (user == null || user.companyId != companyId) {
      return Response(statusCode: 404);
    }
    return Response.json(
      body: {
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'salutation': user.salutation,
        'roles': user.roles.map(roleToWire).toList(),
        'telephoneNr': user.telephoneNr,
        'title': user.title,
        'companyId': user.companyId,
        'id': user.id,
      },
    );
  }
  if (context.request.method == HttpMethod.delete) {
    final user = repo.findById(userId);
    if (user == null || user.companyId != companyId) {
      return Response(statusCode: 404);
    }
    if (user.roles.contains('admin')) {
      final admins = repo.listAdminsByCompany(companyId);
      if (admins.length <= 1) {
        return Response.json(
          statusCode: 400,
          body: 'At least one admin user is required.',
        );
      }
    }
    repo.deactivate(userId);
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
