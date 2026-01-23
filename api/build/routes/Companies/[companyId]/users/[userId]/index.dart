import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(
    RequestContext context, String companyId, String userId) async {
  final repo = context.read<UserRepository>();
  final authResult = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
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
  if (context.request.method == HttpMethod.get) {
    final user = await repo.findById(userId);
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
    if (!isAdmin) {
      return Response(statusCode: 403);
    }
    final user = await repo.findById(userId);
    if (user == null || user.companyId != companyId) {
      return Response(statusCode: 404);
    }
    if (user.roles.contains('admin')) {
      final admins = await repo.listAdminsByCompany(companyId);
      if (admins.length <= 1) {
        return Response.json(
          statusCode: 400,
          body: 'At least one admin user is required.',
        );
      }
    }
    await repo.deactivate(userId);
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
