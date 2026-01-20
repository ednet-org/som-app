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
import '../routes/inquiries/[inquiryId]/pdf/generate.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /inquiries/{id}/pdf/generate', () {
    test('generates summary pdf and stores path', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: company.id,
        createdByUserId: user.id,
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
          companyName: company.name,
          salutation: user.salutation,
          title: user.title ?? '',
          firstName: user.firstName,
          lastName: user.lastName,
          telephone: user.telephoneNr ?? '',
          email: user.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);

      final token = buildTestJwt(userId: user.id);
      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/pdf/generate',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(InMemoryOfferRepository());
      context.provide<FileStorage>(TestFileStorage());
      context.provide<PdfGenerator>(PdfGenerator());
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await route.onRequest(context.context, inquiry.id);
      expect(response.statusCode, 200);
      final payload = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(payload['summaryPdfPath'], 'inquiries/summary/inquiry_inq-1.pdf');
      expect(payload['signedUrl'], contains('https://signed.test/'));
      final updated = await inquiries.findById(inquiry.id);
      expect(updated?.summaryPdfPath, 'inquiries/summary/inquiry_inq-1.pdf');
    });
  });
}
