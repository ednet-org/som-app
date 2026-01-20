import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/billing_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/company_taxonomy_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/email_service.dart';
import '../routes/consultants/index.dart' as consultants_route;
import '../routes/providers/index.dart' as providers_route;
import '../routes/billing/index.dart' as billing_route;
import 'test_utils.dart';

void main() {
  group('Consultant admin guards', () {
    test('POST /consultants requires consultant admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final systemCompany = CompanyRecord(
        id: 'system-company',
        name: 'System',
        type: 'buyer',
        address: Address(
          country: 'AT',
          city: 'Vienna',
          street: 'Main',
          number: '1',
          zip: '1010',
        ),
        uidNr: 'UIDSYS',
        registrationNr: 'SYSTEM',
        companySize: '0-10',
        websiteUrl: 'https://example.com',
        status: 'active',
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await companies.create(systemCompany);
      final consultant = await seedUser(
        users,
        systemCompany,
        email: 'consultant@acme.test',
        roles: const ['consultant'],
      );
      final token = buildTestJwt(userId: consultant.id);

      final context = TestRequestContext(
        path: '/consultants',
        method: HttpMethod.post,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'email': 'new@acme.test',
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<Clock>(Clock());
      context.provide<EmailService>(TestEmailService());

      final response = await consultants_route.onRequest(context.context);
      expect(response.statusCode, 403);
    });

    test('GET /providers requires consultant admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final systemCompany = await seedCompany(companies, type: 'buyer');
      final consultant = await seedUser(
        users,
        systemCompany,
        email: 'consultant@acme.test',
        roles: const ['consultant'],
      );
      final token = buildTestJwt(userId: consultant.id);

      final context = TestRequestContext(
        path: '/providers',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<CompanyTaxonomyRepository>(
        InMemoryCompanyTaxonomyRepository(),
      );
      context.provide<ProviderRepository>(InMemoryProviderRepository());
      context.provide<InquiryRepository>(InMemoryInquiryRepository());
      context.provide<OfferRepository>(InMemoryOfferRepository());
      context.provide<SubscriptionRepository>(InMemorySubscriptionRepository());
      context.provide<UserRepository>(users);
      context.provide<Clock>(Clock());
      context.provide<EmailService>(TestEmailService());

      final response = await providers_route.onRequest(context.context);
      expect(response.statusCode, 403);
    });

    test('POST /billing requires consultant admin', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final billing = InMemoryBillingRepository();
      final systemCompany = await seedCompany(companies, type: 'buyer');
      final consultant = await seedUser(
        users,
        systemCompany,
        email: 'consultant@acme.test',
        roles: const ['consultant'],
      );
      final token = buildTestJwt(userId: consultant.id);

      final context = TestRequestContext(
        path: '/billing',
        method: HttpMethod.post,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'companyId': systemCompany.id,
          'amountInSubunit': 1000,
          'currency': 'EUR',
          'periodStart': DateTime.now().toUtc().toIso8601String(),
          'periodEnd': DateTime.now().toUtc().add(const Duration(days: 30)).toIso8601String(),
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<BillingRepository>(billing);
      context.provide<EmailService>(TestEmailService());

      final response = await billing_route.onRequest(context.context);
      expect(response.statusCode, 403);
    });
  });
}
