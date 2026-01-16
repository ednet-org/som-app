import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import '../routes/Users/[userId]/unlock.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /Users/{userId}/unlock', () {
    test('requires authentication', () async {
      final users = InMemoryUserRepository();
      final context = TestRequestContext(
        path: '/Users/user-id/unlock',
        method: HttpMethod.post,
      );
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );
      final response = await route.onRequest(context.context, 'user-id');
      expect(response.statusCode, 401);
    });

    test('forbids non-consultant admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      final buyerAdmin = await seedUser(
        users,
        company,
        email: 'buyer-admin@example.com',
        roles: const ['buyer', 'admin'],
      );
      final token = buildTestJwt(userId: buyerAdmin.id);

      final context = TestRequestContext(
        path: '/Users/${buyerAdmin.id}/unlock',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await route.onRequest(context.context, buyerAdmin.id);
      expect(response.statusCode, 403);
    });

    test('unlocks user account', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      final lockedUser = await seedUser(
        users,
        company,
        email: 'locked@example.com',
        roles: const ['buyer'],
      );
      final now = DateTime.now().toUtc();
      await users.update(
        lockedUser.copyWith(
          failedLoginAttempts: 5,
          lastFailedLoginAt: now,
          lockedAt: now,
          lockReason: 'Too many failed attempts',
          updatedAt: now,
        ),
      );

      final consultantAdmin = await seedUser(
        users,
        company,
        email: 'consultant-admin@example.com',
        roles: const ['consultant', 'admin'],
      );
      final token = buildTestJwt(userId: consultantAdmin.id);

      final context = TestRequestContext(
        path: '/Users/${lockedUser.id}/unlock',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<Clock>(Clock());
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await route.onRequest(context.context, lockedUser.id);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], 'unlocked');

      final refreshed = await users.findById(lockedUser.id);
      expect(refreshed, isNotNull);
      expect(refreshed!.lockedAt, isNull);
      expect(refreshed.lockReason, isNull);
      expect(refreshed.failedLoginAttempts, 0);
      expect(refreshed.lastFailedLoginAt, isNull);
    });
  });
}
