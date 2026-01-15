import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/product_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/providers/[companyId]/products/index.dart' as products_route;
import '../routes/providers/[companyId]/products/[productId]/index.dart'
    as product_route;
import '../routes/providers/[companyId]/paymentDetails.dart' as payment_route;
import 'test_utils.dart';

void main() {
  group('Provider products and payment details', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late InMemoryProviderRepository providers;
    late InMemoryProductRepository products;

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      providers = InMemoryProviderRepository();
      products = InMemoryProductRepository();
      final company = await seedCompany(companies, type: 'provider');
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: company.id,
          bankDetails:
              BankDetails(iban: 'IBAN1', bic: 'BIC1', accountOwner: 'Owner'),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: const Uuid().v4(),
          paymentInterval: 'monthly',
          providerType: 'Händler',
          status: 'active',
          rejectionReason: null,
          rejectedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await seedUser(
        users,
        company,
        email: 'provider-admin@som.test',
        roles: const ['provider', 'admin'],
      );
    });

    test('provider admin can manage products', () async {
      final company = (await companies.listAll()).first;
      final admin = await users.findByEmail('provider-admin@som.test');
      final token = buildTestJwt(userId: admin!.id);

      final createContext = TestRequestContext(
        path: '/providers/${company.id}/products',
        method: HttpMethod.post,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'name': 'Cleaning'}),
      );
      createContext.provide<UserRepository>(users);
      createContext.provide<CompanyRepository>(companies);
      createContext.provide<ProductRepository>(products);
      createContext.provide<ProviderRepository>(providers);
      final createResponse =
          await products_route.onRequest(createContext.context, company.id);
      expect(createResponse.statusCode, 200);
      final created = jsonDecode(await createResponse.body())
          as Map<String, dynamic>;
      final productId = created['id'] as String;

      final updateContext = TestRequestContext(
        path: '/providers/${company.id}/products/$productId',
        method: HttpMethod.put,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'name': 'Cleaning Pro'}),
      );
      updateContext.provide<UserRepository>(users);
      updateContext.provide<CompanyRepository>(companies);
      updateContext.provide<ProductRepository>(products);
      final updateResponse = await product_route.onRequest(
        updateContext.context,
        company.id,
        productId,
      );
      expect(updateResponse.statusCode, 200);

      final listContext = TestRequestContext(
        path: '/providers/${company.id}/products',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      listContext.provide<UserRepository>(users);
      listContext.provide<CompanyRepository>(companies);
      listContext.provide<ProductRepository>(products);
      listContext.provide<ProviderRepository>(providers);
      final listResponse =
          await products_route.onRequest(listContext.context, company.id);
      expect(listResponse.statusCode, 200);
      final list = jsonDecode(await listResponse.body()) as List<dynamic>;
      expect(list.length, 1);
    });

    test('provider admin can update payment details', () async {
      final company = (await companies.listAll()).first;
      final admin = await users.findByEmail('provider-admin@som.test');
      final token = buildTestJwt(userId: admin!.id);
      final context = TestRequestContext(
        path: '/providers/${company.id}/paymentDetails',
        method: HttpMethod.put,
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'iban': 'NEWIBAN',
          'bic': 'NEWBIC',
          'accountOwner': 'New Owner',
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<ProviderRepository>(providers);
      final response =
          await payment_route.onRequest(context.context, company.id);
      expect(response.statusCode, 200);

      final updated = await providers.findByCompany(company.id);
      expect(updated?.bankDetails.iban, 'NEWIBAN');
    });
  });
}
