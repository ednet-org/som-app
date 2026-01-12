import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/cancellation_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/email_service.dart';
import '../routes/Subscriptions/cancel.dart' as cancel_route;
import '../routes/Subscriptions/cancellations.dart' as list_route;
import '../routes/Subscriptions/cancellations/[cancellationId]/index.dart'
    as update_route;
import 'test_utils.dart';

void main() {
  group('Subscription cancellation', () {
    test('provider requests cancellation, consultant resolves', () async {
      final cancellations = InMemoryCancellationRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final providerAdmin = await seedUser(
        users,
        company,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );
      final consultantCompany = await seedCompany(InMemoryCompanyRepository());
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant'],
      );

      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: company.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'yearly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 365)),
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final providerToken = buildTestJwt(userId: providerAdmin.id);
      final consultantToken = buildTestJwt(userId: consultant.id);

      final cancelContext = TestRequestContext(
        path: '/Subscriptions/cancel',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $providerToken',
        },
        body: jsonEncode({'reason': 'End of contract'}),
      );
      cancelContext.provide<CancellationRepository>(cancellations);
      cancelContext.provide<SubscriptionRepository>(subscriptions);
      cancelContext.provide<UserRepository>(users);
      cancelContext.provide<EmailService>(
        EmailService(outboxPath: 'storage/test_outbox'),
      );

      final cancelResponse =
          await cancel_route.onRequest(cancelContext.context);
      expect(cancelResponse.statusCode, 200);
      final cancelBody =
          jsonDecode(await cancelResponse.body()) as Map<String, dynamic>;
      final cancellationId = cancelBody['id'] as String;

      final listContext = TestRequestContext(
        path: '/Subscriptions/cancellations',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      listContext.provide<CancellationRepository>(cancellations);
      listContext.provide<UserRepository>(users);

      final listResponse = await list_route.onRequest(listContext.context);
      expect(listResponse.statusCode, 200);
      final listBody = jsonDecode(await listResponse.body()) as List<dynamic>;
      expect(listBody, isNotEmpty);

      final updateContext = TestRequestContext(
        path: '/Subscriptions/cancellations/$cancellationId',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $consultantToken',
        },
        body: jsonEncode({'status': 'approved'}),
      );
      updateContext.provide<CancellationRepository>(cancellations);
      updateContext.provide<UserRepository>(users);
      updateContext.provide<EmailService>(
        EmailService(outboxPath: 'storage/test_outbox'),
      );

      final updateResponse =
          await update_route.onRequest(updateContext.context, cancellationId);
      expect(updateResponse.statusCode, 200);
    });
  });
}
