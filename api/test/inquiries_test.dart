import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/file_storage.dart';
import '../routes/inquiries/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /inquiries', () {
    test('creates inquiry for buyer', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'buyer@acme.test',
        roles: const ['buyer'],
      );
      final token = buildTestJwt(userId: user.id);

      final context = TestRequestContext(
        path: '/inquiries',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'branchId': 'branch-1',
          'categoryId': 'cat-1',
          'productTags': ['tag1'],
          'deadline': DateTime.now()
              .toUtc()
              .add(const Duration(days: 5))
              .toIso8601String(),
          'deliveryZips': ['1010'],
          'numberOfProviders': 1,
          'description': 'Test inquiry',
        }),
      );
      context.provide<CompanyRepository>(companies);
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<OfferRepository>(offers);
      context.provide<FileStorage>(TestFileStorage());
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
    });
  });
}
