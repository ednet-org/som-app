import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String adId) async {
  final repo = context.read<AdsRepository>();
  if (context.request.method == HttpMethod.delete) {
    final auth = parseAuth(
      context,
      secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
    );
    if (auth == null) {
      return Response(statusCode: 401);
    }
    repo.delete(adId);
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.put) {
    final auth = parseAuth(
      context,
      secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
    );
    if (auth == null) {
      return Response(statusCode: 401);
    }
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final existing = repo.findById(adId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final updated = AdRecord(
      id: existing.id,
      companyId: existing.companyId,
      type: existing.type,
      status: body['status'] as String? ?? existing.status,
      branchId: body['branchId'] as String? ?? existing.branchId,
      url: body['url'] as String? ?? existing.url,
      imagePath: body['imagePath'] as String? ?? existing.imagePath,
      headline: body['headline'] as String? ?? existing.headline,
      description: body['description'] as String? ?? existing.description,
      startDate: body['startDate'] == null
          ? existing.startDate
          : DateTime.parse(body['startDate'] as String),
      endDate: body['endDate'] == null
          ? existing.endDate
          : DateTime.parse(body['endDate'] as String),
      bannerDate: body['bannerDate'] == null
          ? existing.bannerDate
          : DateTime.parse(body['bannerDate'] as String),
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    repo.update(updated);
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.get) {
    final ad = repo.findById(adId);
    if (ad == null) {
      return Response(statusCode: 404);
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
