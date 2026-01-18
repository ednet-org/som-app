import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/inquiries/index.dart' as inquiries_route;
import '../routes/inquiries/[inquiryId]/offers/index.dart' as offers_route;
import '../routes/providers/[companyId]/decline.dart' as decline_route;
import 'test_utils.dart';

void main() {
  group('Provider status enforcement', () {
    test('decline captures rejection reason', () async {
      final providers = InMemoryProviderRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      await providers.createProfile(
        ProviderProfileRecord(
          companyId: company.id,
          bankDetails: BankDetails(
            iban: 'iban',
            bic: 'bic',
            accountOwner: 'owner',
          ),
          branchIds: const [],
          pendingBranchIds: const ['branch-1'],
          subscriptionPlanId: 'plan-1',
          paymentInterval: 'monthly',
          providerType: 'haendler',
          status: 'pending',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
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
        path: '/providers/${company.id}/decline',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode({'reason': 'Missing documents'}),
      );
      context.provide<ProviderRepository>(providers);
      context.provide<UserRepository>(users);
      context.provide<EmailService>(TestEmailService());

      final response =
          await decline_route.onRequest(context.context, company.id);
      expect(response.statusCode, 200);
      final updated = await providers.findByCompany(company.id);
      expect(updated?.rejectionReason, 'Missing documents');
      expect(updated?.rejectedAt, isNotNull);
    });

    test('pending provider cannot list inquiries', () async {
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final providers = InMemoryProviderRepository();
      final offers = InMemoryOfferRepository();
      final branches = InMemoryBranchRepository();
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
        ProviderProfileRecord(
          companyId: company.id,
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
          status: 'pending',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      final token = buildTestJwt(userId: user.id);
      final context = TestRequestContext(
        path: '/inquiries',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<InquiryRepository>(inquiries);
      context.provide<BranchRepository>(branches);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);

      final response = await inquiries_route.onRequest(context.context);
      expect(response.statusCode, 403);
    });

    test('pending provider cannot upload offer', () async {
      final users = InMemoryUserRepository();
      final inquiries = InMemoryInquiryRepository();
      final offers = InMemoryOfferRepository();
      final providers = InMemoryProviderRepository();
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
        ProviderProfileRecord(
          companyId: company.id,
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
          status: 'pending',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await inquiries.create(
        InquiryRecord(
          id: 'inq-1',
          buyerCompanyId: 'buyer-1',
          createdByUserId: 'user-1',
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
        ),
      );

      final token = buildTestJwt(userId: user.id);
      final context = _offerContext(token: token);
      context.provide<UserRepository>(users);
      context.provide<OfferRepository>(offers);
      context.provide<ProviderRepository>(providers);
      context.provide<InquiryRepository>(inquiries);
      context.provide<EmailService>(TestEmailService());
      context.provide<FileStorage>(TestFileStorage());
      context.provide<NotificationService>(
        NotificationService(
          ads: InMemoryAdsRepository(),
          users: users,
          companies: InMemoryCompanyRepository(),
          providers: providers,
          inquiries: inquiries,
          offers: offers,
          email: TestEmailService(),
        ),
      );
      context.provide<SomDomainModel>(SomDomainModel());

      final response = await offers_route.onRequest(context.context, 'inq-1');
      expect(response.statusCode, 403);
    });
  });
}

TestRequestContext _offerContext({required String token}) {
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
    path: '/inquiries/inq-1/offers',
    method: HttpMethod.post,
    headers: {
      'content-type': 'multipart/form-data; boundary=$boundary',
      'authorization': 'Bearer $token',
    },
    body: body,
  );
}
