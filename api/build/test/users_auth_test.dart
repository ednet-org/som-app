import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import '../routes/Companies/[companyId]/registerUser.dart' as register_route;
import '../routes/Companies/[companyId]/users/index.dart' as list_route;
import 'test_utils.dart';

void main() {
  group('Company user auth', () {
    test('register user requires admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final auth = createAuthService(users);
      final company = await seedCompany(companies);
      final nonAdmin = await seedUser(
        users,
        company,
        email: 'user@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: nonAdmin.id);

      final context = TestRequestContext(
        path: '/Companies/${company.id}/registerUser',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': 'new@acme.test',
          'firstName': 'New',
          'lastName': 'User',
          'salutation': 'Mr',
          'roles': [2],
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<AuthService>(auth);
      context.provide<CompanyRepository>(companies);

      final response =
          await register_route.onRequest(context.context, company.id);
      expect(response.statusCode, 403);
    });

    test('register user logs audit entry', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final auth = createAuthService(users);
      final auditRepo = InMemoryAuditLogRepository();
      final audit = AuditService(repository: auditRepo);
      final company = await seedCompany(companies);
      final admin = await seedUser(
        users,
        company,
        email: 'admin@acme.test',
        roles: const ['admin'],
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
          'email': 'new@acme.test',
          'firstName': 'New',
          'lastName': 'User',
          'salutation': 'Mr',
          'roles': [2],
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<AuthService>(auth);
      context.provide<AuditService>(audit);
      context.provide<CompanyRepository>(companies);

      final response =
          await register_route.onRequest(context.context, company.id);
      expect(response.statusCode, 200);
      final entries = await auditRepo.listRecent();
      expect(entries.first.action, 'user.created');
    });

    test('list users returns only self for non-admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      final admin = await seedUser(
        users,
        company,
        email: 'admin@acme.test',
        roles: const ['admin'],
      );
      final member = await seedUser(
        users,
        company,
        email: 'member@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: member.id);

      final context = TestRequestContext(
        path: '/Companies/${company.id}/users',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);

      final response = await list_route.onRequest(context.context, company.id);
      expect(response.statusCode, 200);
      final body = await response.body();
      final decoded = jsonDecode(body) as List<dynamic>;
      expect(decoded.length, 1);
      expect(decoded.first['email'], member.email);

      // Ensure admin still exists (sanity for fixture).
      expect(admin.email, 'admin@acme.test');
    });
  });
}
