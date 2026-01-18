import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String adId) async {
  final repo = context.read<AdsRepository>();
  if (context.request.method == HttpMethod.delete) {
    final auth = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (auth == null) {
      return Response(statusCode: 401);
    }
    final existing = await repo.findById(adId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final canManage = auth.roles.contains('consultant') ||
        (auth.activeRole == 'provider' && existing.companyId == auth.companyId);
    if (!canManage) {
      return Response(statusCode: 403);
    }
    await repo.delete(adId);
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.put) {
    final auth = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (auth == null) {
      return Response(statusCode: 401);
    }
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final existing = await repo.findById(adId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final canManage = auth.roles.contains('consultant') ||
        (auth.activeRole == 'provider' && existing.companyId == auth.companyId);
    if (!canManage) {
      return Response(statusCode: 403);
    }
    if (body.containsKey('status') &&
        (body['status'] as String? ?? existing.status) != existing.status) {
      return Response.json(
          statusCode: 400,
          body: 'Use activate/deactivate endpoints to change ad status');
    }
    final startDate = body['startDate'] == null
        ? existing.startDate
        : DateTime.parse(body['startDate'] as String);
    final endDate = body['endDate'] == null
        ? existing.endDate
        : DateTime.parse(body['endDate'] as String);
    final bannerDate = body['bannerDate'] == null
        ? existing.bannerDate
        : DateTime.parse(body['bannerDate'] as String);
    if (existing.type != 'banner') {
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
    if (existing.type == 'banner') {
      if (bannerDate == null) {
        return Response.json(statusCode: 400, body: 'Banner date is required');
      }
      if (!bannerDate.isAfter(DateTime.now().toUtc())) {
        return Response.json(
            statusCode: 400, body: 'Banner date must be in the future');
      }
    }
    final updated = AdRecord(
      id: existing.id,
      companyId: existing.companyId,
      type: existing.type,
      status: existing.status,
      branchId: body['branchId'] as String? ?? existing.branchId,
      url: body['url'] as String? ?? existing.url,
      imagePath: body['imagePath'] as String? ?? existing.imagePath,
      headline: body['headline'] as String? ?? existing.headline,
      description: body['description'] as String? ?? existing.description,
      startDate: startDate,
      endDate: endDate,
      bannerDate: bannerDate,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await repo.update(updated);
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.get) {
    final ad = await repo.findById(adId);
    if (ad == null) {
      return Response(statusCode: 404);
    }
    if (ad.status != 'active') {
      final auth = await parseAuth(
        context,
        secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
            defaultValue: 'som_dev_secret'),
        users: context.read<UserRepository>(),
      );
      final canView = auth != null &&
          (auth.roles.contains('consultant') ||
              (auth.activeRole == 'provider' &&
                  ad.companyId == auth.companyId));
      if (!canView) {
        return Response(statusCode: 403);
      }
    }
    return Response.json(
      body: {
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
      },
    );
  }
  return Response(statusCode: 405);
}
