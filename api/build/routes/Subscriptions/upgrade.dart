import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('admin')) {
    return Response(statusCode: 403);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final planId = body['planId'] as String? ?? '';
  if (planId.isEmpty) {
    return Response(statusCode: 400);
  }
  final subscriptionRepo = context.read<SubscriptionRepository>();
  final providerRepo = context.read<ProviderRepository>();
  final current =
      await subscriptionRepo.findSubscriptionByCompany(auth.companyId);
  if (current != null && current.planId == planId) {
    return Response(statusCode: 200);
  }
  final now = DateTime.now().toUtc();
  final startDate = DateTime.utc(now.year, now.month + 1, 1);
  final endDate = DateTime.utc(startDate.year + 1, startDate.month, 1)
      .subtract(const Duration(days: 1));
  await subscriptionRepo.createSubscription(
    SubscriptionRecord(
      id: const Uuid().v4(),
      companyId: auth.companyId,
      planId: planId,
      status: 'active',
      paymentInterval: 'yearly',
      startDate: startDate,
      endDate: endDate,
      createdAt: now,
    ),
  );
  final profile = await providerRepo.findByCompany(auth.companyId);
  if (profile != null) {
    await providerRepo.update(
      ProviderProfileRecord(
        companyId: profile.companyId,
        bankDetails: profile.bankDetails,
        branchIds: profile.branchIds,
        pendingBranchIds: profile.pendingBranchIds,
        subscriptionPlanId: planId,
        paymentInterval: profile.paymentInterval,
        status: profile.status,
        createdAt: profile.createdAt,
        updatedAt: now,
      ),
    );
  }
  return Response(statusCode: 200);
}
