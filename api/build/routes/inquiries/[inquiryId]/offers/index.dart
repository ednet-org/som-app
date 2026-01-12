import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method == HttpMethod.get) {
    final offers =
        await context.read<OfferRepository>().listByInquiry(inquiryId);
    final body = offers
        .map((offer) => {
              'id': offer.id,
              'inquiryId': offer.inquiryId,
              'providerCompanyId': offer.providerCompanyId,
              'status': offer.status,
              'pdfPath': offer.pdfPath,
              'forwardedAt': offer.forwardedAt?.toIso8601String(),
              'resolvedAt': offer.resolvedAt?.toIso8601String(),
              'buyerDecision': offer.buyerDecision,
              'providerDecision': offer.providerDecision,
            })
        .toList();
    return Response.json(body: body);
  }
  if (context.request.method == HttpMethod.post) {
    final auth = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (auth == null || !auth.roles.contains('provider')) {
      return Response(statusCode: 403);
    }
    final storage = context.read<FileStorage>();
    String? pdfPath;
    if (context.request.headers['content-type']
            ?.contains('multipart/form-data') ??
        false) {
      final form = await context.request.formData();
      final file = form.files['file'];
      if (file != null) {
        final bytes = await file.readAsBytes();
        pdfPath = await storage.saveFile(
          category: 'offers',
          fileName: file.name,
          bytes: bytes,
        );
      }
    } else {
      final body =
          jsonDecode(await context.request.body()) as Map<String, dynamic>;
      if (body['pdfBase64'] != null) {
        final bytes = base64Decode(body['pdfBase64'] as String);
        pdfPath = await storage.saveFile(
          category: 'offers',
          fileName: 'offer_${DateTime.now().millisecondsSinceEpoch}.pdf',
          bytes: bytes,
        );
      }
    }
    final offer = OfferRecord(
      id: const Uuid().v4(),
      inquiryId: inquiryId,
      providerCompanyId: auth.companyId,
      providerUserId: auth.userId,
      status: 'offer_uploaded',
      pdfPath: pdfPath,
      forwardedAt: DateTime.now().toUtc(),
      resolvedAt: null,
      buyerDecision: 'open',
      providerDecision: 'offer_created',
      createdAt: DateTime.now().toUtc(),
    );
    await context.read<OfferRepository>().create(offer);
    return Response.json(body: {
      'id': offer.id,
      'status': offer.status,
    });
  }
  return Response(statusCode: 405);
}
