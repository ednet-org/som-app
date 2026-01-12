import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import '../routes/Users/loadUserWithCompany.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /Users/loadUserWithCompany', () {
    test('returns combined dto', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(users, company, email: 'user@acme.test');

      final context = TestRequestContext(
        path: '/Users/loadUserWithCompany?userId=${user.id}&companyId=${company.id}',
        method: HttpMethod.get,
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['emailAddress'], user.email);
      expect(body['companyName'], company.name);
    });
  });
}
