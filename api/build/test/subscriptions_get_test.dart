import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/services/subscription_seed.dart';
import 'package:som_api/infrastructure/clock.dart';
import '../routes/Subscriptions/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /Subscriptions', () {
    test('returns seeded subscriptions', () async {
      final db = createTestDb();
      final repo = SubscriptionRepository(db);
      SubscriptionSeeder(repository: repo, clock: const Clock()).seedDefaults();

      final context = TestRequestContext(
        path: '/Subscriptions',
        method: HttpMethod.get,
      );
      context.provide<SubscriptionRepository>(repo);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['subscriptions'], isList);
      expect((body['subscriptions'] as List).length, greaterThan(0));
    });
  });
}
