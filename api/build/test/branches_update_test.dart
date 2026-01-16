import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/branches/[branchId]/index.dart' as branch_route;
import '../routes/categories/[categoryId]/index.dart' as category_route;
import 'test_utils.dart';

void main() {
  group('PUT /branches/{branchId}', () {
    test('requires consultant role', () async {
      final branches = InMemoryBranchRepository();
      final users = InMemoryUserRepository();
      await branches.createBranch(BranchRecord(id: 'branch-1', name: 'Old'));

      final context = TestRequestContext(
        path: '/branches/branch-1',
        method: HttpMethod.put,
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'name': 'New'}),
      );
      context.provide<BranchRepository>(branches);
      context.provide<UserRepository>(users);
      final providers = InMemoryProviderRepository();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: InMemoryCompanyRepository(),
        providers: providers,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: TestEmailService(),
      );
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: InMemoryCompanyRepository(),
          inquiries: InMemoryInquiryRepository(),
        ),
      );

      final response = await branch_route.onRequest(context.context, 'branch-1');
      expect(response.statusCode, 403);
    });

    test('updates branch name', () async {
      final branches = InMemoryBranchRepository();
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'consultant@som.test',
        roles: const ['consultant'],
      );
      await branches.createBranch(BranchRecord(id: 'branch-1', name: 'Old'));
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/branches/branch-1',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': 'New'}),
      );
      context.provide<BranchRepository>(branches);
      context.provide<UserRepository>(users);
      final providers = InMemoryProviderRepository();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: TestEmailService(),
      );
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );

      final response = await branch_route.onRequest(context.context, 'branch-1');
      expect(response.statusCode, 200);
      final updated = await branches.findBranchById('branch-1');
      expect(updated?.name, 'New');
    });

    test('renaming a branch notifies provider admins', () async {
      final branches = InMemoryBranchRepository();
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final providers = InMemoryProviderRepository();
      final consultantCompany = await seedCompany(companies);
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant', 'admin'],
      );
      final providerCompany = await seedCompany(companies, type: 'provider');
      await seedUser(
        users,
        providerCompany,
        email: 'provider-admin@som.test',
        roles: const ['provider', 'admin'],
      );
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(
            iban: 'iban',
            bic: 'bic',
            accountOwner: 'owner',
          ),
          branchIds: const ['branch-1'],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await branches.createBranch(BranchRecord(id: 'branch-1', name: 'Old'));
      final token = buildTestJwt(userId: consultant.id);
      final email = TestEmailService();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: email,
      );
      final context = TestRequestContext(
        path: '/branches/branch-1',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': 'New'}),
      );
      context.provide<BranchRepository>(branches);
      context.provide<UserRepository>(users);
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );

      final response = await branch_route.onRequest(context.context, 'branch-1');
      expect(response.statusCode, 200);
      expect(email.sent.length, 1);
      expect(email.sent.first.subject, contains('Branch updated'));
    });
  });

  group('PUT /categories/{categoryId}', () {
    test('updates category name', () async {
      final branches = InMemoryBranchRepository();
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'consultant2@som.test',
        roles: const ['consultant'],
      );
      await branches.createBranch(BranchRecord(id: 'branch-1', name: 'Main'));
      await branches.createCategory(
        CategoryRecord(id: 'cat-1', branchId: 'branch-1', name: 'Old'),
      );
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/categories/cat-1',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': 'New'}),
      );
      context.provide<BranchRepository>(branches);
      context.provide<UserRepository>(users);
      final providers = InMemoryProviderRepository();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: TestEmailService(),
      );
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );

      final response =
          await category_route.onRequest(context.context, 'cat-1');
      expect(response.statusCode, 200);
      final updated = await branches.findCategoryById('cat-1');
      expect(updated?.name, 'New');
    });
  });
}
