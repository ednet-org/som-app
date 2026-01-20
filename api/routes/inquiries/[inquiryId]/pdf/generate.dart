import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/pdf_generator.dart';
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
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final inquiryRepo = context.read<InquiryRepository>();
  final inquiry = await inquiryRepo.findById(inquiryId);
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
      final provider = await context
          .read<ProviderRepository>()
          .findByCompany(auth.companyId);
      if (provider == null || provider.status != 'active') {
        return Response.json(
          statusCode: 403,
          body: 'Provider registration is pending.',
        );
      }
      final assigned =
          await inquiryRepo.isAssignedToProvider(inquiryId, auth.companyId);
      if (!assigned) {
        return Response.json(
          statusCode: 403,
          body: 'Inquiry not assigned to provider.',
        );
      }
    } else {
      return Response(statusCode: 403);
    }
  }
  final offerRepo = context.read<OfferRepository>();
  final companyRepo = context.read<CompanyRepository>();
  final offers = await offerRepo.listByInquiry(inquiryId);
  final providerNames = <String, String>{};
  for (final offer in offers) {
    final company = await companyRepo.findById(offer.providerCompanyId);
    if (company != null) {
      providerNames[offer.providerCompanyId] = company.name;
    }
  }
  final buyerCompany = await companyRepo.findById(inquiry.buyerCompanyId);
  final pdfGenerator = context.read<PdfGenerator>();
  final bytes = await pdfGenerator.generateInquirySummary(
    inquiry: inquiry,
    buyerCompany: buyerCompany,
    offers: offers,
    providerNames: providerNames,
  );
  final storage = context.read<FileStorage>();
  final pdfPath = await storage.saveFile(
    category: 'inquiries/summary',
    fileName: 'inquiry_${inquiry.id}.pdf',
    bytes: bytes,
    includeTimestamp: false,
  );
  await inquiryRepo.updateSummaryPdfPath(inquiry.id, pdfPath);
  final signedUrl = await storage.createSignedUrl(pdfPath);
  await context.read<AuditService>().log(
        action: 'inquiry.pdf.generated',
        entityType: 'inquiry',
        entityId: inquiry.id,
        actorId: auth.userId,
        metadata: {'companyId': auth.companyId},
      );
  return Response.json(
    body: {'summaryPdfPath': pdfPath, 'signedUrl': signedUrl},
  );
}
