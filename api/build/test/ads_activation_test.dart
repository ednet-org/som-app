import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/ads/[adId]/activate.dart' as activate_route;
import '../routes/ads/[adId]/deactivate.dart' as deactivate_route;
import 'test_utils.dart';

void main() {
  test('activate and deactivate ad', () async {
    final companies = InMemoryCompanyRepository();
    final users = InMemoryUserRepository();
    final ads = InMemoryAdsRepository();
    final providers = InMemoryProviderRepository();
    final subscriptions = InMemorySubscriptionRepository();

    final company = await seedCompany(companies, type: 'provider');
    final user = await seedUser(
      users,
      company,
      email: 'provider@som.test',
      roles: const ['provider'],
    );
    final now = DateTime.now().toUtc();
    final ad = AdRecord(
      id: 'ad-1',
      companyId: company.id,
      type: 'normal',
      status: 'draft',
      branchId: 'branch-1',
      url: 'https://example.com',
      imagePath: '/tmp/image.png',
      headline: 'Demo',
      description: 'Desc',
      startDate: now.add(const Duration(days: 2)),
      endDate: now.add(const Duration(days: 9)),
      bannerDate: null,
      createdAt: now,
      updatedAt: now,
    );
    await ads.create(ad);
    await providers.createProfile(
      ProviderProfileRecord(
        companyId: company.id,
        bankDetails: BankDetails(
          iban: 'AT000000000000000000',
          bic: 'DEVATW00',
          accountOwner: 'Provider',
        ),
        branchIds: const [],
        pendingBranchIds: const [],
        subscriptionPlanId: '',
        paymentInterval: 'monthly',
        providerType: 'haendler',
        status: 'active',
        rejectionReason: null,
        rejectedAt: null,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final token = buildTestJwt(userId: user.id);
    final activateContext = TestRequestContext(
      path: '/ads/ad-1/activate',
      method: HttpMethod.post,
      headers: {'authorization': 'Bearer $token'},
    );
    activateContext.provide<AdsRepository>(ads);
    activateContext.provide<UserRepository>(users);
    activateContext.provide<CompanyRepository>(companies);
    activateContext.provide<ProviderRepository>(providers);
    activateContext.provide<SubscriptionRepository>(subscriptions);
    activateContext.provide<NotificationService>(
      NotificationService(
        ads: ads,
        users: users,
        companies: companies,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: TestEmailService(),
      ),
    );

    final activateResponse =
        await activate_route.onRequest(activateContext.context, 'ad-1');
    expect(activateResponse.statusCode, 200);
    final activated = await ads.findById('ad-1');
    expect(activated?.status, 'active');

    final deactivateContext = TestRequestContext(
      path: '/ads/ad-1/deactivate',
      method: HttpMethod.post,
      headers: {'authorization': 'Bearer $token'},
    );
    deactivateContext.provide<AdsRepository>(ads);
    deactivateContext.provide<UserRepository>(users);
    deactivateContext.provide<CompanyRepository>(companies);
    deactivateContext.provide<NotificationService>(
      NotificationService(
        ads: ads,
        users: users,
        companies: companies,
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: TestEmailService(),
      ),
    );
    final deactivateResponse =
        await deactivate_route.onRequest(deactivateContext.context, 'ad-1');
    expect(deactivateResponse.statusCode, 200);
    final deactivated = await ads.findById('ad-1');
    expect(deactivated?.status, 'draft');
  });
}
