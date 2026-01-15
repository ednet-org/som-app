import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/inquiries/[inquiryId]/close.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /inquiries/{id}/close', () {
    test('buyer can close inquiry and sets closedAt', () async {
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final company = await seedCompany(InMemoryCompanyRepository());
      final buyer = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: buyer.id);
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-close',
        buyerCompanyId: company.id,
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
          companyName: company.name,
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

      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/close',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);

      final response = await route.onRequest(context.context, inquiry.id);
      expect(response.statusCode, 200);
      final updated = await inquiries.findById(inquiry.id);
      expect(updated?.status, 'closed');
      expect(updated?.closedAt, isNotNull);
    });

    test('provider cannot close inquiry', () async {
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final company = await seedCompany(InMemoryCompanyRepository());
      final provider = await seedUser(
        users,
        company,
        email: 'provider@acme.test',
        roles: const ['provider'],
      );
      final token = buildTestJwt(userId: provider.id);
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-close-blocked',
        buyerCompanyId: company.id,
        createdByUserId: provider.id,
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
          companyName: company.name,
          salutation: provider.salutation,
          title: provider.title ?? '',
          firstName: provider.firstName,
          lastName: provider.lastName,
          telephone: provider.telephoneNr ?? '',
          email: provider.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);

      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/close',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);

      final response = await route.onRequest(context.context, inquiry.id);
      expect(response.statusCode, 403);
    });
  });
}
