// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.put) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final isAdmin = auth.roles.contains('admin') && auth.companyId == companyId;
  if (!isAdmin) {
    return Response(statusCode: 403);
  }

  final repo = context.read<ProviderRepository>();
  final profile = await repo.findByCompany(companyId);
  if (profile == null) {
    return Response(statusCode: 404);
  }

  final payload =
      jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final iban = (payload['iban'] as String? ?? '').trim();
  final bic = (payload['bic'] as String? ?? '').trim();
  final owner = (payload['accountOwner'] as String? ?? '').trim();
  if (iban.isEmpty || bic.isEmpty || owner.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: 'IBAN, BIC, and account owner are required.',
    );
  }

  final updated = ProviderProfileRecord(
    companyId: profile.companyId,
    bankDetails: BankDetails(iban: iban, bic: bic, accountOwner: owner),
    branchIds: profile.branchIds,
    pendingBranchIds: profile.pendingBranchIds,
    subscriptionPlanId: profile.subscriptionPlanId,
    paymentInterval: profile.paymentInterval,
    providerType: profile.providerType,
    status: profile.status,
    rejectionReason: profile.rejectionReason,
    rejectedAt: profile.rejectedAt,
    createdAt: profile.createdAt,
    updatedAt: DateTime.now().toUtc(),
  );
  await repo.update(updated);
  return Response.json(
    body: {
      'companyId': updated.companyId,
      'bankDetails': updated.bankDetails.toJson(),
    },
  );
}
