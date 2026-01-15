import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/file_storage.dart';
import '../routes/inquiries/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /inquiries filters', () {
    test('filters by status for buyer', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final branches = InMemoryBranchRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer', 'admin'],
      );
      await inquiries.create(
        InquiryRecord(
          id: 'inq-open',
          buyerCompanyId: company.id,
          createdByUserId: user.id,
          status: 'open',
          branchId: 'branch-1',
          categoryId: 'cat-1',
          productTags: const ['tag'],
          deadline: DateTime.now().toUtc().add(const Duration(days: 4)),
          deliveryZips: const ['1010'],
          numberOfProviders: 1,
          description: null,
          pdfPath: null,
          providerCriteria: ProviderCriteria(providerType: 'Händler'),
          contactInfo: ContactInfo(
            companyName: company.name,
            salutation: 'Mr',
            title: '',
            firstName: 'Buyer',
            lastName: 'Admin',
            telephone: '',
            email: user.email,
          ),
          notifiedAt: null,
          assignedAt: null,
          closedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await inquiries.create(
        InquiryRecord(
          id: 'inq-closed',
          buyerCompanyId: company.id,
          createdByUserId: user.id,
          status: 'closed',
          branchId: 'branch-1',
          categoryId: 'cat-1',
          productTags: const ['tag'],
          deadline: DateTime.now().toUtc().add(const Duration(days: 4)),
          deliveryZips: const ['1010'],
          numberOfProviders: 1,
          description: null,
          pdfPath: null,
          providerCriteria: ProviderCriteria(providerType: 'Händler'),
          contactInfo: ContactInfo(
            companyName: company.name,
            salutation: 'Mr',
            title: '',
            firstName: 'Buyer',
            lastName: 'Admin',
            telephone: '',
            email: user.email,
          ),
          notifiedAt: null,
          assignedAt: null,
          closedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );

      final token = buildTestJwt(userId: user.id);
      final context = TestRequestContext(
        path: '/inquiries?status=open',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<InquiryRepository>(inquiries);
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<CompanyRepository>(companies);
      context.provide<BranchRepository>(branches);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.length, 1);
      expect(body.first['id'], 'inq-open');
    });
  });
}
