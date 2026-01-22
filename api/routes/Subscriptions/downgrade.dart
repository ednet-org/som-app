import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
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
  final userRepo = context.read<UserRepository>();
  final profile = await providerRepo.findByCompany(auth.companyId);
  if (profile == null) {
    return Response(statusCode: 400);
  }
  final current =
      await subscriptionRepo.findSubscriptionByCompany(auth.companyId);
  if (current == null) {
    return Response(statusCode: 400);
  }
  final plan = await subscriptionRepo.findPlanById(planId);
  if (plan == null) {
    return Response.json(statusCode: 400, body: 'Subscription plan not found.');
  }
  final maxUsers = _maxUsersForPlan(plan);
  if (maxUsers != null && maxUsers > 0) {
    final activeUsers = (await userRepo.listByCompany(auth.companyId))
        .where((user) => user.isActive)
        .length;
    if (activeUsers > maxUsers) {
      return Response.json(
        statusCode: 400,
        body: 'User limit exceeded for subscription plan.',
      );
    }
  }
  if (current.planId == planId) {
    return Response(statusCode: 200);
  }
  final now = DateTime.now().toUtc();
  final eligibleAt = current.endDate.subtract(const Duration(days: 90));
  if (now.isBefore(eligibleAt)) {
    return Response.json(
      statusCode: 400,
      body: 'Downgrade allowed only within 3 months of renewal.',
    );
  }
  final startDate = current.endDate.add(const Duration(days: 1));
  final endDate =
      DateTime.utc(startDate.year + 1, startDate.month, startDate.day)
          .subtract(const Duration(days: 1));
  await subscriptionRepo.createSubscription(
    SubscriptionRecord(
      id: const Uuid().v4(),
      companyId: auth.companyId,
      planId: planId,
      status: 'active',
      paymentInterval: current.paymentInterval,
      startDate: startDate,
      endDate: endDate,
      createdAt: now,
    ),
  );
  await providerRepo.update(
    ProviderProfileRecord(
      companyId: profile.companyId,
      bankDetails: profile.bankDetails,
      branchIds: profile.branchIds,
      pendingBranchIds: profile.pendingBranchIds,
      subscriptionPlanId: planId,
      paymentInterval: profile.paymentInterval,
      providerType: profile.providerType,
      status: profile.status,
      createdAt: profile.createdAt,
      updatedAt: now,
      rejectionReason: profile.rejectionReason,
      rejectedAt: profile.rejectedAt,
    ),
  );
  await context.read<AuditService>().log(
    action: 'subscription.downgraded',
    entityType: 'subscription',
    entityId: auth.companyId,
    actorId: auth.userId,
    metadata: {'planId': planId},
  );
  return Response(statusCode: 200);
}

int? _maxUsersForPlan(SubscriptionPlanRecord plan) {
  if (plan.maxUsers != null && plan.maxUsers! > 0) {
    return plan.maxUsers;
  }
  for (final rule in plan.rules) {
    if ((rule['restriction'] as int? ?? -1) == 0) {
      final limit = rule['upperLimit'] as int? ?? 0;
      return limit > 0 ? limit : null;
    }
  }
  return null;
}
