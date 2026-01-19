import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/company_taxonomy_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/providers/index.dart' as providers_route;
import '../routes/providers/[companyId]/taxonomy.dart' as taxonomy_route;
import 'test_utils.dart';

void main() {
  group('Provider taxonomy', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late InMemoryProviderRepository providers;
    late InMemoryCompanyTaxonomyRepository taxonomy;
    late InMemoryInquiryRepository inquiries;
    late InMemoryOfferRepository offers;
    late String consultantToken;

    Future<CompanyRecord> seedProviderCompany({
      required String name,
      List<String> branchIds = const ['branch-1'],
    }) async {
      final companyId = const Uuid().v4();
      final now = DateTime.now().toUtc();
      final company = CompanyRecord(
        id: companyId,
        name: name,
        type: 'provider',
        address: Address(
          country: 'AT',
          city: 'Vienna',
          street: 'Main',
          number: '1',
          zip: '1010',
        ),
        uidNr: 'UID$companyId',
        registrationNr: 'REG$companyId',
        companySize: '0-10',
        websiteUrl: null,
        status: 'active',
        createdAt: now,
        updatedAt: now,
      );
      await companies.create(company);
      await providers.createProfile(ProviderProfileRecord(
        companyId: companyId,
        bankDetails:
            BankDetails(iban: 'AT123', bic: 'BIC123', accountOwner: name),
        branchIds: branchIds,
        pendingBranchIds: const [],
        subscriptionPlanId: 'plan-1',
        paymentInterval: 'monthly',
        providerType: 'haendler',
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ));
      return company;
    }

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      providers = InMemoryProviderRepository();
      taxonomy = InMemoryCompanyTaxonomyRepository();
      inquiries = InMemoryInquiryRepository();
      offers = InMemoryOfferRepository();

      final consultantCompany = await seedCompany(companies);
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@test.com',
        roles: const ['consultant', 'admin'],
      );
      consultantToken = buildTestJwt(userId: consultant.id);
    });

    test('GET /providers includes taxonomy assignments', () async {
      final company = await seedProviderCompany(name: 'Provider A');
      await taxonomy.replaceCompanyBranches(
        companyId: company.id,
        branchIds: const ['branch-1'],
        source: 'openai',
        confidence: 0.72,
        status: 'pending',
      );
      await taxonomy.replaceCompanyCategories(
        companyId: company.id,
        categoryIds: const ['cat-1'],
        source: 'openai',
        confidence: 0.66,
        status: 'pending',
      );

      final context = TestRequestContext(
        path: '/providers?limit=10&offset=0',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $consultantToken'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      context.provide<CompanyTaxonomyRepository>(taxonomy);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);

      final response = await providers_route.onRequest(context.context);

      expect(response.statusCode, 200);
      final body = jsonDecode(await response.body()) as List<dynamic>;
      expect(body, isNotEmpty);
      final first = body.first as Map<String, dynamic>;
      final branchAssignments = first['branchAssignments'] as List<dynamic>?;
      final categoryAssignments =
          first['categoryAssignments'] as List<dynamic>?;
      expect(branchAssignments, isNotNull);
      expect(categoryAssignments, isNotNull);
      expect(branchAssignments!.first['source'], 'openai');
      expect(categoryAssignments!.first['source'], 'openai');
      expect(branchAssignments.first['confidence'], 0.72);
      expect(categoryAssignments.first['confidence'], 0.66);
    });

    test('PUT /providers/{companyId}/taxonomy replaces assignments as manual',
        () async {
      final company = await seedProviderCompany(name: 'Provider B');

      final context = TestRequestContext(
        path: '/providers/${company.id}/taxonomy',
        method: HttpMethod.put,
        headers: {'authorization': 'Bearer $consultantToken'},
        body: jsonEncode({
          'branchIds': ['branch-2'],
          'categoryIds': ['cat-2', 'cat-3'],
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyTaxonomyRepository>(taxonomy);

      final response =
          await taxonomy_route.onRequest(context.context, company.id);

      expect(response.statusCode, 200);
      final payload = jsonDecode(await response.body()) as Map<String, dynamic>;
      final branches = payload['branches'] as List<dynamic>;
      final categories = payload['categories'] as List<dynamic>;
      expect(branches.length, 1);
      expect(categories.length, 2);
      expect(branches.first['source'], 'manual');
      expect(branches.first['status'], 'active');
      expect(branches.first['confidence'], isNull);
    });
  });
}
