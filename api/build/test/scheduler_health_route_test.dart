import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/scheduler_status_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import '../routes/health/scheduler.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /health/scheduler', () {
    test('requires consultant admin', () async {
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'buyer@som.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/health/scheduler',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<SchedulerStatusRepository>(
        InMemorySchedulerStatusRepository(),
      );

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 403);
    });

    test('returns scheduler status for consultant admin', () async {
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final company = await seedCompany(companies);
      final consultant = await seedUser(
        users,
        company,
        email: 'consultant@som.test',
        roles: const ['consultant', 'admin'],
      );
      final token = buildTestJwt(userId: consultant.id);
      final statusRepo = InMemorySchedulerStatusRepository();
      await statusRepo.recordRun(
        jobName: 'ads.expiry',
        runAt: DateTime.now().toUtc(),
        success: true,
      );

      final context = TestRequestContext(
        path: '/health/scheduler',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<SchedulerStatusRepository>(statusRepo);

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.first['jobName'], 'ads.expiry');
    });
  });
}
