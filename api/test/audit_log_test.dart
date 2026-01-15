import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import '../routes/Companies/[companyId]/users/[userId]/update.dart' as user_update_route;
import '../routes/Subscriptions/downgrade.dart' as downgrade_route;
import 'test_utils.dart';

void main() {
  group('Audit logging', () {
    test('logs role changes when updating user', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      final admin = await seedUser(
        users,
        company,
        email: 'admin@som.test',
        roles: const ['admin'],
      );
      final member = await seedUser(
        users,
        company,
        email: 'member@som.test',
        roles: const ['buyer'],
      );
      final auditRepo = InMemoryAuditLogRepository();
      final audit = AuditService(repository: auditRepo);
      final token = buildTestJwt(userId: admin.id);

      final context = TestRequestContext(
        path: '/Companies/${company.id}/users/${member.id}/update',
        method: HttpMethod.put,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'roles': [1]}),
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<AuditService>(audit);

      final response =
          await user_update_route.onRequest(context.context, company.id, member.id);
      expect(response.statusCode, 200);

      final entries = await auditRepo.listRecent();
      expect(entries.first.action, 'user.roles.updated');
    });

    test('logs subscription downgrade', () async {
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

      final auditRepo = InMemoryAuditLogRepository();
      final audit = AuditService(repository: auditRepo);
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
      context.provide<AuditService>(audit);

      final response = await downgrade_route.onRequest(context.context);
      expect(response.statusCode, 200);
      final entries = await auditRepo.listRecent();
      expect(entries.first.action, 'subscription.downgraded');
    });
  });
}
