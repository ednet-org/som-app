import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/file_storage.dart';
import '../routes/inquiries/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /inquiries', () {
    test('creates inquiry for buyer', () async {
      final db = createTestDb();
      final company = seedCompany(db);
      final authService = createAuthService(db);
      final passwordHash = authService.hashPassword('secret');
      final user = seedUser(db, company, email: 'buyer@acme.test', passwordHash: passwordHash);
      final token = authService.issueAccessToken(user, role: 'buyer');

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
          'deadline': DateTime.now().toUtc().add(const Duration(days: 5)).toIso8601String(),
          'deliveryZips': ['1010'],
          'numberOfProviders': 1,
          'description': 'Test inquiry',
        }),
      );
      context.provide<CompanyRepository>(CompanyRepository(db));
      context.provide<UserRepository>(UserRepository(db));
      context.provide<InquiryRepository>(InquiryRepository(db));
      context.provide<OfferRepository>(OfferRepository(db));
      context.provide<FileStorage>(FileStorage(basePath: 'storage/test_uploads'));
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await route.onRequest(context.context);
      expect(response.statusCode, 200);
    });
  });
}
