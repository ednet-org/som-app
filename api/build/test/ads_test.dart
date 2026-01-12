import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/file_storage.dart';
import '../routes/ads/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /ads', () {
    test('creates ad for provider', () async {
      final db = createTestDb();
      final company = seedCompany(db, type: 'provider');
      final authService = createAuthService(db);
      final passwordHash = authService.hashPassword('secret');
      final user = seedUser(db, company, email: 'provider@acme.test', passwordHash: passwordHash);
      final token = authService.issueAccessToken(user, role: 'provider');

      final context = TestRequestContext(
        path: '/ads',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'normal',
          'status': 'draft',
          'branchId': 'branch-1',
          'url': 'https://example.com',
          'imagePath': '/tmp/image.png',
          'headline': 'Test',
          'description': 'Desc'
        }),
      );
      context.provide<AdsRepository>(AdsRepository(db));
      context.provide<FileStorage>(FileStorage(basePath: 'storage/test_uploads'));
      context.provide<ProviderRepository>(ProviderRepository(db));
      context.provide<SubscriptionRepository>(SubscriptionRepository(db));
      context.provide<SomDomainModel>(SomDomainModel());
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
    });
  });
}
