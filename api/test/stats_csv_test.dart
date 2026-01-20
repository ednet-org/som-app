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
import 'package:som_api/services/statistics_service.dart';
import '../routes/stats/buyer.dart' as buyer_route;
import '../routes/stats/provider.dart' as provider_route;
import 'test_utils.dart';

class FakeStatisticsService implements StatisticsService {
  @override
  Future<Map<String, int>> buyerStats({
    required String companyId,
    String? userId,
    DateTime? from,
    DateTime? to,
  }) async {
    return {'open': 0, 'closed': 0};
  }

  @override
  Future<Map<String, int>> providerStats({
    required String companyId,
    DateTime? from,
    DateTime? to,
  }) async {
    return {
      'open': 0,
      'offer_created': 0,
      'lost': 0,
      'won': 0,
      'ignored': 0,
    };
  }

  @override
  Future<Map<String, int>> consultantStatusStats({
    DateTime? from,
    DateTime? to,
  }) async {
    return {'open': 0, 'closed': 0, 'won': 0, 'lost': 0};
  }

  @override
  Future<Map<String, int>> consultantPeriodStats({
    DateTime? from,
    DateTime? to,
  }) async {
    return {};
  }

  @override
  Future<Map<String, int>> consultantProviderTypeStats({
    DateTime? from,
    DateTime? to,
  }) async {
    return {};
  }

  @override
  Future<Map<String, int>> consultantProviderSizeStats({
    DateTime? from,
    DateTime? to,
  }) async {
    return {};
  }
}

void main() {
  group('CSV exports for stats', () {
    test('buyer stats CSV includes per-user rows', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final company = await seedCompany(companies, type: 'buyer');
      final admin = await seedUser(
        users,
        company,
        email: 'admin@buyer.test',
        roles: const ['buyer', 'admin'],
      );
      final member = await seedUser(
        users,
        company,
        email: 'member@buyer.test',
        roles: const ['buyer'],
      );
      final now = DateTime.now().toUtc();
      await inquiries.create(
        InquiryRecord(
          id: 'inq-open',
          buyerCompanyId: company.id,
          createdByUserId: admin.id,
          status: 'open',
          branchId: 'branch-1',
          categoryId: 'cat-1',
          productTags: const [],
          deadline: now.add(const Duration(days: 5)),
          deliveryZips: const ['1010'],
          numberOfProviders: 1,
          description: null,
          pdfPath: null,
          providerCriteria: ProviderCriteria(),
          contactInfo: ContactInfo(
            companyName: company.name,
            salutation: admin.salutation,
            title: admin.title ?? '',
            firstName: admin.firstName,
            lastName: admin.lastName,
            telephone: admin.telephoneNr ?? '',
            email: admin.email,
          ),
          notifiedAt: null,
          assignedAt: null,
          closedAt: null,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await inquiries.create(
        InquiryRecord(
          id: 'inq-closed',
          buyerCompanyId: company.id,
          createdByUserId: member.id,
          status: 'closed',
          branchId: 'branch-1',
          categoryId: 'cat-1',
          productTags: const [],
          deadline: now.add(const Duration(days: 5)),
          deliveryZips: const ['1010'],
          numberOfProviders: 1,
          description: null,
          pdfPath: null,
          providerCriteria: ProviderCriteria(),
          contactInfo: ContactInfo(
            companyName: company.name,
            salutation: member.salutation,
            title: member.title ?? '',
            firstName: member.firstName,
            lastName: member.lastName,
            telephone: member.telephoneNr ?? '',
            email: member.email,
          ),
          notifiedAt: null,
          assignedAt: null,
          closedAt: now,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/stats/buyer?format=csv',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<StatisticsService>(FakeStatisticsService());
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await buyer_route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = await response.body();
      final lines = LineSplitter.split(body).toList();
      expect(lines.first, 'email,open,closed');
      expect(body, contains('admin@buyer.test,1,0'));
      expect(body, contains('member@buyer.test,0,1'));
    });

    test('provider stats CSV includes per-user rows', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providerCompany = await seedCompany(companies, type: 'provider');
      final admin = await seedUser(
        users,
        providerCompany,
        email: 'admin@provider.test',
        roles: const ['provider', 'admin'],
      );
      final member = await seedUser(
        users,
        providerCompany,
        email: 'member@provider.test',
        roles: const ['provider'],
      );
      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );

      final now = DateTime.now().toUtc();
      final inquiryA = InquiryRecord(
        id: 'inq-a',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: now.add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
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
        assignedAt: now,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      final inquiryB = InquiryRecord(
        id: 'inq-b',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: now.add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
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
        assignedAt: now,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiryA);
      await inquiries.create(inquiryB);
      await inquiries.assignToProviders(
        inquiryId: inquiryA.id,
        assignedByUserId: admin.id,
        providerCompanyIds: [providerCompany.id],
      );
      await inquiries.assignToProviders(
        inquiryId: inquiryB.id,
        assignedByUserId: admin.id,
        providerCompanyIds: [providerCompany.id],
      );

      await offers.create(
        OfferRecord(
          id: 'offer-1',
          inquiryId: inquiryA.id,
          providerCompanyId: providerCompany.id,
          providerUserId: admin.id,
          status: 'offer_created',
          pdfPath: null,
          forwardedAt: now,
          resolvedAt: null,
          buyerDecision: 'open',
          providerDecision: 'offer_created',
          createdAt: now,
        ),
      );

      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/stats/provider?format=csv',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<StatisticsService>(FakeStatisticsService());
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await provider_route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = await response.body();
      final lines = LineSplitter.split(body).toList();
      expect(lines.first, 'email,open,offerCreated,lost,won,ignored');
      expect(body, contains('admin@provider.test,1,1,0,0,0'));
      expect(body, contains('member@provider.test,2,0,0,0,0'));
    });
  });
}
