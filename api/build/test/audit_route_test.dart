import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/audit_log_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/audit/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /audit', () {
    test('requires consultant admin', () async {
      final users = InMemoryUserRepository();
      final auditRepo = InMemoryAuditLogRepository();
      final context = TestRequestContext(
        path: '/audit',
        method: HttpMethod.get,
      );
      context.provide<UserRepository>(users);
      context.provide<AuditLogRepository>(auditRepo);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 403);
    });

    test('returns audit entries for consultant admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final auditRepo = InMemoryAuditLogRepository();
      final company = await seedCompany(companies);
      final admin = await seedUser(
        users,
        company,
        email: 'consultant-admin@som.test',
        roles: const ['consultant', 'admin'],
      );
      await auditRepo.create(
        AuditLogRecord(
          id: 'audit-1',
          actorId: admin.id,
          action: 'auth.login_failed',
          entityType: 'user',
          entityId: admin.id,
          metadata: {'reason': 'test'},
          createdAt: DateTime.now().toUtc(),
        ),
      );
      final token = buildTestJwt(userId: admin.id);
      final context = TestRequestContext(
        path: '/audit?limit=10',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<AuditLogRepository>(auditRepo);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.length, 1);
      expect(body.first['action'], 'auth.login_failed');
    });
  });
}
