import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/file_storage.dart';
import '../routes/inquiries/[inquiryId]/pdf.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /inquiries/{id}/pdf', () {
    test('returns signed url for buyer company', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final providers = InMemoryProviderRepository();

      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: user.id);
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: company.id,
        createdByUserId: user.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const ['tag'],
        deadline: now.add(const Duration(days: 3)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Test',
        pdfPath: 'inquiries/test.pdf',
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

      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/pdf',
        method: HttpMethod.get,
        headers: {
          'authorization': 'Bearer $token',
        },
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<InquiryRepository>(inquiries);
      context.provide<ProviderRepository>(providers);
      context.provide<FileStorage>(TestFileStorage());

      final response = await route.onRequest(context.context, inquiry.id);
      expect(response.statusCode, 200);
      final payload = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(payload['signedUrl'], isNotEmpty);
    });
  });
}
