import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/company_taxonomy_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/email_templates.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final repo = context.read<ProviderRepository>();
  final profile = await repo.findByCompany(companyId);
  if (profile == null) {
    return Response(statusCode: 404);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final approved =
      (body['approvedBranchIds'] as List<dynamic>? ?? profile.pendingBranchIds)
          .map((e) => e.toString())
          .toList();
  final updated = ProviderProfileRecord(
    companyId: profile.companyId,
    bankDetails: profile.bankDetails,
    branchIds: [...profile.branchIds, ...approved],
    pendingBranchIds: const [],
    subscriptionPlanId: profile.subscriptionPlanId,
    paymentInterval: profile.paymentInterval,
    providerType: profile.providerType,
    status: 'active',
    rejectionReason: null,
    rejectedAt: null,
    createdAt: profile.createdAt,
    updatedAt: DateTime.now().toUtc(),
  );
  await repo.update(updated);
  await context.read<CompanyTaxonomyRepository>().replaceCompanyBranches(
        companyId: companyId,
        branchIds: updated.branchIds,
        source: 'approval',
      );
  final admins =
      await context.read<UserRepository>().listAdminsByCompany(companyId);
  final email = context.read<EmailService>();
  for (final admin in admins) {
    await email.sendTemplate(
      to: admin.email,
      templateId: EmailTemplateId.providerApproved,
    );
  }
  return Response(statusCode: 200);
}
