import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/db.dart';
import 'package:som_api/services/auth_service.dart';
import '../routes/auth/login.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /auth/login', () {
    late Database db;
    late AuthService auth;

    setUp(() {
      db = createTestDb();
      auth = createAuthService(db);
      final company = seedCompany(db);
      final passwordHash = auth.hashPassword('secret');
      seedUser(db, company, email: 'user@example.com', passwordHash: passwordHash);
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
      final company = seedCompany(db);
      final passwordHash = auth.hashPassword('secret2');
      seedUser(db, company,
          email: 'pending@example.com', passwordHash: passwordHash, confirmed: false);
      final context = TestRequestContext(
        path: '/auth/login',
        method: HttpMethod.post,
        body: jsonEncode({'email': 'pending@example.com', 'password': 'secret2'}),
        headers: {'content-type': 'application/json'},
      );
      context.provide<AuthService>(auth);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 400);
    });
  });
}
