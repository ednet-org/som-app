import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/registration_service.dart';
import '../routes/Companies/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /Companies', () {
    test('creates company and users', () async {
      final db = createTestDb();
      final companies = CompanyRepository(db);
      final users = UserRepository(db);
      final providers = ProviderRepository(db);
      final subscriptions = SubscriptionRepository(db);
      final branches = BranchRepository(db);
      final auth = createAuthService(db);
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
            'websiteUrl': 'https://example.com'
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
      expect(companies.listAll(), isNotEmpty);
      expect(users.listByCompany(companies.listAll().first.id), isNotEmpty);
    });
  });
}
