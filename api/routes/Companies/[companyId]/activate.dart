import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.post) {
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
  final allowed = authResult.roles.contains('consultant') ||
      (authResult.roles.contains('admin') && authResult.companyId == companyId);
  if (!allowed) {
    return Response(statusCode: 403);
  }
  final repo = context.read<CompanyRepository>();
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
    status: 'active',
    createdAt: existing.createdAt,
    updatedAt: DateTime.now().toUtc(),
  );
  await repo.update(updated);
  final usersRepo = context.read<UserRepository>();
  final users = await usersRepo.listByCompany(companyId);
  for (final user in users) {
    if (!user.isActive) {
      await usersRepo.update(
        user.copyWith(isActive: true, updatedAt: DateTime.now().toUtc()),
      );
    }
  }
  return Response.json(body: {'status': 'active'});
}
