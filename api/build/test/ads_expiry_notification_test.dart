import 'package:test/test.dart';

import 'package:som_api/models/models.dart';
import 'package:som_api/services/notification_service.dart';
import 'test_utils.dart';

void main() {
  test('expires ads and notifies provider admins', () async {
    final ads = InMemoryAdsRepository();
    final companies = InMemoryCompanyRepository();
    final users = InMemoryUserRepository();
    final inquiries = InMemoryInquiryRepository();
    final offers = InMemoryOfferRepository();
    final email = TestEmailService();

    final company = await seedCompany(companies, type: 'provider');
    await seedUser(
      users,
      company,
      email: 'admin@provider.test',
      roles: const ['admin', 'provider'],
    );

    final now = DateTime.utc(2025, 1, 10, 12);
    final expiredNormal = AdRecord(
      id: 'ad-normal',
      companyId: company.id,
      type: 'normal',
      status: 'active',
      branchId: 'branch-1',
      url: 'https://example.com',
      imagePath: '/tmp/normal.png',
      headline: 'Normal',
      description: null,
      startDate: now.subtract(const Duration(days: 10)),
      endDate: now.subtract(const Duration(days: 1)),
      bannerDate: null,
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(days: 2)),
    );
    final expiredBanner = AdRecord(
      id: 'ad-banner',
      companyId: company.id,
      type: 'banner',
      status: 'active',
      branchId: 'branch-1',
      url: 'https://example.com',
      imagePath: '/tmp/banner.png',
      headline: 'Banner',
      description: null,
      startDate: null,
      endDate: null,
      bannerDate: DateTime.utc(2025, 1, 8),
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(days: 2)),
    );
    final activeFuture = AdRecord(
      id: 'ad-active',
      companyId: company.id,
      type: 'normal',
      status: 'active',
      branchId: 'branch-1',
      url: 'https://example.com',
      imagePath: '/tmp/future.png',
      headline: 'Future',
      description: null,
      startDate: now.add(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 5)),
      bannerDate: null,
      createdAt: now,
      updatedAt: now,
    );
    await ads.create(expiredNormal);
    await ads.create(expiredBanner);
    await ads.create(activeFuture);

    final notifications = NotificationService(
      ads: ads,
      users: users,
      companies: companies,
      providers: InMemoryProviderRepository(),
      inquiries: inquiries,
      offers: offers,
      email: email,
    );

    await notifications.notifyProvidersForExpiredAds(now: now);

    final updatedNormal = await ads.findById('ad-normal');
    final updatedBanner = await ads.findById('ad-banner');
    final updatedFuture = await ads.findById('ad-active');

    expect(updatedNormal?.status, 'expired');
    expect(updatedBanner?.status, 'expired');
    expect(updatedFuture?.status, 'active');
    expect(email.sent.where((m) => m.subject.contains('expired')).length, 2);
  });
}
