import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String adId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment(
      'SUPABASE_JWT_SECRET',
      defaultValue: 'som_dev_secret',
    ),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<AdsRepository>();
  final existing = await repo.findById(adId);
  if (existing == null) {
    return Response(statusCode: 404);
  }
  final canManage = auth.roles.contains('consultant') ||
      (auth.activeRole == 'provider' && existing.companyId == auth.companyId);
  if (!canManage) {
    return Response(statusCode: 403);
  }

  Map<String, dynamic> payload = {};
  final body = await context.request.body();
  if (body.trim().isNotEmpty) {
    try {
      payload = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return Response.json(statusCode: 400, body: 'Invalid JSON payload');
    }
  }

  final now = DateTime.now().toUtc();
  final startDate = payload['startDate'] == null
      ? existing.startDate
      : DateTime.parse(payload['startDate'] as String);
  final endDate = payload['endDate'] == null
      ? existing.endDate
      : DateTime.parse(payload['endDate'] as String);
  final bannerDate = payload['bannerDate'] == null
      ? existing.bannerDate
      : DateTime.parse(payload['bannerDate'] as String);

  if (existing.type == 'banner') {
    if (bannerDate == null) {
      return Response.json(statusCode: 400, body: 'Banner date is required');
    }
    if (!bannerDate.isAfter(now)) {
      return Response.json(
          statusCode: 400, body: 'Banner date must be in the future');
    }
  } else {
    if (startDate == null || endDate == null) {
      return Response.json(
          statusCode: 400,
          body: 'Start date and end date are required for ads');
    }
    if (!endDate.isAfter(startDate)) {
      return Response.json(
          statusCode: 400, body: 'End date must be after start date');
    }
    if (endDate.difference(startDate).inDays > 14) {
      return Response.json(
          statusCode: 400, body: 'Ad period cannot exceed 14 days');
    }
    if (!startDate.isAfter(now)) {
      return Response.json(
          statusCode: 400, body: 'Start date must be in the future');
    }
  }

  final providerRepo = context.read<ProviderRepository>();
  final subscriptionRepo = context.read<SubscriptionRepository>();
  final profile = await providerRepo.findByCompany(existing.companyId);
  if (profile != null) {
    if (profile.status != 'active') {
      return Response.json(
          statusCode: 403,
          body: 'Provider profile is pending and cannot activate ads');
    }
    final plan = await subscriptionRepo.findPlanById(profile.subscriptionPlanId);
    if (plan != null) {
      final maxNormalAds = _ruleUpperLimit(plan.rules, 1);
      final maxBannerAds = _ruleUpperLimit(plan.rules, 2);
      if (existing.type == 'banner' && maxBannerAds <= 0) {
        return Response.json(
            statusCode: 403,
            body: 'Banner ads are not available for your plan');
      }
      if (existing.type != 'banner' && startDate != null) {
        final activeCount = await repo.countActiveByCompanyInMonth(
          existing.companyId,
          startDate,
        );
        if (maxNormalAds > 0 &&
            activeCount >= maxNormalAds &&
            existing.status != 'active') {
          return Response.json(
              statusCode: 400, body: 'Monthly ad limit reached');
        }
      }
    }
  }

  if (existing.type == 'banner' && bannerDate != null) {
    const maxBannerSlots = 10;
    final bannerCount = await repo.countBannerForDate(bannerDate);
    if (bannerCount >= maxBannerSlots && existing.status != 'active') {
      return Response.json(
          statusCode: 400, body: 'No banner slots available for selected day');
    }
  }

  final updated = AdRecord(
    id: existing.id,
    companyId: existing.companyId,
    type: existing.type,
    status: 'active',
    branchId: existing.branchId,
    url: existing.url,
    imagePath: existing.imagePath,
    headline: existing.headline,
    description: existing.description,
    startDate: startDate,
    endDate: endDate,
    bannerDate: bannerDate,
    createdAt: existing.createdAt,
    updatedAt: now,
  );
  await repo.update(updated);
  final notifications = context.read<NotificationService>();
  await notifications.notifyConsultantsOnAdActivated(updated);
  return Response(statusCode: 200);
}

int _ruleUpperLimit(List<Map<String, dynamic>> rules, int restriction) {
  for (final rule in rules) {
    if (rule['restriction'] == restriction) {
      return rule['upperLimit'] as int? ?? 0;
    }
  }
  return 0;
}
