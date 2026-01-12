import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:supabase/supabase.dart' show SupabaseClient;
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/subscription_seed.dart';

const _testJwtSecret = 'som_dev_secret';

String buildTestJwt({required String userId}) {
  final jwt = JWT({'sub': userId});
  return jwt.sign(SecretKey(_testJwtSecret));
}

class InMemoryCompanyRepository implements CompanyRepository {
  final Map<String, CompanyRecord> _companies = {};

  @override
  Future<void> create(CompanyRecord company) async {
    _companies[company.id] = company;
  }

  @override
  Future<CompanyRecord?> findById(String id) async => _companies[id];

  @override
  Future<List<CompanyRecord>> listAll() async {
    final list = _companies.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Future<void> update(CompanyRecord company) async {
    _companies[company.id] = company;
  }

  @override
  Future<bool> existsByName(String name) async {
    return _companies.values.any((c) => c.name.toLowerCase() == name.toLowerCase());
  }

  @override
  Future<CompanyRecord?> findByRegistrationNr(String registrationNr) async {
    for (final company in _companies.values) {
      if (company.registrationNr == registrationNr) {
        return company;
      }
    }
    return null;
  }
}

class InMemoryUserRepository implements UserRepository {
  final Map<String, UserRecord> _users = {};

  @override
  Future<void> create(UserRecord user) async {
    _users[user.id] = user;
  }

  @override
  Future<UserRecord?> findById(String id) async => _users[id];

  @override
  Future<UserRecord?> findByEmail(String email) async {
    for (final user in _users.values) {
      if (user.email.toLowerCase() == email.toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<List<UserRecord>> listByCompany(String companyId) async {
    return _users.values
        .where((u) => u.companyId == companyId)
        .toList()
      ..sort((a, b) => a.email.compareTo(b.email));
  }

  @override
  Future<List<UserRecord>> listAdminsByCompany(String companyId) async {
    return _users.values
        .where((u) => u.companyId == companyId && u.roles.contains('admin'))
        .toList();
  }

  @override
  Future<List<UserRecord>> listByRole(String role) async {
    return _users.values.where((u) => u.roles.contains(role)).toList();
  }

  @override
  Future<void> update(UserRecord user) async {
    _users[user.id] = user;
  }

  @override
  Future<void> setPassword(String userId, String passwordHash) async {
    final existing = _users[userId];
    if (existing != null) {
      _users[userId] = UserRecord(
        id: existing.id,
        companyId: existing.companyId,
        email: existing.email,
        firstName: existing.firstName,
        lastName: existing.lastName,
        salutation: existing.salutation,
        title: existing.title,
        telephoneNr: existing.telephoneNr,
        roles: existing.roles,
        isActive: existing.isActive,
        emailConfirmed: existing.emailConfirmed,
        lastLoginRole: existing.lastLoginRole,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }
  }

  @override
  Future<void> confirmEmail(String userId) async {
    final existing = _users[userId];
    if (existing != null) {
      _users[userId] = UserRecord(
        id: existing.id,
        companyId: existing.companyId,
        email: existing.email,
        firstName: existing.firstName,
        lastName: existing.lastName,
        salutation: existing.salutation,
        title: existing.title,
        telephoneNr: existing.telephoneNr,
        roles: existing.roles,
        isActive: existing.isActive,
        emailConfirmed: true,
        lastLoginRole: existing.lastLoginRole,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }
  }

  @override
  Future<void> deactivate(String userId) async {
    final existing = _users[userId];
    if (existing != null) {
      _users[userId] = UserRecord(
        id: existing.id,
        companyId: existing.companyId,
        email: existing.email,
        firstName: existing.firstName,
        lastName: existing.lastName,
        salutation: existing.salutation,
        title: existing.title,
        telephoneNr: existing.telephoneNr,
        roles: existing.roles,
        isActive: false,
        emailConfirmed: existing.emailConfirmed,
        lastLoginRole: existing.lastLoginRole,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }
  }

  @override
  Future<void> updateLastLoginRole(String userId, String role) async {
    final existing = _users[userId];
    if (existing != null) {
      _users[userId] = UserRecord(
        id: existing.id,
        companyId: existing.companyId,
        email: existing.email,
        firstName: existing.firstName,
        lastName: existing.lastName,
        salutation: existing.salutation,
        title: existing.title,
        telephoneNr: existing.telephoneNr,
        roles: existing.roles,
        isActive: existing.isActive,
        emailConfirmed: existing.emailConfirmed,
        lastLoginRole: role,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }
  }

  @override
  Future<void> deleteById(String userId) async {
    _users.remove(userId);
  }
}

class InMemoryProviderRepository implements ProviderRepository {
  final Map<String, ProviderProfileRecord> _profiles = {};

  @override
  Future<void> createProfile(ProviderProfileRecord profile) async {
    _profiles[profile.companyId] = profile;
  }

  @override
  Future<ProviderProfileRecord?> findByCompany(String companyId) async =>
      _profiles[companyId];

  @override
  Future<void> update(ProviderProfileRecord profile) async {
    _profiles[profile.companyId] = profile;
  }
}

class InMemorySubscriptionRepository implements SubscriptionRepository {
  final Map<String, SubscriptionPlanRecord> _plans = {};
  final List<SubscriptionRecord> _subscriptions = [];

  @override
  Future<void> createPlan(SubscriptionPlanRecord plan) async {
    _plans[plan.id] = plan;
  }

  @override
  Future<List<SubscriptionPlanRecord>> listPlans() async {
    final list = _plans.values.toList();
    list.sort((a, b) => a.sortPriority.compareTo(b.sortPriority));
    return list;
  }

  @override
  Future<SubscriptionPlanRecord?> findPlanById(String id) async => _plans[id];

  @override
  Future<bool> hasPlans() async => _plans.isNotEmpty;

  @override
  Future<void> createSubscription(SubscriptionRecord subscription) async {
    _subscriptions.add(subscription);
  }

  @override
  Future<SubscriptionRecord?> findSubscriptionByCompany(String companyId) async {
    final items =
        _subscriptions.where((s) => s.companyId == companyId).toList();
    if (items.isEmpty) return null;
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items.first;
  }
}

class InMemoryBranchRepository implements BranchRepository {
  final Map<String, BranchRecord> _branches = {};
  final Map<String, CategoryRecord> _categories = {};

  @override
  Future<void> createBranch(BranchRecord branch) async {
    _branches[branch.id] = branch;
  }

  @override
  Future<void> createCategory(CategoryRecord category) async {
    _categories[category.id] = category;
  }

  @override
  Future<List<BranchRecord>> listBranches() async {
    final list = _branches.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Future<List<CategoryRecord>> listCategories(String branchId) async {
    final list =
        _categories.values.where((c) => c.branchId == branchId).toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Future<BranchRecord?> findBranchByName(String name) async {
    for (final branch in _branches.values) {
      if (branch.name.toLowerCase() == name.toLowerCase()) {
        return branch;
      }
    }
    return null;
  }

  @override
  Future<CategoryRecord?> findCategory(String branchId, String name) async {
    for (final category in _categories.values) {
      if (category.branchId == branchId &&
          category.name.toLowerCase() == name.toLowerCase()) {
        return category;
      }
    }
    return null;
  }

  @override
  Future<void> deleteBranch(String branchId) async {
    _branches.remove(branchId);
    _categories.removeWhere((_, category) => category.branchId == branchId);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    _categories.remove(categoryId);
  }
}

class InMemoryInquiryRepository implements InquiryRepository {
  final Map<String, InquiryRecord> _inquiries = {};
  final Map<String, Set<String>> _assignments = {};

  @override
  Future<void> create(InquiryRecord inquiry) async {
    _inquiries[inquiry.id] = inquiry;
  }

  @override
  Future<InquiryRecord?> findById(String id) async => _inquiries[id];

  @override
  Future<List<InquiryRecord>> listByBuyerCompany(String companyId) async {
    return _inquiries.values
        .where((i) => i.buyerCompanyId == companyId)
        .toList();
  }

  @override
  Future<List<InquiryRecord>> listAll({String? status}) async {
    return _inquiries.values
        .where((i) => status == null || i.status == status)
        .toList();
  }

  @override
  Future<List<InquiryRecord>> listAssignedToProvider(
    String providerCompanyId,
  ) async {
    final ids = _assignments[providerCompanyId] ?? <String>{};
    return _inquiries.values.where((i) => ids.contains(i.id)).toList();
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    final existing = _inquiries[id];
    if (existing != null) {
      _inquiries[id] = InquiryRecord(
        id: existing.id,
        buyerCompanyId: existing.buyerCompanyId,
        createdByUserId: existing.createdByUserId,
        status: status,
        branchId: existing.branchId,
        categoryId: existing.categoryId,
        productTags: existing.productTags,
        deadline: existing.deadline,
        deliveryZips: existing.deliveryZips,
        numberOfProviders: existing.numberOfProviders,
        description: existing.description,
        pdfPath: existing.pdfPath,
        providerCriteria: existing.providerCriteria,
        contactInfo: existing.contactInfo,
        notifiedAt: existing.notifiedAt,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }
  }

  @override
  Future<void> markNotified(String id, DateTime notifiedAt) async {
    final existing = _inquiries[id];
    if (existing != null) {
      _inquiries[id] = InquiryRecord(
        id: existing.id,
        buyerCompanyId: existing.buyerCompanyId,
        createdByUserId: existing.createdByUserId,
        status: existing.status,
        branchId: existing.branchId,
        categoryId: existing.categoryId,
        productTags: existing.productTags,
        deadline: existing.deadline,
        deliveryZips: existing.deliveryZips,
        numberOfProviders: existing.numberOfProviders,
        description: existing.description,
        pdfPath: existing.pdfPath,
        providerCriteria: existing.providerCriteria,
        contactInfo: existing.contactInfo,
        notifiedAt: notifiedAt,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }
  }

  @override
  Future<void> assignToProviders({
    required String inquiryId,
    required String assignedByUserId,
    required List<String> providerCompanyIds,
  }) async {
    for (final providerCompanyId in providerCompanyIds) {
      _assignments.putIfAbsent(providerCompanyId, () => <String>{}).add(inquiryId);
    }
  }
}

class InMemoryOfferRepository implements OfferRepository {
  final Map<String, OfferRecord> _offers = {};

  @override
  Future<void> create(OfferRecord offer) async {
    _offers[offer.id] = offer;
  }

  @override
  Future<List<OfferRecord>> listByInquiry(String inquiryId) async {
    return _offers.values.where((o) => o.inquiryId == inquiryId).toList();
  }

  @override
  Future<OfferRecord?> findById(String id) async => _offers[id];

  @override
  Future<void> updateStatus({
    required String id,
    required String status,
    String? buyerDecision,
    String? providerDecision,
    DateTime? forwardedAt,
    DateTime? resolvedAt,
  }) async {
    final existing = _offers[id];
    if (existing != null) {
      _offers[id] = OfferRecord(
        id: existing.id,
        inquiryId: existing.inquiryId,
        providerCompanyId: existing.providerCompanyId,
        providerUserId: existing.providerUserId,
        status: status,
        pdfPath: existing.pdfPath,
        forwardedAt: forwardedAt ?? existing.forwardedAt,
        resolvedAt: resolvedAt ?? existing.resolvedAt,
        buyerDecision: buyerDecision ?? existing.buyerDecision,
        providerDecision: providerDecision ?? existing.providerDecision,
        createdAt: existing.createdAt,
      );
    }
  }
}

class InMemoryAdsRepository implements AdsRepository {
  final Map<String, AdRecord> _ads = {};

  @override
  Future<void> create(AdRecord ad) async {
    _ads[ad.id] = ad;
  }

  @override
  Future<List<AdRecord>> listActive({String? branchId}) async {
    return _ads.values
        .where((a) =>
            a.status == 'active' &&
            (branchId == null || a.branchId == branchId))
        .toList();
  }

  @override
  Future<List<AdRecord>> listByCompany(String companyId) async {
    return _ads.values.where((a) => a.companyId == companyId).toList();
  }

  @override
  Future<int> countActiveByCompanyInMonth(
    String companyId,
    DateTime month,
  ) async {
    final start = DateTime.utc(month.year, month.month, 1);
    final end = DateTime.utc(month.year, month.month + 1, 1);
    return _ads.values
        .where((a) =>
            a.companyId == companyId &&
            a.status == 'active' &&
            a.createdAt.isAfter(start) &&
            a.createdAt.isBefore(end))
        .length;
  }

  @override
  Future<int> countBannerForDate(DateTime date) async {
    return _ads.values
        .where((a) =>
            a.type == 'banner' &&
            a.bannerDate != null &&
            a.bannerDate!.year == date.year &&
            a.bannerDate!.month == date.month &&
            a.bannerDate!.day == date.day)
        .length;
  }

  @override
  Future<AdRecord?> findById(String id) async => _ads[id];

  @override
  Future<void> update(AdRecord ad) async {
    _ads[ad.id] = ad;
  }

  @override
  Future<void> delete(String id) async {
    _ads.remove(id);
  }
}

class InMemoryTokenRepository implements TokenRepository {
  final Map<String, TokenRecord> _tokens = {};
  final Map<String, RefreshTokenRecord> _refreshTokens = {};

  @override
  Future<void> create(TokenRecord record) async {
    _tokens[record.id] = record;
  }

  @override
  Future<TokenRecord?> findValidByHash(String type, String tokenHash) async {
    for (final token in _tokens.values) {
      if (token.type == type &&
          token.tokenHash == tokenHash &&
          token.usedAt == null) {
        return token;
      }
    }
    return null;
  }

  @override
  Future<List<TokenRecord>> findExpiringSoon(String type, DateTime before) async {
    return _tokens.values
        .where(
          (t) => t.type == type && t.usedAt == null && t.expiresAt.isBefore(before),
        )
        .toList();
  }

  @override
  Future<void> markUsed(String id, DateTime usedAt) async {
    final existing = _tokens[id];
    if (existing != null) {
      _tokens[id] = TokenRecord(
        id: existing.id,
        userId: existing.userId,
        type: existing.type,
        tokenHash: existing.tokenHash,
        expiresAt: existing.expiresAt,
        createdAt: existing.createdAt,
        usedAt: usedAt,
      );
    }
  }

  @override
  Future<void> deleteExpired(DateTime now) async {
    _tokens.removeWhere(
      (_, token) => token.usedAt == null && token.expiresAt.isBefore(now),
    );
  }

  @override
  Future<void> createRefresh(RefreshTokenRecord record) async {
    _refreshTokens[record.id] = record;
  }

  @override
  Future<RefreshTokenRecord?> findRefreshByHash(String tokenHash) async {
    for (final token in _refreshTokens.values) {
      if (token.tokenHash == tokenHash) {
        return token;
      }
    }
    return null;
  }

  @override
  Future<void> revokeRefresh(String id, DateTime revokedAt) async {
    final existing = _refreshTokens[id];
    if (existing != null) {
      _refreshTokens[id] = RefreshTokenRecord(
        id: existing.id,
        userId: existing.userId,
        tokenHash: existing.tokenHash,
        expiresAt: existing.expiresAt,
        createdAt: existing.createdAt,
        revokedAt: revokedAt,
      );
    }
  }
}

class TestAuthService extends AuthService {
  TestAuthService({
    required super.users,
    required super.tokens,
    required super.email,
    required super.clock,
  }) : super(
          adminClient: SupabaseClient('http://localhost', 'service'),
          anonClient: SupabaseClient('http://localhost', 'anon'),
        );

  final Map<String, String> _passwords = {};

  void setPassword(String email, String password) {
    _passwords[email.toLowerCase()] = password;
  }

  @override
  Future<AuthTokens> login({
    required String emailAddress,
    required String password,
  }) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null || !user.isActive) {
      throw AuthException('Invalid password or E-Mail');
    }
    if (!user.emailConfirmed) {
      throw AuthException('Email not confirmed');
    }
    final expected = _passwords[emailAddress.toLowerCase()];
    if (expected == null || expected != password) {
      throw AuthException('Invalid password or E-Mail');
    }
    return AuthTokens(accessToken: 'test-token', refreshToken: 'test-refresh');
  }

  @override
  Future<String> ensureAuthUser({
    required String email,
    String? password,
    bool emailConfirmed = false,
  }) async {
    return const Uuid().v4();
  }

  @override
  Future<String> createRegistrationToken(UserRecord user) async {
    return 'test-token';
  }

  @override
  Future<void> deleteAuthUser(String userId) async {}
}

class TestFileStorage implements FileStorage {
  @override
  Future<String> saveFile({
    required String category,
    required String fileName,
    required List<int> bytes,
  }) async {
    return '$category/$fileName';
  }
}

Future<CompanyRecord> seedCompany(
  CompanyRepository companies, {
  String type = 'buyer',
}) async {
  final now = DateTime.now().toUtc();
  final company = CompanyRecord(
    id: const Uuid().v4(),
    name: 'Test Company',
    type: type,
    address: Address(
      country: 'AT',
      city: 'Vienna',
      street: 'Main',
      number: '1',
      zip: '1010',
    ),
    uidNr: 'UID123',
    registrationNr: 'REG123',
    companySize: '0-10',
    websiteUrl: 'https://example.com',
    status: 'active',
    createdAt: now,
    updatedAt: now,
  );
  await companies.create(company);
  return company;
}

Future<UserRecord> seedUser(
  UserRepository users,
  CompanyRecord company, {
  required String email,
  bool confirmed = true,
  List<String> roles = const ['admin'],
}) async {
  final now = DateTime.now().toUtc();
  final user = UserRecord(
    id: const Uuid().v4(),
    companyId: company.id,
    email: email,
    firstName: 'Test',
    lastName: 'User',
    salutation: 'Mr',
    title: null,
    telephoneNr: null,
    roles: roles,
    isActive: true,
    emailConfirmed: confirmed,
    lastLoginRole: roles.isNotEmpty ? roles.first : 'buyer',
    createdAt: now,
    updatedAt: now,
  );
  await users.create(user);
  return user;
}

TestAuthService createAuthService(UserRepository users) {
  final tokens = InMemoryTokenRepository();
  final clock = Clock();
  final email = EmailService(outboxPath: 'storage/test_outbox');
  return TestAuthService(users: users, tokens: tokens, email: email, clock: clock);
}

Future<void> seedSubscriptions(SubscriptionRepository repository) async {
  final seeder = SubscriptionSeeder(repository: repository, clock: Clock());
  await seeder.seedDefaults();
}
