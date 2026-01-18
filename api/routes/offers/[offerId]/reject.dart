import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String offerId) async {
  if (context.request.method != HttpMethod.post) {
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
  if (auth.activeRole != 'buyer') {
    return Response(statusCode: 403);
  }
  final repo = context.read<OfferRepository>();
  final offer = await repo.findById(offerId);
  if (offer == null) {
    return Response(statusCode: 404);
  }
  final inquiry =
      await context.read<InquiryRepository>().findById(offer.inquiryId);
  if (inquiry == null || inquiry.buyerCompanyId != auth.companyId) {
    return Response(statusCode: 403);
  }
  await repo.updateStatus(
    id: offerId,
    status: 'lost',
    buyerDecision: 'rejected',
    providerDecision: 'lost',
    resolvedAt: DateTime.now().toUtc(),
  );
  final email = context.read<EmailService>();
  final userRepo = context.read<UserRepository>();
  final admins = await userRepo.listAdminsByCompany(offer.providerCompanyId);
  for (final admin in admins) {
    await email.send(
      to: admin.email,
      subject: 'Offer rejected',
      text: 'Offer $offerId has been rejected.',
    );
  }
  await context.read<DomainEventService>().emit(
    type: 'offer.rejected',
    entityType: 'offer',
    entityId: offerId,
    actorId: auth.userId,
    payload: {
      'inquiryId': offer.inquiryId,
      'providerCompanyId': offer.providerCompanyId,
    },
  );
  return Response(statusCode: 200);
}
