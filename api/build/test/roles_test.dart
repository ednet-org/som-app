import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/role_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import '../routes/roles/index.dart' as roles_route;
import '../routes/roles/[roleId]/index.dart' as role_route;
import 'test_utils.dart';

void main() {
  group('Role management', () {
    late InMemoryRoleRepository roles;
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;

    setUp(() async {
      roles = InMemoryRoleRepository();
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      await roles.seedDefaults();
      await seedUser(
        users,
        company,
        email: 'consultant-admin@som.test',
        roles: const ['consultant', 'admin'],
      );
    });

    test('consultant admin can list roles', () async {
      final user = await users.findByEmail('consultant-admin@som.test');
      final token = buildTestJwt(userId: user!.id);
      final context = TestRequestContext(
        path: '/roles',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<RoleRepository>(roles);
      context.provide<UserRepository>(users);
      final response = await roles_route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body, isNotEmpty);
    });

    test('non-consultant cannot create role', () async {
      final company = await seedCompany(companies);
      final buyer = await seedUser(
        users,
        company,
        email: 'buyer@som.test',
        roles: const ['buyer', 'admin'],
      );
      final token = buildTestJwt(userId: buyer.id);
      final context = TestRequestContext(
        path: '/roles',
        method: HttpMethod.post,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'name': 'auditor', 'description': 'Auditor role'}),
      );
      context.provide<RoleRepository>(roles);
      context.provide<UserRepository>(users);
      final response = await roles_route.onRequest(context.context);
      expect(response.statusCode, 403);
    });

    test('consultant admin can create and update role', () async {
      final user = await users.findByEmail('consultant-admin@som.test');
      final token = buildTestJwt(userId: user!.id);
      final createContext = TestRequestContext(
        path: '/roles',
        method: HttpMethod.post,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'name': 'auditor', 'description': 'Auditor role'}),
      );
      createContext.provide<RoleRepository>(roles);
      createContext.provide<UserRepository>(users);
      final createResponse = await roles_route.onRequest(createContext.context);
      expect(createResponse.statusCode, 200);
      final created =
          jsonDecode(await createResponse.body()) as Map<String, dynamic>;
      final roleId = created['id'] as String;

      final updateContext = TestRequestContext(
        path: '/roles/$roleId',
        method: HttpMethod.put,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'description': 'Updated'}),
      );
      updateContext.provide<RoleRepository>(roles);
      updateContext.provide<UserRepository>(users);
      final updateResponse =
          await role_route.onRequest(updateContext.context, roleId);
      expect(updateResponse.statusCode, 200);
    });

    test('base roles cannot be deleted', () async {
      final user = await users.findByEmail('consultant-admin@som.test');
      final token = buildTestJwt(userId: user!.id);
      final baseRole = await roles.findByName('admin');
      final context = TestRequestContext(
        path: '/roles/${baseRole!.id}',
        method: HttpMethod.delete,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<RoleRepository>(roles);
      context.provide<UserRepository>(users);
      final response = await role_route.onRequest(context.context, baseRole.id);
      expect(response.statusCode, 400);
    });
  });
}
