import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String planId) async {
  final repository = context.read<SubscriptionRepository>();
  if (context.request.method == HttpMethod.get) {
    final plan = await repository.findPlanById(planId);
    if (plan == null) {
      return Response(statusCode: 404);
    }
    return Response.json(body: plan.toDtoJson());
  }

  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  if (!auth.roles.contains('admin')) {
    return Response(statusCode: 403);
  }

  if (context.request.method == HttpMethod.put) {
    final existing = await repository.findPlanById(planId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final activeCount = await repository.countActiveSubscriptionsByPlan(planId);
    final confirm = body['confirm'] == true;
    if (activeCount > 0 && !confirm) {
      return Response.json(
        statusCode: 400,
        body: 'Plan has active subscribers. Confirmation required.',
      );
    }
    final title = body['title'] as String? ?? existing.name;
    final sortPriority = body['sortPriority'] as int? ?? existing.sortPriority;
    final isActive = body['isActive'] as bool? ?? existing.isActive;
    final priceInSubunit =
        body['priceInSubunit'] as int? ?? existing.priceInSubunit;
    final maxUsers = body['maxUsers'] as int? ?? existing.maxUsers;
    final setupFeeInSubunit =
        body['setupFeeInSubunit'] as int? ?? existing.setupFeeInSubunit;
    final bannerAdsPerMonth =
        body['bannerAdsPerMonth'] as int? ?? existing.bannerAdsPerMonth;
    final normalAdsPerMonth =
        body['normalAdsPerMonth'] as int? ?? existing.normalAdsPerMonth;
    final freeMonths = body['freeMonths'] as int? ?? existing.freeMonths;
    final commitmentPeriodMonths = body['commitmentPeriodMonths'] as int? ??
        existing.commitmentPeriodMonths;
    final rules = body['rules'] == null
        ? existing.rules
        : (body['rules'] as List<dynamic>)
            .map((e) =>
                (e as Map).map((key, value) => MapEntry(key.toString(), value)))
            .toList();
    final updated = SubscriptionPlanRecord(
      id: existing.id,
      name: title,
      sortPriority: sortPriority,
      isActive: isActive,
      priceInSubunit: priceInSubunit,
      maxUsers: maxUsers,
      setupFeeInSubunit: setupFeeInSubunit,
      bannerAdsPerMonth: bannerAdsPerMonth,
      normalAdsPerMonth: normalAdsPerMonth,
      freeMonths: freeMonths,
      commitmentPeriodMonths: commitmentPeriodMonths,
      rules: rules,
      createdAt: existing.createdAt,
    );
    await repository.updatePlan(updated);
    await context.read<AuditService>().log(
      action: 'subscription.plan.updated',
      entityType: 'subscription_plan',
      entityId: updated.id,
      actorId: auth.userId,
      metadata: {
        'confirm': confirm,
        'activeSubscribers': activeCount,
      },
    );
    return Response(statusCode: 200);
  }

  if (context.request.method == HttpMethod.delete) {
    final existing = await repository.findPlanById(planId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    await repository.deletePlan(planId);
    await context.read<AuditService>().log(
          action: 'subscription.plan.deleted',
          entityType: 'subscription_plan',
          entityId: existing.id,
          actorId: auth.userId,
        );
    return Response(statusCode: 200);
  }

  return Response(statusCode: 405);
}
