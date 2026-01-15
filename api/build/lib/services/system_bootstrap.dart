import 'dart:io';

import 'package:uuid/uuid.dart';

import '../infrastructure/repositories/ads_repository.dart';
import '../infrastructure/repositories/branch_repository.dart';
import '../infrastructure/repositories/company_repository.dart';
import '../infrastructure/repositories/inquiry_repository.dart';
import '../infrastructure/repositories/offer_repository.dart';
import '../infrastructure/repositories/provider_repository.dart';
import '../infrastructure/repositories/subscription_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import '../infrastructure/clock.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'subscription_seed.dart';

class SystemBootstrap {
  SystemBootstrap({
    required this.companies,
    required this.users,
    required this.auth,
    required this.branches,
    required this.providers,
    required this.subscriptions,
    required this.inquiries,
    required this.offers,
    required this.ads,
  });

  final CompanyRepository companies;
  final UserRepository users;
  final AuthService auth;
  final BranchRepository branches;
  final ProviderRepository providers;
  final SubscriptionRepository subscriptions;
  final InquiryRepository inquiries;
  final OfferRepository offers;
  final AdsRepository ads;

  Future<void> ensureSystemAdmin() async {
    final email = const String.fromEnvironment(
      'SYSTEM_ADMIN_EMAIL',
      defaultValue: 'system-admin@som.local',
    ).toLowerCase();
    final password = const String.fromEnvironment(
      'SYSTEM_ADMIN_PASSWORD',
      defaultValue: 'ChangeMe123!',
    );
    final existing = await users.findByEmail(email);
    if (existing != null) {
      return;
    }
    final systemCompany = await _ensureSystemCompany();
    final now = DateTime.now().toUtc();
    final authUserId = await auth.ensureAuthUser(
      email: email,
      password: password,
      emailConfirmed: true,
    );
    final user = UserRecord(
      id: authUserId,
      companyId: systemCompany.id,
      email: email,
      firstName: 'System',
      lastName: 'Admin',
      salutation: 'Mx',
      title: null,
      telephoneNr: null,
      roles: const ['consultant', 'admin'],
      isActive: true,
      emailConfirmed: true,
      lastLoginRole: 'consultant',
      createdAt: now,
      updatedAt: now,
    );
    await users.create(user);
  }

  Future<void> ensureDevFixtures() async {
    final enabled = const bool.fromEnvironment(
          'DEV_FIXTURES',
          defaultValue: false,
        ) ||
        (Platform.environment['DEV_FIXTURES'] ?? '').toLowerCase() == 'true';
    if (!enabled) {
      return;
    }
    final now = DateTime.now().toUtc();
    final password = const String.fromEnvironment(
      'DEV_FIXTURES_PASSWORD',
      defaultValue: 'DevPass123!',
    );
    final systemCompany = await _ensureSystemCompany();
    final buyerCompany = await _ensureCompany(
      registrationNr: 'DEV-BUYER',
      name: 'Demo Buyer GmbH',
      type: 'buyer',
      uidNr: 'ATU-DEV-BUYER',
      city: 'Vienna',
    );
    final providerCompany = await _ensureCompany(
      registrationNr: 'DEV-PROVIDER',
      name: 'Demo Provider GmbH',
      type: 'provider',
      uidNr: 'ATU-DEV-PROVIDER',
      city: 'Graz',
    );
    final branchIt = await _ensureBranch('IT');
    final branchPrint = await _ensureBranch('Print');
    final branchFacilities = await _ensureBranch('Facilities');
    final branchMarketing = await _ensureBranch('Marketing');
    final branchTelecom = await _ensureBranch('Telecom');
    final categoryHardware = await _ensureCategory(branchIt, 'Hardware');
    final categoryPrint = await _ensureCategory(branchPrint, 'Office');
    final categoryFacilities =
        await _ensureCategory(branchFacilities, 'Cleaning');
    final categoryMarketing = await _ensureCategory(branchMarketing, 'Design');
    final categoryTelecom = await _ensureCategory(branchTelecom, 'Mobile');
    final planId = await _ensurePlanId();

    await _ensureUser(
      companyId: systemCompany.id,
      email: 'consultant@som.local',
      firstName: 'Consultant',
      lastName: 'User',
      roles: const ['consultant'],
      lastLoginRole: 'consultant',
      password: password,
      now: now,
    );
    await _ensureUser(
      companyId: systemCompany.id,
      email: 'consultant-admin@som.local',
      firstName: 'Consultant',
      lastName: 'Admin',
      roles: const ['consultant', 'admin'],
      lastLoginRole: 'consultant',
      password: password,
      now: now,
    );
    final buyerAdmin = await _ensureUser(
      companyId: buyerCompany.id,
      email: 'buyer-admin@som.local',
      firstName: 'Buyer',
      lastName: 'Admin',
      roles: const ['buyer', 'admin'],
      lastLoginRole: 'buyer',
      password: password,
      now: now,
    );
    await _ensureUser(
      companyId: buyerCompany.id,
      email: 'buyer-user@som.local',
      firstName: 'Buyer',
      lastName: 'User',
      roles: const ['buyer'],
      lastLoginRole: 'buyer',
      password: password,
      now: now,
    );
    final providerAdmin = await _ensureUser(
      companyId: providerCompany.id,
      email: 'provider-admin@som.local',
      firstName: 'Provider',
      lastName: 'Admin',
      roles: const ['provider', 'admin'],
      lastLoginRole: 'provider',
      password: password,
      now: now,
    );
    await _ensureUser(
      companyId: providerCompany.id,
      email: 'provider-user@som.local',
      firstName: 'Provider',
      lastName: 'User',
      roles: const ['provider'],
      lastLoginRole: 'provider',
      password: password,
      now: now,
    );

    if (planId != null) {
      final existingSubscription =
          await subscriptions.findSubscriptionByCompany(providerCompany.id);
      if (existingSubscription == null) {
        await subscriptions.createSubscription(
          SubscriptionRecord(
            id: const Uuid().v4(),
            companyId: providerCompany.id,
            planId: planId,
            status: 'active',
            paymentInterval: 'monthly',
            startDate: now,
            endDate: now.add(const Duration(days: 365)),
            createdAt: now,
          ),
        );
      }
      final profile = await providers.findByCompany(providerCompany.id);
      if (profile == null) {
        await providers.createProfile(
          ProviderProfileRecord(
            companyId: providerCompany.id,
            bankDetails: BankDetails(
              iban: 'AT000000000000000000',
              bic: 'DEVATW00',
              accountOwner: 'Demo Provider',
            ),
            branchIds: [branchIt.id],
            pendingBranchIds: const [],
            subscriptionPlanId: planId,
            paymentInterval: 'monthly',
            providerType: 'haendler',
            status: 'active',
            rejectionReason: null,
            rejectedAt: null,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }

    const devInquiryId = '00000000-0000-0000-0000-000000000001';
    const devInquiryId2 = '00000000-0000-0000-0000-000000000002';
    const devInquiryId3 = '00000000-0000-0000-0000-000000000003';
    const devInquiryId4 = '00000000-0000-0000-0000-000000000004';
    const devInquiryId5 = '00000000-0000-0000-0000-000000000005';
    final existingSeed = await inquiries.findById(devInquiryId);
    if (existingSeed != null) {
      return;
    }

    final contactInfo = ContactInfo(
      companyName: buyerCompany.name,
      salutation: buyerAdmin.salutation,
      title: buyerAdmin.title ?? '',
      firstName: buyerAdmin.firstName,
      lastName: buyerAdmin.lastName,
      telephone: buyerAdmin.telephoneNr ?? '',
      email: buyerAdmin.email,
    );

    final inquiryOne = InquiryRecord(
      id: devInquiryId,
      buyerCompanyId: buyerCompany.id,
      createdByUserId: buyerAdmin.id,
      status: 'open',
      branchId: branchIt.id,
      categoryId: categoryHardware.id,
      productTags: const ['ultrabook', 'dock', 'warranty'],
      deadline: now.add(const Duration(days: 10)),
      deliveryZips: const ['1010', '4020'],
      numberOfProviders: 3,
      description:
          '60 ultrabooks (14") with 16GB RAM/512GB SSD. Include docking stations and 3-year onsite support.',
      pdfPath: null,
      providerCriteria: ProviderCriteria(
        providerZip: '1010',
        radiusKm: 150,
        providerType: 'dealer',
        companySize: '11-50',
      ),
      contactInfo: contactInfo,
      notifiedAt: null,
      assignedAt: null,
      closedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    await inquiries.create(inquiryOne);
    await inquiries.assignToProviders(
      inquiryId: inquiryOne.id,
      assignedByUserId: buyerAdmin.id,
      providerCompanyIds: [providerCompany.id],
    );

    final inquiryTwo = InquiryRecord(
      id: devInquiryId2,
      buyerCompanyId: buyerCompany.id,
      createdByUserId: buyerAdmin.id,
      status: 'open',
      branchId: branchPrint.id,
      categoryId: categoryPrint.id,
      productTags: const ['A3', 'MFP', 'follow-me'],
      deadline: now.add(const Duration(days: 15)),
      deliveryZips: const ['8010'],
      numberOfProviders: 2,
      description:
          'Looking for 4 A3 color MFPs with follow-me printing. Rental + purchase options.',
      pdfPath: null,
      providerCriteria: ProviderCriteria(
        providerZip: '8010',
        radiusKm: 50,
        providerType: 'dealer',
        companySize: '0-10',
      ),
      contactInfo: contactInfo,
      notifiedAt: null,
      assignedAt: null,
      closedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    await inquiries.create(inquiryTwo);
    await inquiries.assignToProviders(
      inquiryId: inquiryTwo.id,
      assignedByUserId: buyerAdmin.id,
      providerCompanyIds: [providerCompany.id],
    );

    final inquiryThree = InquiryRecord(
      id: devInquiryId3,
      buyerCompanyId: buyerCompany.id,
      createdByUserId: buyerAdmin.id,
      status: 'closed',
      branchId: branchFacilities.id,
      categoryId: categoryFacilities.id,
      productTags: const ['cleaning', 'evening', '3 floors'],
      deadline: now.subtract(const Duration(days: 5)),
      deliveryZips: const ['4020'],
      numberOfProviders: 1,
      description:
          'Daily cleaning for 3 floors, 1,200 sqm, weekdays 18:00–22:00.',
      pdfPath: null,
      providerCriteria: ProviderCriteria(
        providerZip: '4020',
        radiusKm: 100,
        providerType: 'serviceProvider',
        companySize: 'upTo50',
      ),
      contactInfo: contactInfo,
      notifiedAt: now.subtract(const Duration(days: 7)),
      assignedAt: now.subtract(const Duration(days: 12)),
      closedAt: now.subtract(const Duration(days: 2)),
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now.subtract(const Duration(days: 2)),
    );
    await inquiries.create(inquiryThree);
    await inquiries.assignToProviders(
      inquiryId: inquiryThree.id,
      assignedByUserId: buyerAdmin.id,
      providerCompanyIds: [providerCompany.id],
    );

    final inquiryFour = InquiryRecord(
      id: devInquiryId4,
      buyerCompanyId: buyerCompany.id,
      createdByUserId: buyerAdmin.id,
      status: 'open',
      branchId: branchTelecom.id,
      categoryId: categoryTelecom.id,
      productTags: const ['5G', 'SIM', 'fleet'],
      deadline: now.add(const Duration(days: 20)),
      deliveryZips: const ['5020'],
      numberOfProviders: 2,
      description:
          'Need 200 managed SIMs with pooled data, MDM-ready plans, and device swap support.',
      pdfPath: null,
      providerCriteria: ProviderCriteria(
        providerZip: '5020',
        radiusKm: 250,
        providerType: 'wholesaler',
        companySize: '51-100',
      ),
      contactInfo: contactInfo,
      notifiedAt: null,
      assignedAt: null,
      closedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    await inquiries.create(inquiryFour);
    await inquiries.assignToProviders(
      inquiryId: inquiryFour.id,
      assignedByUserId: buyerAdmin.id,
      providerCompanyIds: [providerCompany.id],
    );

    final inquiryFive = InquiryRecord(
      id: devInquiryId5,
      buyerCompanyId: buyerCompany.id,
      createdByUserId: buyerAdmin.id,
      status: 'open',
      branchId: branchMarketing.id,
      categoryId: categoryMarketing.id,
      productTags: const ['branding', 'campaign', 'design'],
      deadline: now.add(const Duration(days: 25)),
      deliveryZips: const ['1010'],
      numberOfProviders: 1,
      description:
          'Looking for a brand refresh and a 3-month digital campaign rollout.',
      pdfPath: null,
      providerCriteria: ProviderCriteria(
        providerZip: '1010',
        radiusKm: 50,
        providerType: 'serviceProvider',
        companySize: '101-250',
      ),
      contactInfo: contactInfo,
      notifiedAt: null,
      assignedAt: null,
      closedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    await inquiries.create(inquiryFive);
    await inquiries.assignToProviders(
      inquiryId: inquiryFive.id,
      assignedByUserId: buyerAdmin.id,
      providerCompanyIds: [providerCompany.id],
    );

    await offers.create(
      OfferRecord(
        id: '00000000-0000-0000-0000-00000000f001',
        inquiryId: inquiryOne.id,
        providerCompanyId: providerCompany.id,
        providerUserId: providerAdmin.id,
        status: 'offer_uploaded',
        pdfPath: null,
        forwardedAt: now.subtract(const Duration(days: 1)),
        resolvedAt: null,
        buyerDecision: null,
        providerDecision: 'offer_created',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    );
    await offers.create(
      OfferRecord(
        id: '00000000-0000-0000-0000-00000000f002',
        inquiryId: inquiryTwo.id,
        providerCompanyId: providerCompany.id,
        providerUserId: providerAdmin.id,
        status: 'rejected',
        pdfPath: null,
        forwardedAt: now.subtract(const Duration(days: 2)),
        resolvedAt: now.subtract(const Duration(days: 1)),
        buyerDecision: 'rejected',
        providerDecision: 'lost',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    );
    await offers.create(
      OfferRecord(
        id: '00000000-0000-0000-0000-00000000f003',
        inquiryId: inquiryThree.id,
        providerCompanyId: providerCompany.id,
        providerUserId: providerAdmin.id,
        status: 'accepted',
        pdfPath: null,
        forwardedAt: now.subtract(const Duration(days: 15)),
        resolvedAt: now.subtract(const Duration(days: 10)),
        buyerDecision: 'accepted',
        providerDecision: 'won',
        createdAt: now.subtract(const Duration(days: 16)),
      ),
    );

    await ads.create(
      AdRecord(
        id: '00000000-0000-0000-0000-00000000a001',
        companyId: providerCompany.id,
        type: 'normal',
        status: 'active',
        branchId: branchMarketing.id,
        url: 'https://example.com/demo-provider',
        imagePath: 'ads/demo-provider-1.png',
        headline: 'SOM Premium Partner',
        description: 'Managed print + device leasing with 24h response time.',
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 13)),
        bannerDate: null,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await ads.create(
      AdRecord(
        id: '00000000-0000-0000-0000-00000000a002',
        companyId: providerCompany.id,
        type: 'banner',
        status: 'active',
        branchId: branchIt.id,
        url: 'https://example.com/demo-provider',
        imagePath: 'ads/demo-provider-banner.png',
        headline: null,
        description: null,
        startDate: null,
        endDate: null,
        bannerDate: now.add(const Duration(days: 2)),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<CompanyRecord> _ensureSystemCompany() async {
    final existing = await companies.findByRegistrationNr('SYSTEM');
    if (existing != null) {
      return existing;
    }
    final now = DateTime.now().toUtc();
    final company = CompanyRecord(
      id: const Uuid().v4(),
      name: 'SOM Platform',
      type: 'platform',
      address: Address(
        country: 'AT',
        city: 'Vienna',
        street: 'System',
        number: '1',
        zip: '1010',
      ),
      uidNr: 'SYSTEM',
      registrationNr: 'SYSTEM',
      companySize: '0-10',
      websiteUrl: null,
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );
    await companies.create(company);
    return company;
  }

  Future<CompanyRecord> _ensureCompany({
    required String registrationNr,
    required String name,
    required String type,
    required String uidNr,
    required String city,
  }) async {
    final existing = await companies.findByRegistrationNr(registrationNr);
    if (existing != null) {
      return existing;
    }
    final now = DateTime.now().toUtc();
    final company = CompanyRecord(
      id: const Uuid().v4(),
      name: name,
      type: type,
      address: Address(
        country: 'AT',
        city: city,
        street: 'Dev Street',
        number: '1',
        zip: '1010',
      ),
      uidNr: uidNr,
      registrationNr: registrationNr,
      companySize: '11-50',
      websiteUrl: 'https://example.com',
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );
    await companies.create(company);
    return company;
  }

  Future<BranchRecord> _ensureBranch(String name) async {
    final existing = await branches.findBranchByName(name);
    if (existing != null) {
      return existing;
    }
    final branch = BranchRecord(id: const Uuid().v4(), name: name);
    await branches.createBranch(branch);
    return branch;
  }

  Future<CategoryRecord> _ensureCategory(
    BranchRecord branch,
    String name,
  ) async {
    final existing = await branches.findCategory(branch.id, name);
    if (existing != null) {
      return existing;
    }
    final category =
        CategoryRecord(id: const Uuid().v4(), branchId: branch.id, name: name);
    await branches.createCategory(category);
    return category;
  }

  Future<String?> _ensurePlanId() async {
    final seeder = SubscriptionSeeder(
      repository: subscriptions,
      clock: const Clock(),
    );
    await seeder.seedDefaults();
    final plans = await subscriptions.listPlans();
    if (plans.isEmpty) {
      return null;
    }
    return plans.first.id;
  }

  Future<UserRecord> _ensureUser({
    required String companyId,
    required String email,
    required String firstName,
    required String lastName,
    required List<String> roles,
    required String lastLoginRole,
    required String password,
    required DateTime now,
  }) async {
    final existing = await users.findByEmail(email);
    if (existing != null) {
      try {
        await auth.updateAuthPassword(
          userId: existing.id,
          password: password,
          emailConfirmed: true,
        );
        return existing;
      } catch (_) {
        await users.deleteById(existing.id);
      }
    }
    final authUserId = await auth.ensureAuthUser(
      email: email,
      password: password,
      emailConfirmed: true,
    );
    final user = UserRecord(
      id: authUserId,
      companyId: companyId,
      email: email.toLowerCase(),
      firstName: firstName,
      lastName: lastName,
      salutation: 'Mx',
      title: null,
      telephoneNr: null,
      roles: roles,
      isActive: true,
      emailConfirmed: true,
      lastLoginRole: lastLoginRole,
      createdAt: now,
      updatedAt: now,
    );
    await users.create(user);
    return user;
  }
}
