import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(
  RequestContext context,
  String companyId,
  String userId,
) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final users = context.read<UserRepository>();
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: users,
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  final isAdmin =
      authResult.roles.contains('admin') && authResult.companyId == companyId;
  if (!isAdmin) {
    return Response(statusCode: 403);
  }
  final user = await users.findById(userId);
  if (user == null || user.companyId != companyId) {
    return Response(statusCode: 404);
  }
  if (user.roles.contains('admin')) {
    final admins = await users.listAdminsByCompany(companyId);
    if (admins.length <= 1) {
      return Response.json(
        statusCode: 400,
        body: 'At least one admin user is required.',
      );
    }
  }
  await users.markRemoved(userId: userId, removedByUserId: authResult.userId);
  await context.read<AuditService>().log(
        action: 'user.removed',
        entityType: 'user',
        entityId: userId,
        actorId: authResult.userId,
        metadata: {
          'companyId': companyId,
          'email': user.email,
        },
      );
  final company = await context.read<CompanyRepository>().findById(companyId);
  if (company != null) {
    final removedBy = await users.findById(authResult.userId);
    await context.read<DomainEventService>().emit(
      type: 'user.removed',
      entityType: 'company',
      entityId: company.id,
      actorId: authResult.userId,
      payload: {
        'userEmail': user.email,
        'removedByEmail': removedBy?.email,
      },
    );
  }
  return Response(statusCode: 200);
}
