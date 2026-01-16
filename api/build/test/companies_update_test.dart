import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/Companies/[companyId]/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('PUT /Companies/{companyId}', () {
    test('rejects invalid company type', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      final admin = await seedUser(users, company,
          email: 'admin@example.com', roles: const ['buyer', 'admin']);
      final token = buildTestJwt(userId: admin.id);

      final context = TestRequestContext(
        path: '/Companies/${company.id}',
        method: HttpMethod.put,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': 'Acme Updated',
          'type': 99,
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: InMemoryProviderRepository(),
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: TestEmailService(),
      );
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );

      final response = await route.onRequest(context.context, company.id);
      expect(response.statusCode, 400);
    });
  });
}
