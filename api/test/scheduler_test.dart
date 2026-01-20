import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/services/scheduler.dart';
import 'package:som_api/services/notification_service.dart';
import 'test_utils.dart';

class FailingNotificationService extends NotificationService {
  FailingNotificationService({
    required super.ads,
    required super.users,
    required super.companies,
    required super.providers,
    required super.inquiries,
    required super.offers,
    required super.email,
  });

  bool offersCalled = false;
  bool deadlinesCalled = false;
  bool adsCalled = false;

  @override
  Future<void> notifyBuyersForOfferCountOrDeadline() async {
    offersCalled = true;
  }

  @override
  Future<void> notifyProvidersOfUpcomingDeadlines({
    Duration window = const Duration(days: 2),
    DateTime? now,
  }) async {
    deadlinesCalled = true;
    throw StateError('deadline failure');
  }

  @override
  Future<void> notifyProvidersForExpiredAds({DateTime? now}) async {
    adsCalled = true;
  }
}

void main() {
  group('Scheduler', () {
    test('runs deadline reminders once', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final email = TestEmailService();
      final tokens = InMemoryTokenRepository();
      final emailEvents = InMemoryEmailEventRepository();

      final buyerCompany = await seedCompany(companies);
      final providerCompany = await seedCompany(companies, type: 'provider');
      final buyerUser = await seedUser(
        users,
        buyerCompany,
        email: 'buyer@som.test',
        roles: const ['buyer'],
      );
      await seedUser(
        users,
        providerCompany,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );

      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-1',
        buyerCompanyId: buyerCompany.id,
        createdByUserId: buyerUser.id,
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const ['tag'],
        deadline: now.add(const Duration(days: 1)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Need offer',
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
        assignedAt: null,
        closedAt: null,
        createdAt: now,
        updatedAt: now,
      );
      await inquiries.create(inquiry);
      await inquiries.assignToProviders(
        inquiryId: inquiry.id,
        assignedByUserId: buyerUser.id,
        providerCompanyIds: [providerCompany.id],
      );

      final notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: InMemoryProviderRepository(),
        inquiries: inquiries,
        offers: offers,
        email: email,
      );
      final scheduler = Scheduler(
        tokens: tokens,
        users: users,
        auth: TestAuthService(
          users: users,
          tokens: tokens,
          email: email,
          emailEvents: emailEvents,
          clock: Clock(),
        ),
        email: email,
        notifications: notifications,
        clock: Clock(),
        statusRepository: InMemorySchedulerStatusRepository(),
      );

      await scheduler.runOnce();
      expect(email.sent.length, 1);
      await scheduler.runOnce();
      expect(email.sent.length, 1);
    });

    test('continues after job failure and records status', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final tokens = InMemoryTokenRepository();
      final emailEvents = InMemoryEmailEventRepository();
      final email = TestEmailService();
      final statusRepo = InMemorySchedulerStatusRepository();

      final notifications = FailingNotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: InMemoryProviderRepository(),
        inquiries: inquiries,
        offers: offers,
        email: email,
      );

      final scheduler = Scheduler(
        tokens: tokens,
        users: users,
        auth: TestAuthService(
          users: users,
          tokens: tokens,
          email: email,
          emailEvents: emailEvents,
          clock: Clock(),
        ),
        email: email,
        notifications: notifications,
        clock: Clock(),
        statusRepository: statusRepo,
      );

      await scheduler.runOnce();

      expect(notifications.offersCalled, isTrue);
      expect(notifications.deadlinesCalled, isTrue);
      expect(notifications.adsCalled, isTrue);

      final statuses = await statusRepo.listAll();
      final deadlineStatus = statuses.firstWhere(
        (entry) => entry.jobName == 'inquiry.deadline_reminders',
      );
      expect(deadlineStatus.lastError, isNotNull);
      final adsStatus = statuses.firstWhere(
        (entry) => entry.jobName == 'ads.expiry',
      );
      expect(adsStatus.lastError, isNull);
    });
  });
}
