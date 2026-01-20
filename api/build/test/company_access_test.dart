import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import '../routes/Companies/index.dart' as companies_route;
import '../routes/Companies/[companyId]/index.dart' as company_route;
import 'test_utils.dart';

void main() {
  group('Company access control', () {
    test('GET /Companies requires auth', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      await seedCompany(companies, type: 'buyer');

      final context = TestRequestContext(
        path: '/Companies',
        method: HttpMethod.get,
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);

      final response = await companies_route.onRequest(context.context);
      expect(response.statusCode, 401);
    });

    test('non-consultant only lists own company', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies, type: 'buyer');
      await seedCompany(companies, type: 'buyer');
      final user = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/Companies',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);

      final response = await companies_route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.length, 1);
      expect(body.first['id'], company.id);
    });

    test('GET /Companies/{id} blocks cross-tenant access', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies, type: 'buyer');
      final otherCompany = await seedCompany(companies, type: 'buyer');
      final user = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/Companies/${otherCompany.id}',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);

      final response = await company_route.onRequest(
        context.context,
        otherCompany.id,
      );
      expect(response.statusCode, 403);
    });
  });
}
