import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/inquiries/[inquiryId]/index.dart' as inquiry_route;
import '../routes/inquiries/[inquiryId]/offers/index.dart' as offers_route;
import 'test_utils.dart';

void main() {
  group('Inquiry access control', () {
    test('buyer cannot access another company inquiry', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final otherCompany = await seedCompany(companies, type: 'buyer');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final otherUser = await seedUser(
        users,
        otherCompany,
        email: 'other@acme.test',
        roles: const ['buyer'],
      );

      final inquiry = InquiryRecord(
        id: 'inquiry-1',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: DateTime.now().toUtc().add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: 'Buyer',
          salutation: 'Mr',
          title: '',
          firstName: 'Buyer',
          lastName: 'User',
          telephone: '',
          email: 'buyer@acme.test',
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await inquiries.create(inquiry);

      final token = buildTestJwt(userId: otherUser.id);
      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);

      final response = await inquiry_route.onRequest(
        context.context,
        inquiry.id,
      );
      expect(response.statusCode, 403);
    });

    test('buyer cannot list offers for another company inquiry', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final otherCompany = await seedCompany(companies, type: 'buyer');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final otherUser = await seedUser(
        users,
        otherCompany,
        email: 'other@acme.test',
        roles: const ['buyer'],
      );

      final inquiry = InquiryRecord(
        id: 'inquiry-2',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: DateTime.now().toUtc().add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: 'Buyer',
          salutation: 'Mr',
          title: '',
          firstName: 'Buyer',
          lastName: 'User',
          telephone: '',
          email: 'buyer@acme.test',
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await inquiries.create(inquiry);

      final token = buildTestJwt(userId: otherUser.id);
      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/offers',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);

      final response = await offers_route.onRequest(
        context.context,
        inquiry.id,
      );
      expect(response.statusCode, 403);
    });

    test('provider cannot list offers for unassigned inquiry', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final providerCompany = await seedCompany(companies, type: 'provider');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final providerUser = await seedUser(
        users,
        providerCompany,
        email: 'provider@acme.test',
        roles: const ['provider'],
      );

      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(iban: 'AT1', bic: 'BIC', accountOwner: 'X'),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'active',
          rejectionReason: null,
          rejectedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub',
          companyId: providerCompany.id,
          planId: 'plan',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 365)),
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final inquiry = InquiryRecord(
        id: 'inquiry-3',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: DateTime.now().toUtc().add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: 'Buyer',
          salutation: 'Mr',
          title: '',
          firstName: 'Buyer',
          lastName: 'User',
          telephone: '',
          email: 'buyer@acme.test',
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await inquiries.create(inquiry);

      final token = buildTestJwt(userId: providerUser.id);
      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/offers',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);

      final response = await offers_route.onRequest(
        context.context,
        inquiry.id,
      );
      expect(response.statusCode, 403);
    });

    test('provider can list offers for assigned inquiry', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final providerCompany = await seedCompany(companies, type: 'provider');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final providerUser = await seedUser(
        users,
        providerCompany,
        email: 'provider@acme.test',
        roles: const ['provider'],
      );

      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(iban: 'AT1', bic: 'BIC', accountOwner: 'X'),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'active',
          rejectionReason: null,
          rejectedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub',
          companyId: providerCompany.id,
          planId: 'plan',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 365)),
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final inquiry = InquiryRecord(
        id: 'inquiry-4',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: DateTime.now().toUtc().add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: 'Buyer',
          salutation: 'Mr',
          title: '',
          firstName: 'Buyer',
          lastName: 'User',
          telephone: '',
          email: 'buyer@acme.test',
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await inquiries.create(inquiry);
      await inquiries.assignToProviders(
        inquiryId: inquiry.id,
        assignedByUserId: buyerUser.id,
        providerCompanyIds: [providerCompany.id],
      );

      final token = buildTestJwt(userId: providerUser.id);
      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/offers',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);

      final response = await offers_route.onRequest(
        context.context,
        inquiry.id,
      );
      expect(response.statusCode, 200);
    });
  });
}
