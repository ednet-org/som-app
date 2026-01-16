import 'package:test/test.dart';

import 'package:som_api/models/models.dart';
import 'package:som_api/services/notification_service.dart';
import 'test_utils.dart';

void main() {
  group('Deadline notifications', () {
    test('sends provider reminder and marks assignment', () async {
      final inquiries = InMemoryInquiryRepository();
      final users = InMemoryUserRepository();
      final companies = InMemoryCompanyRepository();
      final providers = InMemoryProviderRepository();
      final offers = InMemoryOfferRepository();
      final email = TestEmailService();

      final providerCompany = await seedCompany(companies, type: 'provider');
      await seedUser(
        users,
        providerCompany,
        email: 'provider-admin@som.test',
        roles: const ['provider', 'admin'],
      );
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: providerCompany.id,
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
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );

      final now = DateTime.now().toUtc();
      final inquiry = InquiryRecord(
        id: 'inq-deadline',
        buyerCompanyId: providerCompany.id,
        createdByUserId: 'buyer',
        status: 'open',
        branchId: 'branch-1',
        categoryId: 'cat-1',
        productTags: const ['tag'],
        deadline: now.add(const Duration(days: 1)),
        deliveryZips: const ['1010'],
        numberOfProviders: 1,
        description: 'Reminder test',
        pdfPath: null,
        providerCriteria: ProviderCriteria(),
        contactInfo: ContactInfo(
          companyName: 'Buyer Co',
          salutation: 'Mr',
          title: '',
          firstName: 'Buyer',
          lastName: 'Admin',
          telephone: '123',
          email: 'buyer@som.test',
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
        assignedByUserId: 'consultant',
        providerCompanyIds: [providerCompany.id],
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

      await notifications.notifyProvidersOfUpcomingDeadlines(
        window: const Duration(days: 2),
        now: now,
      );

      expect(email.sent.length, 1);
      final assignments = await inquiries.listAssignmentsByInquiry(inquiry.id);
      expect(assignments.first.deadlineReminderSentAt, isNotNull);
    });
  });
}
