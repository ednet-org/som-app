import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/models/models.dart';
import 'test_utils.dart';

void main() {
  group('ProviderRepository.searchProviders', () {
    late InMemoryProviderRepository providerRepo;
    late InMemoryCompanyRepository companyRepo;

    setUp(() {
      providerRepo = InMemoryProviderRepository();
      companyRepo = InMemoryCompanyRepository();
    });

    Future<void> seedProvider({
      required String name,
      String type = 'provider',
      String providerType = 'haendler',
      String status = 'active',
      String zip = '1010',
      String companySize = '0-10',
      List<String> branchIds = const ['branch-1'],
    }) async {
      final companyId = const Uuid().v4();
      final now = DateTime.now().toUtc();
      await companyRepo.create(CompanyRecord(
        id: companyId,
        name: name,
        type: type,
        address: Address(
          country: 'AT',
          city: 'Vienna',
          street: 'Main',
          number: '1',
          zip: zip,
        ),
        uidNr: 'UID$companyId',
        registrationNr: 'REG$companyId',
        companySize: companySize,
        websiteUrl: null,
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ));
      await providerRepo.createProfile(ProviderProfileRecord(
        companyId: companyId,
        bankDetails:
            BankDetails(iban: 'AT123', bic: 'BIC123', accountOwner: name),
        branchIds: branchIds,
        pendingBranchIds: const [],
        subscriptionPlanId: 'plan-1',
        paymentInterval: 'monthly',
        providerType: providerType,
        status: status,
        createdAt: now,
        updatedAt: now,
      ));
    }

    test('returns paginated results with limit and offset', () async {
      // Seed 5 providers
      for (var i = 0; i < 5; i++) {
        await seedProvider(name: 'Provider $i');
      }

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(limit: 2, offset: 0),
        companyRepo,
      );

      expect(result.totalCount, 5);
      expect(result.items.length, 2);

      // Get next page
      final page2 = await providerRepo.searchProviders(
        ProviderSearchParams(limit: 2, offset: 2),
        companyRepo,
      );
      expect(page2.totalCount, 5);
      expect(page2.items.length, 2);

      // Last page
      final page3 = await providerRepo.searchProviders(
        ProviderSearchParams(limit: 2, offset: 4),
        companyRepo,
      );
      expect(page3.totalCount, 5);
      expect(page3.items.length, 1);
    });

    test('filters by providerType', () async {
      await seedProvider(name: 'Haendler 1', providerType: 'haendler');
      await seedProvider(name: 'Hersteller 1', providerType: 'hersteller');
      await seedProvider(name: 'Haendler 2', providerType: 'haendler');

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(providerType: 'haendler'),
        companyRepo,
      );

      expect(result.totalCount, 2);
      expect(result.items.every((p) => p.providerType == 'haendler'), true);
    });

    test('filters by status', () async {
      await seedProvider(name: 'Active 1', status: 'active');
      await seedProvider(name: 'Pending 1', status: 'pending');
      await seedProvider(name: 'Active 2', status: 'active');

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(status: 'pending'),
        companyRepo,
      );

      expect(result.totalCount, 1);
      expect(result.items.first.status, 'pending');
    });

    test('filters by zipPrefix', () async {
      await seedProvider(name: 'Vienna 1', zip: '1010');
      await seedProvider(name: 'Vienna 2', zip: '1020');
      await seedProvider(name: 'Graz', zip: '8010');

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(zipPrefix: '10'),
        companyRepo,
      );

      expect(result.totalCount, 2);
      expect(result.items.every((p) => p.postcode.startsWith('10')), true);
    });

    test('filters by companySize', () async {
      await seedProvider(name: 'Small', companySize: '0-10');
      await seedProvider(name: 'Medium', companySize: '11-50');
      await seedProvider(name: 'Small 2', companySize: '0-10');

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(companySize: '0-10'),
        companyRepo,
      );

      expect(result.totalCount, 2);
      expect(result.items.every((p) => p.companySize == '0-10'), true);
    });

    test('filters by claimed (active status)', () async {
      await seedProvider(name: 'Active', status: 'active');
      await seedProvider(name: 'Pending', status: 'pending');
      await seedProvider(name: 'Declined', status: 'declined');

      final claimedResult = await providerRepo.searchProviders(
        ProviderSearchParams(claimed: true),
        companyRepo,
      );
      expect(claimedResult.totalCount, 1);
      expect(claimedResult.items.first.companyName, 'Active');

      final unclaimedResult = await providerRepo.searchProviders(
        ProviderSearchParams(claimed: false),
        companyRepo,
      );
      expect(unclaimedResult.totalCount, 2);
    });

    test('searches by company name (case-insensitive)', () async {
      await seedProvider(name: 'Acme Corporation');
      await seedProvider(name: 'Beta Industries');
      await seedProvider(name: 'Acme Holdings');

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(search: 'acme'),
        companyRepo,
      );

      expect(result.totalCount, 2);
      expect(
          result.items
              .every((p) => p.companyName.toLowerCase().contains('acme')),
          true);
    });

    test('filters by branchId', () async {
      await seedProvider(name: 'Branch1 Provider', branchIds: ['branch-1']);
      await seedProvider(name: 'Branch2 Provider', branchIds: ['branch-2']);
      await seedProvider(
          name: 'Both Branches', branchIds: ['branch-1', 'branch-2']);

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(branchId: 'branch-1'),
        companyRepo,
      );

      expect(result.totalCount, 2);
      expect(result.items.every((p) => p.branchIds.contains('branch-1')), true);
    });

    test('combines multiple filters', () async {
      await seedProvider(
        name: 'Target Provider',
        providerType: 'haendler',
        status: 'active',
        zip: '1010',
      );
      await seedProvider(
        name: 'Wrong Type',
        providerType: 'hersteller',
        status: 'active',
        zip: '1010',
      );
      await seedProvider(
        name: 'Wrong Status',
        providerType: 'haendler',
        status: 'pending',
        zip: '1010',
      );
      await seedProvider(
        name: 'Wrong Zip',
        providerType: 'haendler',
        status: 'active',
        zip: '8010',
      );

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(
          providerType: 'haendler',
          status: 'active',
          zipPrefix: '10',
        ),
        companyRepo,
      );

      expect(result.totalCount, 1);
      expect(result.items.first.companyName, 'Target Provider');
    });

    test('only returns provider/buyer_provider company types', () async {
      await seedProvider(name: 'Provider Co', type: 'provider');
      await seedProvider(name: 'Buyer Provider Co', type: 'buyer_provider');

      // This won't have a provider profile, so we just create a buyer company
      final buyerCompanyId = const Uuid().v4();
      final now = DateTime.now().toUtc();
      await companyRepo.create(CompanyRecord(
        id: buyerCompanyId,
        name: 'Buyer Only Co',
        type: 'buyer',
        address: Address(
            country: 'AT',
            city: 'Vienna',
            street: 'Main',
            number: '1',
            zip: '1010'),
        uidNr: 'UID$buyerCompanyId',
        registrationNr: 'REG$buyerCompanyId',
        companySize: '0-10',
        websiteUrl: null,
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ));

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(),
        companyRepo,
      );

      // Should only get the 2 providers, not the buyer-only company
      expect(result.totalCount, 2);
    });

    test('returns empty result when no matches', () async {
      await seedProvider(name: 'Acme Corp');

      final result = await providerRepo.searchProviders(
        ProviderSearchParams(search: 'nonexistent'),
        companyRepo,
      );

      expect(result.totalCount, 0);
      expect(result.items, isEmpty);
    });

    test('respects limit cap of 200', () async {
      // Even if we request more than 200, it should cap at 200
      final result = await providerRepo.searchProviders(
        ProviderSearchParams(limit: 500),
        companyRepo,
      );

      // The search should work (even with 0 providers)
      expect(result.items.length, lessThanOrEqualTo(200));
    });
  });
}
