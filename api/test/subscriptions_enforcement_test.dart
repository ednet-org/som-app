import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/registration_service.dart';
import '../routes/Companies/[companyId]/registerUser.dart'
    as register_user_route;
import '../routes/Companies/index.dart' as companies_route;
import '../routes/Subscriptions/plans/[planId]/index.dart' as plan_route;
import '../routes/Subscriptions/downgrade.dart' as downgrade_route;
import 'test_utils.dart';

void main() {
  group('Subscription enforcement', () {
    test('plan update requires confirmation when active subscribers exist',
        () async {
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-1',
          name: 'Plan',
          sortPriority: 1,
          isActive: true,
          priceInSubunit: 1000,
          maxUsers: 1,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 1},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: 'company-1',
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 30)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-new',
          name: 'New plan',
          sortPriority: 2,
          isActive: true,
          priceInSubunit: 500,
          maxUsers: 5,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 5},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );
      final consultantCompany = await seedCompany(
        InMemoryCompanyRepository(),
      );
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant', 'admin'],
      );
      final token = buildTestJwt(userId: consultant.id);

      final context = TestRequestContext(
        path: '/Subscriptions/plans/plan-1',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await plan_route.onRequest(context.context, 'plan-1');
      expect(response.statusCode, 400);

      final confirmContext = TestRequestContext(
        path: '/Subscriptions/plans/plan-1',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'confirm': true}),
      );
      confirmContext.provide<SubscriptionRepository>(subscriptions);
      confirmContext.provide<UserRepository>(users);
      confirmContext.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final confirmResponse =
          await plan_route.onRequest(confirmContext.context, 'plan-1');
      expect(confirmResponse.statusCode, 200);
    });

    test('downgrade blocked outside renewal window', () async {
      final subscriptions = InMemorySubscriptionRepository();
      final providers = InMemoryProviderRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final admin = await seedUser(
        users,
        company,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: company.id,
          planId: 'plan-old',
          status: 'active',
          paymentInterval: 'yearly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 200)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-new',
          name: 'New plan',
          sortPriority: 2,
          isActive: true,
          priceInSubunit: 500,
          maxUsers: 5,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 5},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: company.id,
          bankDetails: BankDetails(
            iban: 'iban',
            bic: 'bic',
            accountOwner: 'owner',
          ),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-old',
          paymentInterval: 'yearly',
          providerType: 'haendler',
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-new',
          name: 'New plan',
          sortPriority: 2,
          isActive: true,
          priceInSubunit: 500,
          maxUsers: 5,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 5},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/Subscriptions/downgrade',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'planId': 'plan-new'}),
      );
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<ProviderRepository>(providers);
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await downgrade_route.onRequest(context.context);
      expect(response.statusCode, 400);
    });

    test('downgrade succeeds within renewal window', () async {
      final subscriptions = InMemorySubscriptionRepository();
      final providers = InMemoryProviderRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final admin = await seedUser(
        users,
        company,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: company.id,
          planId: 'plan-old',
          status: 'active',
          paymentInterval: 'yearly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 10)),
          createdAt: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        ),
      );
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: company.id,
          bankDetails: BankDetails(
            iban: 'iban',
            bic: 'bic',
            accountOwner: 'owner',
          ),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-old',
          paymentInterval: 'yearly',
          providerType: 'haendler',
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-new',
          name: 'New plan',
          sortPriority: 2,
          isActive: true,
          priceInSubunit: 500,
          maxUsers: 5,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 5},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/Subscriptions/downgrade',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'planId': 'plan-new'}),
      );
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<ProviderRepository>(providers);
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await downgrade_route.onRequest(context.context);
      final body = await response.body();
      expect(response.statusCode, 200, reason: body);
      final current = await subscriptions.findSubscriptionByCompany(company.id);
      expect(current?.planId, 'plan-new');
    });

    test('registration enforces max users for subscription plan', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final branches = InMemoryBranchRepository();
      final auth = createAuthService(users);
      final clock = Clock();
      final domain = SomDomainModel();
      await branches.createBranch(
        BranchRecord(id: 'branch-1', name: 'Demo', status: 'active'),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-1',
          name: 'Plan',
          sortPriority: 1,
          isActive: true,
          priceInSubunit: 1000,
          maxUsers: 1,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 1},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );
      final registration = RegistrationService(
        companies: companies,
        users: users,
        providers: providers,
        subscriptions: subscriptions,
        branches: branches,
        companyTaxonomy: InMemoryCompanyTaxonomyRepository(),
        auth: auth,
        clock: clock,
        domain: domain,
      );

      final context = TestRequestContext(
        path: '/Companies',
        method: HttpMethod.post,
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'company': {
            'name': 'Provider Co',
            'type': 1,
            'uidNr': 'UID',
            'registrationNr': 'REG',
            'companySize': 0,
            'termsAccepted': true,
            'privacyAccepted': true,
            'address': {
              'country': 'AT',
              'city': 'Vienna',
              'street': 'Main',
              'number': '1',
              'zip': '1010',
            },
            'providerData': {
              'bankDetails': {
                'iban': 'iban',
                'bic': 'bic',
                'accountOwner': 'owner',
              },
              'branchIds': ['branch-1'],
              'providerType': 'haendler',
              'subscriptionPlanId': 'plan-1',
              'paymentInterval': 0,
            },
          },
          'users': [
            {
              'email': 'admin@provider.test',
              'firstName': 'Admin',
              'lastName': 'User',
              'salutation': 'Mr',
              'roles': [4],
            },
            {
              'email': 'user@provider.test',
              'firstName': 'User',
              'lastName': 'Two',
              'salutation': 'Ms',
              'roles': [1],
            },
          ],
        }),
      );
      context.provide<RegistrationService>(registration);

      final response = await companies_route.onRequest(context.context);
      expect(response.statusCode, 400);
    });

    test('registerUser enforces max users for provider plan', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final auth = createAuthService(users);

      final company = await seedCompany(companies, type: 'provider');
      final admin = await seedUser(
        users,
        company,
        email: 'admin@provider.test',
        roles: const ['provider', 'admin'],
      );
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: company.id,
          bankDetails: BankDetails(
            iban: 'iban',
            bic: 'bic',
            accountOwner: 'owner',
          ),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-1',
          name: 'Plan',
          sortPriority: 1,
          isActive: true,
          priceInSubunit: 1000,
          maxUsers: 1,
          setupFeeInSubunit: 0,
          bannerAdsPerMonth: 0,
          normalAdsPerMonth: 0,
          freeMonths: 0,
          commitmentPeriodMonths: 12,
          rules: const [
            {'id': 'rule-1', 'restriction': 0, 'upperLimit': 1},
          ],
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/Companies/${company.id}/registerUser',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': 'new@provider.test',
          'firstName': 'New',
          'lastName': 'User',
          'salutation': 'Mr',
          'roles': [1],
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<AuthService>(auth);
      context.provide<CompanyRepository>(companies);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);

      final response =
          await register_user_route.onRequest(context.context, company.id);
      expect(response.statusCode, 400);
    });
  });
}
