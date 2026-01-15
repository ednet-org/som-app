import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/auth_service.dart';
import '../routes/auth/changePassword.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /auth/changePassword', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late AuthService auth;

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      auth = createAuthService(users);
      final company = await seedCompany(companies);
      final user = await seedUser(users, company, email: 'user@example.com');
      (auth as TestAuthService).setPassword(user.email, 'secret');
    });

    test('requires authentication', () async {
      final context = TestRequestContext(
        path: '/auth/changePassword',
        method: HttpMethod.post,
        body: jsonEncode({
          'currentPassword': 'secret',
          'newPassword': 'new-secret',
          'confirmPassword': 'new-secret',
        }),
        headers: {'content-type': 'application/json'},
      );
      context.provide<AuthService>(auth);
      context.provide<UserRepository>(users);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 401);
    });

    test('rejects invalid current password', () async {
      final user = await users.findByEmail('user@example.com');
      final token = buildTestJwt(userId: user!.id);
      final context = TestRequestContext(
        path: '/auth/changePassword',
        method: HttpMethod.post,
        body: jsonEncode({
          'currentPassword': 'wrong',
          'newPassword': 'new-secret',
          'confirmPassword': 'new-secret',
        }),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );
      context.provide<AuthService>(auth);
      context.provide<UserRepository>(users);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 400);
    });

    test('changes password for authenticated user', () async {
      final user = await users.findByEmail('user@example.com');
      final token = buildTestJwt(userId: user!.id);
      final context = TestRequestContext(
        path: '/auth/changePassword',
        method: HttpMethod.post,
        body: jsonEncode({
          'currentPassword': 'secret',
          'newPassword': 'new-secret',
          'confirmPassword': 'new-secret',
        }),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );
      context.provide<AuthService>(auth);
      context.provide<UserRepository>(users);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);

      final tokens =
          await auth.login(emailAddress: user.email, password: 'new-secret');
      expect(tokens.accessToken, isNotEmpty);
    });
  });
}
