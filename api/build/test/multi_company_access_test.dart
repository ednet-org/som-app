import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import '../routes/Users/loadUserWithCompany.dart' as load_route;
import '../routes/auth/switchRole.dart' as switch_route;
import 'test_utils.dart';

void main() {
  group('Multi-company role switching', () {
    test('loadUserWithCompany returns company options and switchRole changes active company', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final providerCompany = await seedCompany(companies, type: 'provider');
      final user = await seedUser(
        users,
        buyerCompany,
        email: 'multi@acme.test',
        roles: const ['buyer', 'admin'],
      );
      await users.addUserToCompany(
        userId: user.id,
        companyId: providerCompany.id,
        roles: const ['provider'],
      );

      final token = buildTestJwt(userId: user.id);
      final initialContext = TestRequestContext(
        path: '/Users/loadUserWithCompany?userId=${user.id}',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      initialContext.provide<UserRepository>(users);
      initialContext.provide<CompanyRepository>(companies);
      final initialResponse = await load_route.onRequest(initialContext.context);
      expect(initialResponse.statusCode, 200);
      final initialBody =
          jsonDecode(await initialResponse.body()) as Map<String, dynamic>;
      expect(initialBody['companyId'], buyerCompany.id);
      expect(initialBody['companyOptions'], isA<List>());
      final options = (initialBody['companyOptions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      expect(options.length, 2);
      expect(
        options.any((option) => option['companyId'] == providerCompany.id),
        isTrue,
      );

      final switchContext = TestRequestContext(
        path: '/auth/switchRole',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
        body: jsonEncode({
          'role': 'provider',
          'companyId': providerCompany.id,
        }),
      );
      switchContext.provide<UserRepository>(users);
      final switchResponse =
          await switch_route.onRequest(switchContext.context);
      expect(switchResponse.statusCode, 200);

      final updatedContext = TestRequestContext(
        path: '/Users/loadUserWithCompany?userId=${user.id}',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      updatedContext.provide<UserRepository>(users);
      updatedContext.provide<CompanyRepository>(companies);
      final updatedResponse = await load_route.onRequest(updatedContext.context);
      expect(updatedResponse.statusCode, 200);
      final updatedBody =
          jsonDecode(await updatedResponse.body()) as Map<String, dynamic>;
      expect(updatedBody['companyId'], providerCompany.id);
      expect(updatedBody['activeRole'], 'provider');
    });
  });
}
