import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
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
  final inquiryRepo = context.read<InquiryRepository>();
  final assigned =
      await inquiryRepo.isAssignedToProvider(inquiryId, auth.companyId);
  if (!assigned) {
    return Response.json(
      statusCode: 403,
      body: 'Inquiry not assigned to provider.',
    );
  }
  final offer = OfferRecord(
    id: const Uuid().v4(),
    inquiryId: inquiryId,
    providerCompanyId: auth.companyId,
    providerUserId: auth.userId,
    status: 'ignored',
    pdfPath: null,
    forwardedAt: DateTime.now().toUtc(),
    resolvedAt: DateTime.now().toUtc(),
    buyerDecision: 'open',
    providerDecision: 'ignored',
    createdAt: DateTime.now().toUtc(),
  );
  await context.read<OfferRepository>().create(offer);
  return Response.json(body: {'id': offer.id, 'status': offer.status});
}
