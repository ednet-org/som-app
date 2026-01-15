import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import '../routes/Subscriptions/index.dart' as subscriptions_route;
import '../routes/Subscriptions/plans/[planId]/index.dart' as plan_route;
import 'test_utils.dart';

void main() {
  group('Subscription plan fields', () {
    test('creates plan with extended fields', () async {
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(InMemoryCompanyRepository());
      final admin = await seedUser(
        users,
        company,
        email: 'consultant@som.test',
        roles: const ['consultant', 'admin'],
      );
      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/Subscriptions',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': 'Extended Plan',
          'sortPriority': 1,
          'priceInSubunit': 1000,
          'isActive': true,
          'maxUsers': 3,
          'setupFeeInSubunit': 500,
          'bannerAdsPerMonth': 1,
          'normalAdsPerMonth': 2,
          'freeMonths': 2,
          'commitmentPeriodMonths': 12,
          'rules': [
            {'restriction': 0, 'upperLimit': 3}
          ]
        }),
      );
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await subscriptions_route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['maxUsers'], 3);
      expect(body['setupFeeInSubunit'], 500);
      expect(body['bannerAdsPerMonth'], 1);
      expect(body['normalAdsPerMonth'], 2);
      expect(body['freeMonths'], 2);
      expect(body['commitmentPeriodMonths'], 12);
    });

    test('updates plan with extended fields', () async {
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(InMemoryCompanyRepository());
      final admin = await seedUser(
        users,
        company,
        email: 'consultant@som.test',
        roles: const ['consultant', 'admin'],
      );
      final plan = SubscriptionPlanRecord(
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
        rules: const [],
        createdAt: DateTime.now().toUtc(),
      );
      await subscriptions.createPlan(plan);

      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/Subscriptions/plans/${plan.id}',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': 'Updated',
          'sortPriority': 2,
          'priceInSubunit': 2000,
          'maxUsers': 5,
          'setupFeeInSubunit': 1000,
          'bannerAdsPerMonth': 2,
          'normalAdsPerMonth': 3,
          'freeMonths': 1,
          'commitmentPeriodMonths': 24,
          'rules': [
            {'restriction': 0, 'upperLimit': 5}
          ],
          'confirm': true
        }),
      );
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await plan_route.onRequest(context.context, plan.id);
      expect(response.statusCode, 200);
      final updated = await subscriptions.findPlanById(plan.id);
      expect(updated?.maxUsers, 5);
      expect(updated?.setupFeeInSubunit, 1000);
      expect(updated?.bannerAdsPerMonth, 2);
      expect(updated?.normalAdsPerMonth, 3);
      expect(updated?.freeMonths, 1);
      expect(updated?.commitmentPeriodMonths, 24);
    });
  });
}
