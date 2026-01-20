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
import '../routes/offers/[offerId]/pdf.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /offers/{id}/pdf', () {
    test('returns signed url for buyer company', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();

      final buyerCompany = await seedCompany(companies);
      final providerCompany = await seedCompany(
        companies,
        type: 'provider',
      );
      final buyer = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: buyer.id);
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyer.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const ['tag'],
        deadline: now.add(const Duration(days: 3)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Test',
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: buyerCompany.name,
          salutation: buyer.salutation,
          title: buyer.title ?? '',
          firstName: buyer.firstName,
          lastName: buyer.lastName,
          telephone: buyer.telephoneNr ?? '',
          email: buyer.email,
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
        pdfPath: 'offers/test.pdf',
        forwardedAt: now,
        resolvedAt: null,
        buyerDecision: 'open',
        providerDecision: 'offer_created',
        createdAt: now,
      );
      await offers.create(offer);

      final context = TestRequestContext(
        path: '/offers/${offer.id}/pdf',
        method: HttpMethod.get,
        headers: {
          'authorization': 'Bearer $token',
        },
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<FileStorage>(TestFileStorage());
      final auditRepo = InMemoryAuditLogRepository();
      context.provide<AuditService>(AuditService(repository: auditRepo));

      final response = await route.onRequest(context.context, offer.id);
      expect(response.statusCode, 200);
      final payload = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(payload['signedUrl'], isNotEmpty);

      final entries = await auditRepo.listRecent();
      expect(entries.first.action, 'offer.pdf.downloaded');
    });
  });
}
