import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import '../routes/inquiries/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('Inquiry CSV export', () {
    test('buyer export includes offers and list view fields', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final branches = InMemoryBranchRepository();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final providerCompany = await seedCompany(companies, type: 'provider');
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(iban: 'IBAN', bic: 'BIC', accountOwner: 'Owner'),
          branchIds: const ['branch-1'],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'dealer',
          status: 'active',
          rejectionReason: null,
          rejectedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-1',
          name: 'Plan',
          sortPriority: 1,
          isActive: true,
          priceInSubunit: 0,
          rules: const [],
          maxUsers: null,
          setupFeeInSubunit: null,
          bannerAdsPerMonth: null,
          normalAdsPerMonth: null,
          freeMonths: null,
          commitmentPeriodMonths: null,
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: providerCompany.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 30)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await branches.createBranch(
        BranchRecord(id: 'branch-1', name: 'Machinery', status: 'active'),
      );
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: now.add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: buyerCompany.name,
          salutation: buyerUser.salutation,
          title: buyerUser.title ?? '',
          firstName: buyerUser.firstName,
          lastName: buyerUser.lastName,
          telephone: buyerUser.telephoneNr ?? '',
          email: buyerUser.email,
        ),
        notifiedAt: null,
        assignedAt: now,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);
      await offers.create(
        OfferRecord(
          id: 'offer-1',
          inquiryId: inquiry.id,
          providerCompanyId: providerCompany.id,
          providerUserId: null,
          status: 'offer_created',
          pdfPath: null,
          forwardedAt: now,
          resolvedAt: null,
          buyerDecision: 'open',
          providerDecision: 'offer_created',
          createdAt: now,
        ),
      );

      final token = buildTestJwt(userId: buyerUser.id);
      final context = TestRequestContext(
        path: '/inquiries?format=csv',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<BranchRepository>(branches);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = await response.body();
      final header = LineSplitter.split(body).first;
      expect(
        header,
        'id,status,creatorEmail,branch,deadline,createdAt,offers',
      );
      expect(body, contains('buyer@acme.test'));
      expect(body, contains('Machinery'));
      expect(body, contains('offer-1'));
      expect(body, contains(providerCompany.name));
    });

    test('consultant export includes assignment and decision dates', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final branches = InMemoryBranchRepository();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final providerCompany = await seedCompany(companies, type: 'provider');
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(iban: 'IBAN', bic: 'BIC', accountOwner: 'Owner'),
          branchIds: const ['branch-1'],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'dealer',
          status: 'active',
          rejectionReason: null,
          rejectedAt: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createPlan(
        SubscriptionPlanRecord(
          id: 'plan-1',
          name: 'Plan',
          sortPriority: 1,
          isActive: true,
          priceInSubunit: 0,
          rules: const [],
          maxUsers: null,
          setupFeeInSubunit: null,
          bannerAdsPerMonth: null,
          normalAdsPerMonth: null,
          freeMonths: null,
          commitmentPeriodMonths: null,
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: providerCompany.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 30)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await branches.createBranch(
        BranchRecord(id: 'branch-1', name: 'Machinery', status: 'active'),
      );
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final consultant = await seedUser(
        users,
        await seedCompany(companies, type: 'buyer'),
        email: 'consultant@som.test',
        roles: const ['consultant', 'admin'],
      );
      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-2',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'closed',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const [],
        deadline: now.add(const Duration(days: 5)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: null,
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: buyerCompany.name,
          salutation: buyerUser.salutation,
          title: buyerUser.title ?? '',
          firstName: buyerUser.firstName,
          lastName: buyerUser.lastName,
          telephone: buyerUser.telephoneNr ?? '',
          email: buyerUser.email,
        ),
        notifiedAt: null,
        assignedAt: now,
        closedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);
      await offers.create(
        OfferRecord(
          id: 'offer-2',
          inquiryId: inquiry.id,
          providerCompanyId: providerCompany.id,
          providerUserId: null,
          status: 'won',
          pdfPath: null,
          forwardedAt: now,
          resolvedAt: now,
          buyerDecision: 'accepted',
          providerDecision: 'won',
          createdAt: now,
        ),
      );

      final token = buildTestJwt(userId: consultant.id);
      final context = TestRequestContext(
        path: '/inquiries?format=csv',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<BranchRepository>(branches);
      context.provide<AuditService>(
        AuditService(repository: InMemoryAuditLogRepository()),
      );

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
      final body = await response.body();
      final header = LineSplitter.split(body).first;
      expect(
        header,
        'id,status,creatorEmail,branch,deadline,createdAt,offerCreatedAt,decisionAt,assignmentAt,offers',
      );
      expect(body, contains('offer-2'));
      expect(body, contains('accepted'));
      expect(body, contains('won'));
    });
  });
}
