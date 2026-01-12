import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/registration_service.dart';
import '../routes/Companies/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /Companies', () {
    test('creates company and users', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final branches = InMemoryBranchRepository();
      final auth = createAuthService(users);
      final registration = RegistrationService(
        companies: companies,
        users: users,
        providers: providers,
        subscriptions: subscriptions,
        branches: branches,
        auth: auth,
        clock: const Clock(),
        domain: SomDomainModel(),
      );

      final context = TestRequestContext(
        path: '/Companies',
        method: HttpMethod.post,
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'company': {
            'name': 'Acme',
            'address': {
              'country': 'AT',
              'city': 'Vienna',
              'street': 'Main',
              'number': '1',
              'zip': '1010'
            },
            'uidNr': 'UID1',
            'registrationNr': 'REG1',
            'companySize': 0,
            'type': 0,
            'websiteUrl': 'https://example.com',
            'termsAccepted': true,
            'privacyAccepted': true
          },
          'users': [
            {
              'email': 'admin@acme.test',
              'firstName': 'Admin',
              'lastName': 'User',
              'salutation': 'Mr',
              'roles': [4]
            }
          ]
        }),
      );
      context.provide<RegistrationService>(registration);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final companyList = await companies.listAll();
      expect(companyList, isNotEmpty);
      expect(
        await users.listByCompany(companyList.first.id),
        isNotEmpty,
      );
    });

    test('rejects registration without terms acceptance', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final branches = InMemoryBranchRepository();
      final auth = createAuthService(users);
      final registration = RegistrationService(
        companies: companies,
        users: users,
        providers: providers,
        subscriptions: subscriptions,
        branches: branches,
        auth: auth,
        clock: const Clock(),
        domain: SomDomainModel(),
      );

      final context = TestRequestContext(
        path: '/Companies',
        method: HttpMethod.post,
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'company': {
            'name': 'Acme',
            'address': {
              'country': 'AT',
              'city': 'Vienna',
              'street': 'Main',
              'number': '1',
              'zip': '1010'
            },
            'uidNr': 'UID1',
            'registrationNr': 'REG1',
            'companySize': 0,
            'type': 0
          },
          'users': [
            {
              'email': 'admin@acme.test',
              'firstName': 'Admin',
              'lastName': 'User',
              'salutation': 'Mr',
              'roles': [4]
            }
          ]
        }),
      );
      context.provide<RegistrationService>(registration);
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 400);
    });
  });
}
