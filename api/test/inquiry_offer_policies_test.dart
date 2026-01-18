import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/inquiries/[inquiryId]/assign.dart' as assign_route;
import '../routes/inquiries/[inquiryId]/offers/index.dart' as offers_route;
import 'test_utils.dart';

void main() {
  group('Inquiry/offer lifecycle policies', () {
    test('assignment cap blocks excess providers', () async {
      final inquiries = InMemoryInquiryRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final companyA = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final companyB = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      await providers.createProfile(
        _providerProfile(companyA.id, status: 'active'),
      );
      await providers.createProfile(
        _providerProfile(companyB.id, status: 'active'),
      );
      final now = DateTime.now().toUtc();
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-a',
          companyId: companyA.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: now.subtract(const Duration(days: 1)),
          endDate: now.add(const Duration(days: 30)),
          createdAt: now,
        ),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-b',
          companyId: companyB.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: now.subtract(const Duration(days: 1)),
          endDate: now.add(const Duration(days: 30)),
          createdAt: now,
        ),
      );
      await inquiries.create(
        _inquiry(
          id: 'inq-1',
          numberOfProviders: 1,
          deadline: now.add(const Duration(days: 5)),
        ),
      );
      final consultantCompany = await seedCompany(InMemoryCompanyRepository());
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant'],
      );
      final token = buildTestJwt(userId: consultant.id);

      final context = TestRequestContext(
        path: '/inquiries/inq-1/assign',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'providerCompanyIds': [companyA.id, companyB.id],
        }),
      );
      context.provide<InquiryRepository>(inquiries);
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<UserRepository>(users);
      final email = TestEmailService();
      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: InMemoryCompanyRepository(),
        providers: providers,
        inquiries: inquiries,
        offers: InMemoryOfferRepository(),
        email: email,
      );
      context.provide<EmailService>(email);
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: InMemoryCompanyRepository(),
          inquiries: inquiries,
        ),
      );

      final response = await assign_route.onRequest(context.context, 'inq-1');
      expect(response.statusCode, 400);
    });

    test('offer upload blocked after deadline', () async {
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final user = await seedUser(
        users,
        company,
        email: 'provider@som.test',
        roles: const ['provider'],
      );
      await providers.createProfile(
        _providerProfile(company.id, status: 'active'),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: company.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 30)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await inquiries.create(
        _inquiry(
          id: 'inq-2',
          numberOfProviders: 1,
          deadline: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        ),
      );
      await inquiries.assignToProviders(
        inquiryId: 'inq-2',
        assignedByUserId: 'consultant',
        providerCompanyIds: [company.id],
      );
      final email = TestEmailService();
      final notification = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: InMemoryCompanyRepository(),
        providers: providers,
        inquiries: inquiries,
        offers: offers,
        email: email,
      );
      final token = buildTestJwt(userId: user.id);
      final context = _offerContext(token: token, inquiryId: 'inq-2');
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<EmailService>(email);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<NotificationService>(notification);
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await offers_route.onRequest(context.context, 'inq-2');
      expect(response.statusCode, 400);
    });

    test('offer upload requires assignment', () async {
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final user = await seedUser(
        users,
        company,
        email: 'provider@som.test',
        roles: const ['provider'],
      );
      await providers.createProfile(
        _providerProfile(company.id, status: 'active'),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: company.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 30)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await inquiries.create(
        _inquiry(
          id: 'inq-3',
          numberOfProviders: 1,
          deadline: DateTime.now().toUtc().add(const Duration(days: 2)),
        ),
      );
      final email = TestEmailService();
      final notification = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: InMemoryCompanyRepository(),
        providers: providers,
        inquiries: inquiries,
        offers: offers,
        email: email,
      );
      final token = buildTestJwt(userId: user.id);
      final context = _offerContext(token: token, inquiryId: 'inq-3');
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<EmailService>(email);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<NotificationService>(notification);
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await offers_route.onRequest(context.context, 'inq-3');
      expect(response.statusCode, 403);
    });

    test('offer upload notifies buyer when target reached', () async {
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final user = await seedUser(
        users,
        company,
        email: 'provider@som.test',
        roles: const ['provider'],
      );
      await providers.createProfile(
        _providerProfile(company.id, status: 'active'),
      );
      await subscriptions.createSubscription(
        SubscriptionRecord(
          id: 'sub-1',
          companyId: company.id,
          planId: 'plan-1',
          status: 'active',
          paymentInterval: 'monthly',
          startDate: DateTime.now().toUtc(),
          endDate: DateTime.now().toUtc().add(const Duration(days: 30)),
          createdAt: DateTime.now().toUtc(),
        ),
      );
      await inquiries.create(
        _inquiry(
          id: 'inq-4',
          numberOfProviders: 1,
          deadline: DateTime.now().toUtc().add(const Duration(days: 2)),
        ),
      );
      await inquiries.assignToProviders(
        inquiryId: 'inq-4',
        assignedByUserId: 'consultant',
        providerCompanyIds: [company.id],
      );
      final email = TestEmailService();
      final notification = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: InMemoryCompanyRepository(),
        providers: providers,
        inquiries: inquiries,
        offers: offers,
        email: email,
      );
      final token = buildTestJwt(userId: user.id);
      final context = _offerContext(token: token, inquiryId: 'inq-4');
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<EmailService>(email);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<NotificationService>(notification);
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await offers_route.onRequest(context.context, 'inq-4');
      expect(response.statusCode, 200);
      final updated = await inquiries.findById('inq-4');
      expect(updated?.notifiedAt, isNotNull);
      expect(email.sent.length, 1);
    });
  });
}

ProviderProfileRecord _providerProfile(
  String companyId, {
  required String status,
}) {
  return ProviderProfileRecord(
    companyId: companyId,
    bankDetails: BankDetails(
      iban: 'iban',
      bic: 'bic',
      accountOwner: 'owner',
    ),
    branchIds: const [],
    pendingBranchIds: const [],
    subscriptionPlanId: 'plan-1',
    paymentInterval: 'monthly',
    providerType: 'haendler',
    status: status,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
}

InquiryRecord _inquiry({
  required String id,
  required int numberOfProviders,
  required DateTime deadline,
}) {
  return InquiryRecord(
    id: id,
    buyerCompanyId: 'buyer-1',
    createdByUserId: 'user-1',
    status: 'open',
    branchId: 'branch-1',
    categoryId: 'cat-1',
    productTags: const [],
    deadline: deadline,
    deliveryZips: const ['1010'],
    numberOfProviders: numberOfProviders,
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
      email: 'buyer@test',
    ),
    notifiedAt: null,
    assignedAt: null,
    closedAt: null,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
}

TestRequestContext _offerContext({
  required String token,
  required String inquiryId,
}) {
  const boundary = '----dartfrog';
  final body = [
    '--$boundary',
    'Content-Disposition: form-data; name="file"; filename="offer.pdf"',
    'Content-Type: application/pdf',
    '',
    'PDFDATA',
    '--$boundary--',
    '',
  ].join('\r\n');
  return TestRequestContext(
    path: '/inquiries/$inquiryId/offers',
    method: HttpMethod.post,
    headers: {
      'content-type': 'multipart/form-data; boundary=$boundary',
      'authorization': 'Bearer $token',
    },
    body: body,
  );
}
