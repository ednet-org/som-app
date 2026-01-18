import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/role_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/roles/index.dart' as roles_route;
import '../routes/roles/[roleId]/index.dart' as role_route;
import 'test_utils.dart';

void main() {
  group('Roles API', () {
    test('consultant admin can CRUD roles', () async {
      final roles = InMemoryRoleRepository();
      final users = InMemoryUserRepository();
      final consultantCompany = await seedCompany(InMemoryCompanyRepository());
      final consultantAdmin = await seedUser(
        users,
        consultantCompany,
        email: 'consultant.admin@som.test',
        roles: const ['consultant', 'admin'],
      );
      final token = buildTestJwt(userId: consultantAdmin.id);

      final createContext = TestRequestContext(
        path: '/roles',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': 'editor',
          'description': 'Can edit content',
        }),
      );
      createContext.provide<RoleRepository>(roles);
      createContext.provide<UserRepository>(users);

      final createResponse = await roles_route.onRequest(createContext.context);
      expect(createResponse.statusCode, 200);
      final createdBody =
          jsonDecode(await createResponse.body()) as Map<String, dynamic>;
      final roleId = createdBody['id'] as String;

      final updateContext = TestRequestContext(
        path: '/roles/$roleId',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': 'editor-updated',
          'description': 'Updated description',
        }),
      );
      updateContext.provide<RoleRepository>(roles);
      updateContext.provide<UserRepository>(users);

      final updateResponse =
          await role_route.onRequest(updateContext.context, roleId);
      expect(updateResponse.statusCode, 200);

      final deleteContext = TestRequestContext(
        path: '/roles/$roleId',
        method: HttpMethod.delete,
        headers: {'authorization': 'Bearer $token'},
      );
      deleteContext.provide<RoleRepository>(roles);
      deleteContext.provide<UserRepository>(users);

      final deleteResponse =
          await role_route.onRequest(deleteContext.context, roleId);
      expect(deleteResponse.statusCode, 200);
    });

    test('base roles cannot be renamed or deleted', () async {
      final roles = InMemoryRoleRepository();
      final users = InMemoryUserRepository();
      final consultantCompany = await seedCompany(InMemoryCompanyRepository());
      final consultantAdmin = await seedUser(
        users,
        consultantCompany,
        email: 'consultant.admin2@som.test',
        roles: const ['consultant', 'admin'],
      );
      await roles.create(
        RoleRecord(
          id: 'role-base',
          name: 'buyer',
          description: 'Base role',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      final token = buildTestJwt(userId: consultantAdmin.id);

      final updateContext = TestRequestContext(
        path: '/roles/role-base',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': 'buyer-renamed'}),
      );
      updateContext.provide<RoleRepository>(roles);
      updateContext.provide<UserRepository>(users);

      final updateResponse =
          await role_route.onRequest(updateContext.context, 'role-base');
      expect(updateResponse.statusCode, 400);

      final deleteContext = TestRequestContext(
        path: '/roles/role-base',
        method: HttpMethod.delete,
        headers: {'authorization': 'Bearer $token'},
      );
      deleteContext.provide<RoleRepository>(roles);
      deleteContext.provide<UserRepository>(users);

      final deleteResponse =
          await role_route.onRequest(deleteContext.context, 'role-base');
      expect(deleteResponse.statusCode, 400);
    });

    test('non consultant admin is forbidden', () async {
      final roles = InMemoryRoleRepository();
      final users = InMemoryUserRepository();
      final buyerCompany = await seedCompany(InMemoryCompanyRepository());
      final buyerAdmin = await seedUser(
        users,
        buyerCompany,
        email: 'buyer.admin@som.test',
        roles: const ['buyer', 'admin'],
      );
      final token = buildTestJwt(userId: buyerAdmin.id);

      final context = TestRequestContext(
        path: '/roles',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<RoleRepository>(roles);
      context.provide<UserRepository>(users);

      final response = await roles_route.onRequest(context.context);
      expect(response.statusCode, 403);
    });
  });
}
