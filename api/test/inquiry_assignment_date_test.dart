import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/inquiries/[inquiryId]/assign.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /inquiries/{id}/assign', () {
    test('sets inquiry assignedAt when providers are assigned', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final emailService = TestEmailService();

      final consultantCompany = await seedCompany(companies, type: 'consultant');
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant'],
      );
      final providerCompany = await seedCompany(companies, type: 'provider');
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(
            iban: 'AT00TEST',
            bic: 'TESTATXX',
            accountOwner: 'Owner',
          ),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      final now = DateTime.now().toUtc();
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: providerCompany.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: now.subtract(const Duration(days: 1)),
          endDate: now.add(const Duration(days: 30)),
          createdAt: now,
        ),
      );
      final token = buildTestJwt(userId: consultant.id);
      final inquiry = InquiryRecord(
        id: 'inq-assign',
        buyerCompanyId: providerCompany.id,
        createdByUserId: consultant.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const ['tag'],
        deadline: now.add(const Duration(days: 3)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Test',
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: providerCompany.name,
          salutation: consultant.salutation,
          title: consultant.title ?? '',
          firstName: consultant.firstName,
          lastName: consultant.lastName,
          telephone: consultant.telephoneNr ?? '',
          email: consultant.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);

      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/assign',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
        body: jsonEncode({
          'providerCompanyIds': [providerCompany.id],
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: inquiries,
        offers: InMemoryOfferRepository(),
        email: emailService,
      );
      context.provide<EmailService>(emailService);
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: inquiries,
        ),
      );

      final response = await route.onRequest(context.context, inquiry.id);
      expect(response.statusCode, 200);
      final updated = await inquiries.findById(inquiry.id);
      expect(updated?.assignedAt, isNotNull);
    });

    test('rejects assignment for provider without active subscription',
        () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final emailService = TestEmailService();

      final consultantCompany = await seedCompany(companies, type: 'consultant');
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant2@som.test',
        roles: const ['consultant'],
      );
      final providerCompany = await seedCompany(companies, type: 'provider');
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
          bankDetails: BankDetails(
            iban: 'AT00TEST',
            bic: 'TESTATXX',
            accountOwner: 'Owner',
          ),
          branchIds: const [],
          pendingBranchIds: const [],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      final now = DateTime.now().toUtc();
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-2',
          companyId: providerCompany.id,
          planId: 'plan-1',
          status: 'inactive',
          paymentInterval: 'monthly',
          startDate: now.subtract(const Duration(days: 30)),
          endDate: now.subtract(const Duration(days: 1)),
          createdAt: now,
        ),
      );
      final inquiry = InquiryRecord(
        id: 'inq-assign-2',
        buyerCompanyId: providerCompany.id,
        createdByUserId: consultant.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const ['tag'],
        deadline: now.add(const Duration(days: 3)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Test',
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: providerCompany.name,
          salutation: consultant.salutation,
          title: consultant.title ?? '',
          firstName: consultant.firstName,
          lastName: consultant.lastName,
          telephone: consultant.telephoneNr ?? '',
          email: consultant.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);

      final token = buildTestJwt(userId: consultant.id);
      final context = TestRequestContext(
        path: '/inquiries/${inquiry.id}/assign',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
        body: jsonEncode({
          'providerCompanyIds': [providerCompany.id],
        }),
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: inquiries,
        offers: InMemoryOfferRepository(),
        email: emailService,
      );
      context.provide<EmailService>(emailService);
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: inquiries,
        ),
      );

      final response = await route.onRequest(context.context, inquiry.id);
      expect(response.statusCode, 400);
      final updated = await inquiries.findById(inquiry.id);
      expect(updated?.assignedAt, isNull);
    });
  });
}
