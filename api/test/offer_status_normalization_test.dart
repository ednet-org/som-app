import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/offers/[offerId]/accept.dart' as accept_route;
import '../routes/offers/[offerId]/reject.dart' as reject_route;
import 'test_utils.dart';

void main() {
  group('Offer status normalization', () {
    test('accept sets status to won', () async {
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final providers = InMemoryProviderRepository();
      final email = TestEmailService();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final buyerAdmin = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@som.test',
        roles: const ['buyer', 'admin'],
      );
      final providerCompany = await seedCompany(companies, type: 'provider');
      await seedUser(
        users,
        providerCompany,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerAdmin.id,
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
          companyName: buyerCompany.name,
          salutation: buyerAdmin.salutation,
          title: buyerAdmin.title ?? '',
          firstName: buyerAdmin.firstName,
          lastName: buyerAdmin.lastName,
          telephone: buyerAdmin.telephoneNr ?? '',
          email: buyerAdmin.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
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
          forwardedAt: null,
          resolvedAt: null,
          buyerDecision: null,
          providerDecision: null,
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: inquiries,
        offers: offers,
        email: email,
      );
      final domainEvents = DomainEventService(
        repository: InMemoryDomainEventRepository(),
        notifications: notifications,
        companies: companies,
        inquiries: inquiries,
      );

      final token = buildTestJwt(userId: buyerAdmin.id);
      final context = TestRequestContext(
        path: '/offers/offer-1/accept',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<EmailService>(email);
      context.provide<DomainEventService>(domainEvents);
      context.provide<NotificationService>(notifications);

      final response = await accept_route.onRequest(context.context, 'offer-1');
      expect(response.statusCode, 200);
      final updated = await offers.findById('offer-1');
      expect(updated?.status, 'won');
      expect(updated?.buyerDecision, 'accepted');
      expect(updated?.providerDecision, 'won');
    });

    test('reject sets status to lost', () async {
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final providers = InMemoryProviderRepository();
      final email = TestEmailService();

      final buyerCompany = await seedCompany(companies, type: 'buyer');
      final buyerAdmin = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@som.test',
        roles: const ['buyer', 'admin'],
      );
      final providerCompany = await seedCompany(companies, type: 'provider');
      await seedUser(
        users,
        providerCompany,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );
      final inquiry = InquiryRecord(
        id: 'inq-2',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerAdmin.id,
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
          companyName: buyerCompany.name,
          salutation: buyerAdmin.salutation,
          title: buyerAdmin.title ?? '',
          firstName: buyerAdmin.firstName,
          lastName: buyerAdmin.lastName,
          telephone: buyerAdmin.telephoneNr ?? '',
          email: buyerAdmin.email,
        ),
        notifiedAt: null,
        assignedAt: null,
        closedAt: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await inquiries.create(inquiry);
      await offers.create(
        OfferRecord(
          id: 'offer-2',
          inquiryId: inquiry.id,
          providerCompanyId: providerCompany.id,
          providerUserId: null,
          status: 'offer_created',
          pdfPath: null,
          forwardedAt: null,
          resolvedAt: null,
          buyerDecision: null,
          providerDecision: null,
          createdAt: DateTime.now().toUtc(),
        ),
      );

      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: providers,
        inquiries: inquiries,
        offers: offers,
        email: email,
      );
      final domainEvents = DomainEventService(
        repository: InMemoryDomainEventRepository(),
        notifications: notifications,
        companies: companies,
        inquiries: inquiries,
      );

      final token = buildTestJwt(userId: buyerAdmin.id);
      final context = TestRequestContext(
        path: '/offers/offer-2/reject',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<EmailService>(email);
      context.provide<DomainEventService>(domainEvents);
      context.provide<NotificationService>(notifications);

      final response = await reject_route.onRequest(context.context, 'offer-2');
      expect(response.statusCode, 200);
      final updated = await offers.findById('offer-2');
      expect(updated?.status, 'lost');
      expect(updated?.buyerDecision, 'rejected');
      expect(updated?.providerDecision, 'lost');
    });
  });
}
