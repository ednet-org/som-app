import 'package:dart_frog/dart_frog.dart';

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
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET', defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<OfferRepository>();
  final offer = await repo.findById(offerId);
  if (offer == null) {
    return Response(statusCode: 404);
  }
  await repo.updateStatus(
    id: offerId,
    status: 'rejected',
    buyerDecision: 'rejected',
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
  return Response(statusCode: 200);
}
