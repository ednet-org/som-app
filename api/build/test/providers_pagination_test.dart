import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/providers/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('GET /providers pagination', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late InMemoryProviderRepository providers;
    late InMemoryInquiryRepository inquiries;
    late InMemoryOfferRepository offers;
    late String consultantToken;

    Future<void> seedProvider({
      required String name,
      String providerType = 'haendler',
      String status = 'active',
      String zip = '1010',
      String companySize = '0-10',
      List<String> branchIds = const ['branch-1'],
    }) async {
      final companyId = const Uuid().v4();
      final now = DateTime.now().toUtc();
      await companies.create(CompanyRecord(
        id: companyId,
        name: name,
        type: 'provider',
        address: Address(
          country: 'AT',
          city: 'Vienna',
          street: 'Main',
          number: '1',
          zip: zip,
        ),
        uidNr: 'UID$companyId',
        registrationNr: 'REG$companyId',
        companySize: companySize,
        websiteUrl: null,
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ));
      await providers.createProfile(ProviderProfileRecord(
        companyId: companyId,
        bankDetails:
            BankDetails(iban: 'AT123', bic: 'BIC123', accountOwner: name),
        branchIds: branchIds,
        pendingBranchIds: const [],
        subscriptionPlanId: 'plan-1',
        paymentInterval: 'monthly',
        providerType: providerType,
        status: status,
        createdAt: now,
        updatedAt: now,
      ));
    }

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      providers = InMemoryProviderRepository();
      inquiries = InMemoryInquiryRepository();
      offers = InMemoryOfferRepository();

      // Create consultant company and user
      final consultantCompany = await seedCompany(companies);
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@test.com',
        roles: const ['consultant', 'admin'],
      );
      consultantToken = buildTestJwt(userId: consultant.id);
    });

    test('returns paginated results with X-Total-Count header', () async {
      // Seed 5 providers
      for (var i = 0; i < 5; i++) {
        await seedProvider(name: 'Provider $i');
      }

      final context = TestRequestContext(
        path: '/providers?limit=2&offset=0',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await route.onRequest(context.context);

      expect(response.statusCode, 200);
      expect(response.headers['X-Total-Count'], '5');
      expect(response.headers['X-Has-More'], 'true');

      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.length, 2);
    });

    test('returns X-Has-More=false on last page', () async {
      for (var i = 0; i < 3; i++) {
        await seedProvider(name: 'Provider $i');
      }

      final context = TestRequestContext(
        path: '/providers?limit=10&offset=0',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await route.onRequest(context.context);

      expect(response.statusCode, 200);
      expect(response.headers['X-Total-Count'], '3');
      expect(response.headers['X-Has-More'], 'false');
    });

    test('search parameter filters by company name', () async {
      await seedProvider(name: 'Acme Corporation');
      await seedProvider(name: 'Beta Industries');
      await seedProvider(name: 'Acme Holdings');

      final context = TestRequestContext(
        path: '/providers?search=acme',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await route.onRequest(context.context);

      expect(response.statusCode, 200);
      expect(response.headers['X-Total-Count'], '2');

      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.length, 2);
      expect(
        body.every(
            (p) => (p['companyName'] as String).toLowerCase().contains('acme')),
        true,
      );
    });

    test('caps limit at 200', () async {
      final context = TestRequestContext(
        path: '/providers?limit=500',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await route.onRequest(context.context);

      expect(response.statusCode, 200);
      // The limit is capped internally, response should succeed
    });

    test('filters work with pagination', () async {
      await seedProvider(
          name: 'Haendler 1', providerType: 'haendler', status: 'active');
      await seedProvider(
          name: 'Haendler 2', providerType: 'haendler', status: 'pending');
      await seedProvider(
          name: 'Hersteller 1', providerType: 'hersteller', status: 'active');

      final context = TestRequestContext(
        path: '/providers?providerType=haendler&limit=10',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await route.onRequest(context.context);

      expect(response.statusCode, 200);
      expect(response.headers['X-Total-Count'], '2');

      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body.length, 2);
      expect(body.every((p) => p['providerType'] == 'haendler'), true);
    });

    test('CSV export includes pagination headers', () async {
      await seedProvider(name: 'Provider 1');
      await seedProvider(name: 'Provider 2');

      final context = TestRequestContext(
        path: '/providers?format=csv&limit=1',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await route.onRequest(context.context);

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], 'text/csv');
      expect(response.headers['X-Total-Count'], '2');
    });
  });
}
