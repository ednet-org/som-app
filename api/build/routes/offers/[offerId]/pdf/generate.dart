import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/pdf_generator.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String offerId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final offerRepo = context.read<OfferRepository>();
  final offer = await offerRepo.findById(offerId);
  if (offer == null) {
    return Response(statusCode: 404);
  }
  final inquiryRepo = context.read<InquiryRepository>();
  final inquiry = await inquiryRepo.findById(offer.inquiryId);
  if (inquiry == null) {
    return Response(statusCode: 404);
  }
  final isConsultant = auth.roles.contains('consultant');
  if (!isConsultant) {
    if (auth.activeRole == 'buyer') {
      if (inquiry.buyerCompanyId != auth.companyId) {
        return Response(statusCode: 403);
      }
    } else if (auth.activeRole == 'provider') {
      if (offer.providerCompanyId != auth.companyId) {
        return Response(statusCode: 403);
      }
    } else {
      return Response(statusCode: 403);
    }
  }
  final companyRepo = context.read<CompanyRepository>();
  final buyerCompany = await companyRepo.findById(inquiry.buyerCompanyId);
  final providerCompany =
      await companyRepo.findById(offer.providerCompanyId);
  final pdfGenerator = context.read<PdfGenerator>();
  final bytes = await pdfGenerator.generateOfferSummary(
    offer: offer,
    inquiry: inquiry,
    buyerCompany: buyerCompany,
    providerCompany: providerCompany,
  );
  final storage = context.read<FileStorage>();
  final pdfPath = await storage.saveFile(
    category: 'offers/summary',
    fileName: 'offer_${offer.id}.pdf',
    bytes: bytes,
    includeTimestamp: false,
  );
  await offerRepo.updateSummaryPdfPath(offer.id, pdfPath);
  final signedUrl = await storage.createSignedUrl(pdfPath);
  await context.read<AuditService>().log(
        action: 'offer.pdf.generated',
        entityType: 'offer',
        entityId: offer.id,
        actorId: auth.userId,
        metadata: {'companyId': auth.companyId, 'inquiryId': inquiry.id},
      );
  return Response.json(
    body: {'summaryPdfPath': pdfPath, 'signedUrl': signedUrl},
  );
}
