import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/access_control.dart';
import 'package:som_api/services/file_validation.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method == HttpMethod.get) {
    final auth = await parseAuth(
      context,
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
      users: context.read<UserRepository>(),
    );
    if (auth == null) {
      return Response(statusCode: 401);
    }
    final repo = context.read<OfferRepository>();
    final inquiryRepo = context.read<InquiryRepository>();
    final inquiry = await inquiryRepo.findById(inquiryId);
    if (inquiry == null) {
      return Response(statusCode: 404);
    }
    if (!isConsultant(auth)) {
      if (auth.activeRole == 'buyer') {
        if (!canAccessInquiryAsBuyer(auth, inquiry)) {
          return Response(statusCode: 403);
        }
      } else if (auth.activeRole == 'provider') {
        final provider = await context
            .read<ProviderRepository>()
            .findByCompany(auth.companyId);
        final isActive = provider != null && provider.status == 'active';
        if (!isActive) {
          return Response.json(
            statusCode: 403,
            body: 'Provider registration is pending.',
          );
        }
        final assigned =
            await inquiryRepo.isAssignedToProvider(inquiryId, auth.companyId);
        if (!canAccessInquiryAsProvider(
          auth: auth,
          isAssignedProvider: assigned,
          isProviderActive: isActive,
        )) {
          return Response.json(
            statusCode: 403,
            body: 'Inquiry not assigned to provider.',
          );
        }
      } else {
        return Response(statusCode: 403);
      }
    }
    var offers = await repo.listByInquiry(inquiryId);
    if (auth.activeRole == 'provider') {
      offers = offers
          .where((offer) => offer.providerCompanyId == auth.companyId)
          .toList();
    }
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
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
      users: context.read<UserRepository>(),
    );
    if (auth == null || auth.activeRole != 'provider') {
      return Response(statusCode: 403);
    }
    final provider =
        await context.read<ProviderRepository>().findByCompany(auth.companyId);
    if (provider == null || provider.status != 'active') {
      return Response.json(
        statusCode: 403,
        body: 'Provider registration is pending.',
      );
    }
    final subscription = await context
        .read<SubscriptionRepository>()
        .findSubscriptionByCompany(auth.companyId);
    if (subscription == null ||
        subscription.status != 'active' ||
        subscription.endDate.isBefore(DateTime.now().toUtc())) {
      return Response.json(
        statusCode: 403,
        body: 'Provider subscription is inactive.',
      );
    }
    final inquiryRepo = context.read<InquiryRepository>();
    final inquiry = await inquiryRepo.findById(inquiryId);
    if (inquiry == null) {
      return Response(statusCode: 404);
    }
    final now = DateTime.now().toUtc();
    if (now.isAfter(inquiry.deadline)) {
      return Response.json(
        statusCode: 400,
        body: 'Offer deadline has passed.',
      );
    }
    final assigned = await inquiryRepo.isAssignedToProvider(
      inquiryId,
      auth.companyId,
    );
    if (!assigned) {
      return Response.json(
        statusCode: 403,
        body: 'Inquiry not assigned to provider.',
      );
    }
    if (!(context.request.headers['content-type']
            ?.contains('multipart/form-data') ??
        false)) {
      return Response.json(
          statusCode: 400, body: 'Multipart form-data is required');
    }
    final storage = context.read<FileStorage>();
    String? pdfPath;
    final form = await context.request.formData();
    final file = form.files['file'];
    if (file != null) {
      final bytes = await file.readAsBytes();
      final validationError =
          validatePdfUpload(fileName: file.name, bytes: bytes);
      if (validationError != null) {
        return Response.json(statusCode: 400, body: validationError);
      }
      pdfPath = await storage.saveFile(
        category: 'offers',
        fileName: file.name,
        bytes: bytes,
      );
    }
    final offer = OfferRecord(
      id: const Uuid().v4(),
      inquiryId: inquiryId,
      providerCompanyId: auth.companyId,
      providerUserId: auth.userId,
      status: 'offer_created',
      pdfPath: pdfPath,
      forwardedAt: DateTime.now().toUtc(),
      resolvedAt: null,
      buyerDecision: 'open',
      providerDecision: 'offer_created',
      createdAt: DateTime.now().toUtc(),
    );
    final domain = context.read<SomDomainModel>();
    final offerEntity = domain.newOffer()
      ..setAttribute('inquiryId', offer.inquiryId)
      ..setAttribute('providerCompanyId', offer.providerCompanyId);
    try {
      offerEntity.validateRequired();
    } catch (error) {
      return Response.json(statusCode: 400, body: error.toString());
    }
    await context.read<OfferRepository>().create(offer);
    await context
        .read<NotificationService>()
        .notifyBuyerIfOfferTargetReached(inquiry);
    return Response.json(body: {
      'id': offer.id,
      'status': offer.status,
    });
  }
  return Response(statusCode: 405);
}
