import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/services/auth_service.dart';
import '../routes/auth/login.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /auth/login', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late AuthService auth;

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      auth = createAuthService(users);
      final company = await seedCompany(companies);
      await seedUser(users, company, email: 'user@example.com');
      (auth as TestAuthService).setPassword('user@example.com', 'secret');
    });

    test('returns tokens for valid credentials', () async {
      final context = TestRequestContext(
        path: '/auth/login',
        method: HttpMethod.post,
        body: jsonEncode({'email': 'user@example.com', 'password': 'secret'}),
        headers: {'content-type': 'application/json'},
      );
      context.provide<AuthService>(auth);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['token'], isNotEmpty);
      expect(body['refreshToken'], isNotEmpty);
    });

    test('returns 400 for invalid credentials', () async {
      final context = TestRequestContext(
        path: '/auth/login',
        method: HttpMethod.post,
        body: jsonEncode({'email': 'user@example.com', 'password': 'wrong'}),
        headers: {'content-type': 'application/json'},
      );
      context.provide<AuthService>(auth);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 400);
    });

    test('returns 400 for unconfirmed email', () async {
      final company = await seedCompany(companies);
      await seedUser(users, company,
          email: 'pending@example.com', confirmed: false);
      (auth as TestAuthService).setPassword('pending@example.com', 'secret2');
      final context = TestRequestContext(
        path: '/auth/login',
        method: HttpMethod.post,
        body:
            jsonEncode({'email': 'pending@example.com', 'password': 'secret2'}),
        headers: {'content-type': 'application/json'},
      );
      context.provide<AuthService>(auth);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 400);
    });

    test('locks account after repeated failures', () async {
      Future<Response> attempt(String password) {
        final context = TestRequestContext(
          path: '/auth/login',
          method: HttpMethod.post,
          body: jsonEncode({'email': 'user@example.com', 'password': password}),
          headers: {'content-type': 'application/json'},
        );
        context.provide<AuthService>(auth);
        return route.onRequest(context.context);
      }

      for (var i = 0; i < 4; i++) {
        final response = await attempt('wrong');
        expect(response.statusCode, 400);
        final message = jsonDecode(await response.body()) as String;
        expect(message, isNot(contains('Account locked')));
      }

      final lockedResponse = await attempt('wrong');
      expect(lockedResponse.statusCode, 400);
      final lockedMessage = jsonDecode(await lockedResponse.body()) as String;
      expect(lockedMessage, contains('Account locked'));

      final blockedResponse = await attempt('secret');
      expect(blockedResponse.statusCode, 400);
      final blockedMessage = jsonDecode(await blockedResponse.body()) as String;
      expect(blockedMessage, contains('Account locked'));
    });
  });
}
