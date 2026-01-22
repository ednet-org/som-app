import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
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
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
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
  final body = context.request.body();
  String? reason;
  try {
    final payload = jsonDecode(await body) as Map<String, dynamic>;
    reason = payload['reason'] as String?;
  } catch (_) {
    reason = null;
  }
  await repo.update(
    ProviderProfileRecord(
      companyId: profile.companyId,
      bankDetails: profile.bankDetails,
      branchIds: profile.branchIds,
      pendingBranchIds: profile.pendingBranchIds,
      subscriptionPlanId: profile.subscriptionPlanId,
      paymentInterval: profile.paymentInterval,
      providerType: profile.providerType,
      status: 'declined',
      rejectionReason: reason?.trim().isEmpty == true ? null : reason?.trim(),
      rejectedAt: DateTime.now().toUtc(),
      createdAt: profile.createdAt,
      updatedAt: DateTime.now().toUtc(),
    ),
  );
  final admins =
      await context.read<UserRepository>().listAdminsByCompany(companyId);
  final email = context.read<EmailService>();
  for (final admin in admins) {
    final trimmed = reason?.trim() ?? '';
    await email.sendTemplate(
      to: admin.email,
      templateId: EmailTemplateId.providerDeclined,
      variables: {
        'reason': trimmed.isEmpty ? '' : 'Reason: $trimmed',
      },
    );
  }
  return Response(statusCode: 200);
}
