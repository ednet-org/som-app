import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/registration_service.dart';
import '../routes/Companies/index.dart' as companies_route;
import '../routes/Companies/[companyId]/index.dart' as company_route;
import '../routes/Companies/[companyId]/activate.dart' as activate_route;
import 'test_utils.dart';

void main() {
  group('Company notifications', () {
    test('registration notifies consultants', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final branches = InMemoryBranchRepository();
      final auth = createAuthService(users);
      final notificationsEmail = TestEmailService();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: notificationsEmail,
      );
      final registration = RegistrationService(
        companies: companies,
        users: users,
        providers: providers,
        subscriptions: subscriptions,
        branches: branches,
        companyTaxonomy: InMemoryCompanyTaxonomyRepository(),
        auth: auth,
        clock: const Clock(),
        domain: SomDomainModel(),
      );
      final systemCompany = await seedCompany(companies);
      await seedUser(
        users,
        systemCompany,
        email: 'consultant@som.test',
        roles: const ['consultant'],
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
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );
      final response = await companies_route.onRequest(context.context);
      expect(response.statusCode, 200);
      expect(
        notificationsEmail.sent.any(
          (message) =>
              message.to == 'consultant@som.test' &&
              message.subject == 'New company registered',
        ),
        isTrue,
      );
    });

    test('company update/activation/deactivation notifies consultants/admins',
        () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final notificationsEmail = TestEmailService();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: InMemoryProviderRepository(),
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: notificationsEmail,
      );
      final domainEvents = DomainEventService(
        repository: InMemoryDomainEventRepository(),
        notifications: notifications,
        companies: companies,
        inquiries: InMemoryInquiryRepository(),
      );

      final company = await seedCompany(companies);
      final admin = await seedUser(
        users,
        company,
        email: 'admin@som.test',
        roles: const ['admin'],
      );
      final consultantCompany = await seedCompany(
        companies,
        type: 'consultant',
      );
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant'],
      );
      final token = buildTestJwt(userId: consultant.id);

      final updateContext = TestRequestContext(
        path: '/Companies/${company.id}',
        method: HttpMethod.put,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'name': 'Updated Co'}),
      );
      updateContext.provide<CompanyRepository>(companies);
      updateContext.provide<UserRepository>(users);
      updateContext.provide<NotificationService>(notifications);
      updateContext.provide<DomainEventService>(domainEvents);
      final updateResponse =
          await company_route.onRequest(updateContext.context, company.id);
      expect(updateResponse.statusCode, 200);

      final deactivateContext = TestRequestContext(
        path: '/Companies/${company.id}',
        method: HttpMethod.delete,
        headers: {'authorization': 'Bearer $token'},
      );
      deactivateContext.provide<CompanyRepository>(companies);
      deactivateContext.provide<UserRepository>(users);
      deactivateContext.provide<NotificationService>(notifications);
      deactivateContext.provide<DomainEventService>(domainEvents);
      final deactivateResponse =
          await company_route.onRequest(deactivateContext.context, company.id);
      expect(deactivateResponse.statusCode, 200);

      final activateContext = TestRequestContext(
        path: '/Companies/${company.id}/activate',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      activateContext.provide<CompanyRepository>(companies);
      activateContext.provide<UserRepository>(users);
      activateContext.provide<NotificationService>(notifications);
      activateContext.provide<DomainEventService>(domainEvents);
      final activateResponse =
          await activate_route.onRequest(activateContext.context, company.id);
      expect(activateResponse.statusCode, 200);

      final subjects = notificationsEmail.sent
          .where((message) => message.to == admin.email)
          .map((message) => message.subject)
          .toSet();
      expect(subjects.contains('Company activated'), isTrue);
      expect(subjects.contains('Company deactivated'), isTrue);
      expect(
        notificationsEmail.sent.any(
          (message) =>
              message.to == 'consultant@som.test' &&
              message.subject == 'Company updated',
        ),
        isTrue,
      );
    });
  });
}
