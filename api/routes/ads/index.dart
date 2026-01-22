import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final params = context.request.uri.queryParameters;
    final branchId = params['branchId'];
    final scope = params['scope'];
    final status = params['status'];
    final companyIdParam = params['companyId'];
    List<AdRecord> ads;
    if (scope == 'company' || scope == 'all') {
      final auth = await parseAuth(
        context,
        supabaseUrl: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'http://localhost:54321',
    ),
        users: context.read<UserRepository>(),
      );
      if (auth == null) {
        return Response(statusCode: 401);
      }
      if (scope == 'all' && !auth.roles.contains('consultant')) {
        return Response(statusCode: 403);
      }
      if (scope == 'company' &&
          auth.activeRole != 'provider' &&
          !auth.roles.contains('consultant')) {
        return Response(statusCode: 403);
      }
      final companyId = companyIdParam ?? auth.companyId;
      if (companyId != auth.companyId && !auth.roles.contains('consultant')) {
        return Response(statusCode: 403);
      }
      ads = await context
          .read<AdsRepository>()
          .listAll(companyId: companyId, status: status);
    } else {
      ads = await context.read<AdsRepository>().listActive(branchId: branchId);
    }
    return Response.json(
      body: ads
          .map((ad) => {
                'id': ad.id,
                'companyId': ad.companyId,
                'type': ad.type,
                'status': ad.status,
                'branchId': ad.branchId,
                'url': ad.url,
                'imagePath': ad.imagePath,
                'headline': ad.headline,
                'description': ad.description,
                'startDate': ad.startDate?.toIso8601String(),
                'endDate': ad.endDate?.toIso8601String(),
                'bannerDate': ad.bannerDate?.toIso8601String(),
              })
          .toList(),
    );
  }
  if (context.request.method == HttpMethod.post) {
    final auth = await parseAuth(
      context,
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
      users: context.read<UserRepository>(),
    );
    if (auth == null) {
      return Response(statusCode: 401);
    }
    if (auth.activeRole != 'provider') {
      return Response(statusCode: 403);
    }
    final providerRepo = context.read<ProviderRepository>();
    final subscriptionRepo = context.read<SubscriptionRepository>();
    final data =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final now = DateTime.now().toUtc();
    final type = data['type'] as String? ?? 'normal';
    final status = data['status'] as String? ?? 'draft';
    if (status != 'draft') {
      return Response.json(
          statusCode: 400,
          body:
              'Ads must be created as draft; activate via /ads/{id}/activate');
    }
    final bannerDate = data['bannerDate'] == null
        ? null
        : DateTime.parse(data['bannerDate'] as String);
    final startDate = data['startDate'] == null
        ? null
        : DateTime.parse(data['startDate'] as String);
    final endDate = data['endDate'] == null
        ? null
        : DateTime.parse(data['endDate'] as String);
    if (type == 'banner' && bannerDate == null) {
      return Response.json(statusCode: 400, body: 'Banner date is required');
    }
    if (type != 'banner') {
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
    }
    final profile = await providerRepo.findByCompany(auth.companyId);
    if (profile != null) {
      if (profile.status != 'active') {
        return Response.json(
            statusCode: 403,
            body: 'Provider profile is pending and cannot create ads');
      }
      final plan =
          await subscriptionRepo.findPlanById(profile.subscriptionPlanId);
      if (plan != null) {
        final maxNormalAds = _ruleUpperLimit(plan.rules, 1);
        final maxBannerAds = _ruleUpperLimit(plan.rules, 2);
        if (type == 'banner' && maxBannerAds <= 0) {
          return Response.json(
              statusCode: 403,
              body: 'Banner ads are not available for your plan');
        }
        if (type != 'banner' && status == 'active' && startDate != null) {
          final activeCount = await context
              .read<AdsRepository>()
              .countActiveByCompanyInMonth(auth.companyId, startDate);
          if (maxNormalAds > 0 && activeCount >= maxNormalAds) {
            return Response.json(
                statusCode: 400, body: 'Monthly ad limit reached');
          }
        }
      }
    }
    if (type == 'banner' && bannerDate != null) {
      const maxBannerSlots = 10;
      final bannerCount =
          await context.read<AdsRepository>().countBannerForDate(bannerDate);
      if (bannerCount >= maxBannerSlots) {
        return Response.json(
            statusCode: 400,
            body: 'No banner slots available for selected day');
      }
      if (!bannerDate.isAfter(now)) {
        return Response.json(
            statusCode: 400, body: 'Banner date must be in the future');
      }
    }
    final domain = context.read<SomDomainModel>();
    final ad = AdRecord(
      id: const Uuid().v4(),
      companyId: auth.companyId,
      type: type,
      status: status,
      branchId: data['branchId'] as String? ?? '',
      url: data['url'] as String? ?? '',
      imagePath: data['imagePath'] as String? ?? '',
      headline: data['headline'] as String?,
      description: data['description'] as String?,
      startDate: startDate,
      endDate: endDate,
      bannerDate: bannerDate,
      createdAt: now,
      updatedAt: now,
    );
    final adEntity = domain.newAd()
      ..setAttribute('branchId', ad.branchId)
      ..setAttribute('url', ad.url)
      ..setAttribute('type', ad.type);
    try {
      adEntity.validateRequired();
    } catch (error) {
      return Response.json(statusCode: 400, body: error.toString());
    }
    await context.read<AdsRepository>().create(ad);
    final notifications = context.read<NotificationService>();
    await notifications.notifyConsultantsOnAdCreated(ad);
    return Response.json(body: {'id': ad.id});
  }
  return Response(statusCode: 405);
}

int _ruleUpperLimit(List<Map<String, dynamic>> rules, int restriction) {
  for (final rule in rules) {
    if (rule['restriction'] == restriction) {
      return rule['upperLimit'] as int? ?? 0;
    }
  }
  return 0;
}
