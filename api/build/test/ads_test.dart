import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/ads/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /ads', () {
    test('creates ad for provider', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final ads = InMemoryAdsRepository();
      final providers = InMemoryProviderRepository();
      final subscriptions = InMemorySubscriptionRepository();
      final company = await seedCompany(companies, type: 'provider');
      final user = await seedUser(
        users,
        company,
        email: 'provider@acme.test',
        roles: const ['provider'],
      );
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/ads',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'normal',
          'status': 'draft',
          'branchId': 'branch-1',
          'url': 'https://example.com',
          'imagePath': '/tmp/image.png',
          'headline': 'Test',
          'description': 'Desc',
          'startDate':
              DateTime.now().toUtc().add(const Duration(days: 1)).toIso8601String(),
          'endDate':
              DateTime.now().toUtc().add(const Duration(days: 7)).toIso8601String(),
        }),
      );
      context.provide<AdsRepository>(ads);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<ProviderRepository>(providers);
      context.provide<SubscriptionRepository>(subscriptions);
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<NotificationService>(
        NotificationService(
          ads: ads,
          users: users,
          companies: companies,
          providers: providers,
          inquiries: InMemoryInquiryRepository(),
          offers: InMemoryOfferRepository(),
          email: TestEmailService(),
        ),
      );
      context.provide<SomDomainModel>(SomDomainModel());
      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
    });
  });
}
