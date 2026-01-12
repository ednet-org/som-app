import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
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
  if (!auth.roles.contains('buyer')) {
    return Response(statusCode: 403);
  }
  final repo = context.read<OfferRepository>();
  final offer = await repo.findById(offerId);
  if (offer == null) {
    return Response(statusCode: 404);
  }
  await repo.updateStatus(
    id: offerId,
    status: 'accepted',
    buyerDecision: 'accepted',
    resolvedAt: DateTime.now().toUtc(),
  );
  final inquiry =
      await context.read<InquiryRepository>().findById(offer.inquiryId);
  if (inquiry != null) {
    await context.read<InquiryRepository>().updateStatus(inquiry.id, 'closed');
  }
  final email = context.read<EmailService>();
  final userRepo = context.read<UserRepository>();
  final admins = await userRepo.listAdminsByCompany(offer.providerCompanyId);
  for (final admin in admins) {
    await email.send(
      to: admin.email,
      subject: 'Offer accepted',
      text:
          'Offer $offerId has been accepted. Contact: ${inquiry?.contactInfo.email ?? 'buyer'}',
    );
  }
  return Response(statusCode: 200);
}
