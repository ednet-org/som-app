import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/pdf_generator.dart';
import '../routes/offers/[offerId]/pdf/generate.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /offers/{id}/pdf/generate', () {
    test('generates summary pdf and stores path', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final providerCompany = await seedCompany(companies, type: 'provider');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: now.add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Test inquiry',
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: buyerCompany.name,
          salutation: buyerUser.salutation,
          title: buyerUser.title ?? '',
          firstName: buyerUser.firstName,
          lastName: buyerUser.lastName,
          telephone: buyerUser.telephoneNr ?? '',
          email: buyerUser.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);
      final offer = OfferRecord(
        id: 'offer-1',
        inquiryId: inquiry.id,
        providerCompanyId: providerCompany.id,
        providerUserId: null,
        status: 'offer_created',
        pdfPath: null,
        forwardedAt: now,
        resolvedAt: null,
        buyerDecision: 'open',
        providerDecision: 'offer_created',
        createdAt: now,
      );
      await offers.create(offer);

      final token = buildTestJwt(userId: buyerUser.id);
      final context = TestRequestContext(
        path: '/offers/${offer.id}/pdf/generate',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<PdfGenerator>(PdfGenerator());
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await route.onRequest(context.context, offer.id);
      expect(response.statusCode, 200);
      final payload = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(payload['summaryPdfPath'], 'offers/summary/offer_offer-1.pdf');
      expect(payload['signedUrl'], contains('https://signed.test/'));
      final updated = await offers.findById(offer.id);
      expect(updated?.summaryPdfPath, 'offers/summary/offer_offer-1.pdf');
    });
  });
}
