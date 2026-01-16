import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String offerId) async {
  if (context.request.method != HttpMethod.get) {
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
  final offer = await context.read<OfferRepository>().findById(offerId);
  if (offer == null) {
    return Response(statusCode: 404);
  }
  final isConsultant = auth.roles.contains('consultant');
  if (!isConsultant) {
    final activeRole = auth.activeRole;
    if (activeRole == 'buyer') {
      final inquiry =
          await context.read<InquiryRepository>().findById(offer.inquiryId);
      if (inquiry == null || inquiry.buyerCompanyId != auth.companyId) {
        return Response(statusCode: 403);
      }
    } else if (activeRole == 'provider') {
      if (offer.providerCompanyId != auth.companyId) {
        return Response(statusCode: 403);
      }
    } else {
      return Response(statusCode: 403);
    }
  }
  final pdfPath = offer.pdfPath;
  if (pdfPath == null || pdfPath.isEmpty) {
    return Response(statusCode: 404);
  }
  final signedUrl =
      await context.read<FileStorage>().createSignedUrl(pdfPath);
  if (signedUrl.isEmpty) {
    return Response(statusCode: 404);
  }
  return Response.json(body: {'signedUrl': signedUrl});
}
