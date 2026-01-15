import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/auth_service.dart';
import '../routes/auth/logout.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /auth/logout', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late AuthService auth;

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      auth = createAuthService(users);
      final company = await seedCompany(companies);
      await seedUser(users, company, email: 'user@example.com');
    });

    test('requires authentication', () async {
      final context = TestRequestContext(
        path: '/auth/logout',
        method: HttpMethod.post,
      );
      context.provide<AuthService>(auth);
      context.provide<UserRepository>(users);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 401);
    });

    test('logs out with valid token', () async {
      final user = await users.findByEmail('user@example.com');
      final token = buildTestJwt(userId: user!.id);
      final context = TestRequestContext(
        path: '/auth/logout',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<AuthService>(auth);
      context.provide<UserRepository>(users);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], 'logged_out');
    });
  });
}
