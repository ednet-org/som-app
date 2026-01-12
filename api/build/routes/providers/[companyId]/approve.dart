import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final repo = context.read<ProviderRepository>();
  final profile = repo.findByCompany(companyId);
  if (profile == null) {
    return Response(statusCode: 404);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final approved = (body['approvedBranchIds'] as List<dynamic>? ?? profile.pendingBranchIds)
      .map((e) => e.toString())
      .toList();
  final updated = ProviderProfileRecord(
    companyId: profile.companyId,
    bankDetails: profile.bankDetails,
    branchIds: [...profile.branchIds, ...approved],
    pendingBranchIds: const [],
    subscriptionPlanId: profile.subscriptionPlanId,
    paymentInterval: profile.paymentInterval,
    status: 'active',
    createdAt: profile.createdAt,
    updatedAt: DateTime.now().toUtc(),
  );
  repo.update(updated);
  final admins = context.read<UserRepository>().listAdminsByCompany(companyId);
  final email = context.read<EmailService>();
  for (final admin in admins) {
    await email.send(
      to: admin.email,
      subject: 'Registration completed',
      text: 'Your provider registration is now active.',
    );
  }
  return Response(statusCode: 200);
}
