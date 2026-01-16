import 'package:uuid/uuid.dart';
import 'package:ednet_core/ednet_core.dart' show EDNetException;

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/branch_repository.dart';
import '../infrastructure/repositories/company_repository.dart';
import '../infrastructure/repositories/provider_repository.dart';
import '../infrastructure/repositories/subscription_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import '../models/models.dart';
import 'auth_service.dart';
import '../domain/som_domain.dart';
import 'mappings.dart';

class RegistrationService {
  RegistrationService({
    required this.companies,
    required this.users,
    required this.providers,
    required this.subscriptions,
    required this.branches,
    required this.auth,
    required this.clock,
    required this.domain,
  });

  final CompanyRepository companies;
  final UserRepository users;
  final ProviderRepository providers;
  final SubscriptionRepository subscriptions;
  final BranchRepository branches;
  final AuthService auth;
  final Clock clock;
  final SomDomainModel domain;

  Future<CompanyRecord> registerCompany({
    required Map<String, dynamic> companyJson,
    required List<dynamic> usersJson,
    bool allowIncomplete = false,
  }) async {
    final companyId = const Uuid().v4();
    final now = clock.nowUtc();
    final rawType = companyJson['type'];
    final parsedType = rawType is int
        ? rawType
        : int.tryParse(rawType?.toString() ?? '');
    if (parsedType == null || parsedType < 0 || parsedType > 2) {
      throw RegistrationException('Company type is required.');
    }
    final companyType = companyTypeFromWire(parsedType);
    final termsAccepted = companyJson['termsAccepted'] == true;
    final privacyAccepted = companyJson['privacyAccepted'] == true;

    final address = Address.fromJson(
      (companyJson['address'] as Map<String, dynamic>? ?? {}),
    );

    final websiteUrl = companyJson['websiteUrl'] as String?;
    if (websiteUrl != null && websiteUrl.isNotEmpty) {
      final parsed = Uri.tryParse(websiteUrl);
      final validScheme = parsed != null &&
          (parsed.scheme == 'http' || parsed.scheme == 'https') &&
          parsed.hasAuthority;
      if (!validScheme && !allowIncomplete) {
        throw RegistrationException('Website URL must be a valid URL.');
      }
    }

    if (!allowIncomplete && (!termsAccepted || !privacyAccepted)) {
      throw RegistrationException('Terms and privacy policy must be accepted.');
    }

    final companyRecord = CompanyRecord(
      id: companyId,
      name: companyJson['name'] as String? ?? '',
      type: companyType,
      address: address,
      uidNr: companyJson['uidNr'] as String? ?? '',
      registrationNr: companyJson['registrationNr'] as String? ?? '',
      companySize: companySizeFromWire(companyJson['companySize'] as int? ?? 0),
      websiteUrl: websiteUrl,
      termsAcceptedAt: termsAccepted ? now : null,
      privacyAcceptedAt: privacyAccepted ? now : null,
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );

    final companyEntity = domain.newCompany()
      ..setAttribute('name', companyRecord.name)
      ..setAttribute('address', companyRecord.address.toJson())
      ..setAttribute('uidNr', companyRecord.uidNr)
      ..setAttribute('registrationNr', companyRecord.registrationNr)
      ..setAttribute('companySize', companyRecord.companySize)
      ..setAttribute('type', companyRecord.type);
    if (!allowIncomplete) {
      try {
        companyEntity.validateRequired();
      } on EDNetException catch (error) {
        throw RegistrationException(error.message);
      }
    }

    await companies.create(companyRecord);

    int? maxUsers;
    if (companyType == 'provider' || companyType == 'buyer_provider') {
      final providerData = companyJson['providerData'] as Map<String, dynamic>?;
      if (!allowIncomplete && providerData == null) {
        throw RegistrationException('Provider registration data is required.');
      }
      final bankDetailsJson =
          providerData?['bankDetails'] as Map<String, dynamic>? ?? {};
      final branchIds = (providerData?['branchIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();
      final providerType = providerData?['providerType'] as String?;

      if (!allowIncomplete) {
        final iban = bankDetailsJson['iban'] as String? ?? '';
        final bic = bankDetailsJson['bic'] as String? ?? '';
        final owner = bankDetailsJson['accountOwner'] as String? ?? '';
        if (iban.isEmpty || bic.isEmpty || owner.isEmpty) {
          throw RegistrationException('Bank details are required.');
        }
        if (branchIds.isEmpty) {
          throw RegistrationException('At least one branch is required.');
        }
        if (providerType == null || providerType.isEmpty) {
          throw RegistrationException('Provider type is required.');
        }
      }

      final existingBranches = await branches.listBranches();
      final pendingBranchIds = <String>[];
      final confirmedBranchIds = <String>[];
      for (final branchId in branchIds) {
        final existing = existingBranches.any((b) => b.id == branchId);
        if (existing) {
          confirmedBranchIds.add(branchId);
        } else {
          pendingBranchIds.add(branchId);
        }
      }

      final subscriptionPlanId =
          providerData?['subscriptionPlanId'] as String? ?? '';
      final paymentInterval = paymentIntervalFromWire(
          providerData?['paymentInterval'] as int? ?? 0);
      if (!allowIncomplete && subscriptionPlanId.isEmpty) {
        throw RegistrationException('Subscription plan is required.');
      }
      if (subscriptionPlanId.isNotEmpty) {
        final plan = await subscriptions.findPlanById(subscriptionPlanId);
        if (plan == null && !allowIncomplete) {
          throw RegistrationException('Subscription plan not found.');
        }
        if (plan != null) {
          maxUsers = _maxUsersForPlan(plan);
        }
      }

      await providers.createProfile(
        ProviderProfileRecord(
          companyId: companyId,
          bankDetails: BankDetails.fromJson(bankDetailsJson),
          branchIds: confirmedBranchIds,
          pendingBranchIds: pendingBranchIds,
          subscriptionPlanId: subscriptionPlanId,
          paymentInterval: paymentInterval,
          providerType: providerType,
          status: pendingBranchIds.isEmpty ? 'active' : 'pending',
          rejectionReason: null,
          rejectedAt: null,
          createdAt: now,
          updatedAt: now,
        ),
      );

      if (subscriptionPlanId.isNotEmpty) {
        final startDate = DateTime.utc(now.year, now.month + 1, 1);
        final endDate = DateTime.utc(startDate.year + 1, startDate.month, 1)
            .subtract(const Duration(days: 1));
        await subscriptions.createSubscription(
          SubscriptionRecord(
            id: const Uuid().v4(),
            companyId: companyId,
            planId: subscriptionPlanId,
            status: 'active',
            paymentInterval: paymentInterval,
            startDate: startDate,
            endDate: endDate,
            createdAt: now,
          ),
        );
      }
    }

    if (maxUsers != null && maxUsers > 0 && usersJson.length > maxUsers) {
      throw RegistrationException('User limit exceeded for subscription plan.');
    }

    final createdUsers = <UserRecord>[];
    for (final entry in usersJson) {
      final userJson = entry as Map<String, dynamic>;
      final roles = (userJson['roles'] as List<dynamic>? ?? [])
          .map((e) => roleFromWire(e as int? ?? 2))
          .toList();
      final normalizedRoles = _ensureBaseRoles(
        roles: roles,
        companyType: companyType,
      );
      final email = (userJson['email'] as String? ?? '').toLowerCase();
      await _ensureUniqueEmail(email);
      late final String authUserId;
      try {
        authUserId = await auth.ensureAuthUser(email: email);
      } on AuthException catch (error) {
        throw RegistrationException(error.message);
      }
      final user = UserRecord(
        id: authUserId,
        companyId: companyId,
        email: email,
        firstName: userJson['firstName'] as String? ?? '',
        lastName: userJson['lastName'] as String? ?? '',
        salutation: userJson['salutation'] as String? ?? '',
        title: userJson['title'] as String?,
        telephoneNr: userJson['telephoneNr'] as String?,
        roles: normalizedRoles.isEmpty ? ['buyer'] : normalizedRoles,
        isActive: true,
        emailConfirmed: false,
        lastLoginRole: null,
        createdAt: now,
        updatedAt: now,
      );
      final userEntity = domain.newUser()
        ..setAttribute('email', user.email)
        ..setAttribute('firstName', user.firstName)
        ..setAttribute('lastName', user.lastName)
        ..setAttribute('salutation', user.salutation)
        ..setAttribute('roles', user.roles);
      if (!allowIncomplete) {
        try {
          userEntity.validateRequired();
        } on EDNetException catch (error) {
          throw RegistrationException(error.message);
        }
      }
      await users.create(user);
      createdUsers.add(user);
    }

    final adminExists =
        createdUsers.any((user) => user.roles.contains('admin'));
    if (!adminExists) {
      throw RegistrationException('Admin user is required');
    }

    for (final user in createdUsers) {
      await auth.createRegistrationToken(user);
    }

    return companyRecord;
  }

  Future<void> _ensureUniqueEmail(String email) async {
    if (email.isEmpty) {
      throw RegistrationException('E-mail is required.');
    }
    final existing = await users.findByEmail(email);
    if (existing != null) {
      throw RegistrationException('E-mail already used.');
    }
  }

  List<String> _ensureBaseRoles({
    required List<String> roles,
    required String companyType,
  }) {
    final normalized = <String>{...roles};
    if (normalized.contains('admin')) {
      if (companyType == 'buyer' || companyType == 'buyer_provider') {
        normalized.add('buyer');
      }
      if (companyType == 'provider' || companyType == 'buyer_provider') {
        normalized.add('provider');
      }
    }
    final ordered = <String>[];
    if (normalized.contains('buyer')) {
      ordered.add('buyer');
    }
    if (normalized.contains('provider')) {
      ordered.add('provider');
    }
    if (normalized.contains('consultant')) {
      ordered.add('consultant');
    }
    if (normalized.contains('admin')) {
      ordered.add('admin');
    }
    for (final role in normalized) {
      if (!ordered.contains(role)) {
        ordered.add(role);
      }
    }
    return ordered;
  }

  int? _maxUsersForPlan(SubscriptionPlanRecord plan) {
    if (plan.maxUsers != null && plan.maxUsers! > 0) {
      return plan.maxUsers;
    }
    for (final rule in plan.rules) {
      if ((rule['restriction'] as int? ?? -1) == 0) {
        final limit = rule['upperLimit'] as int? ?? 0;
        return limit > 0 ? limit : null;
      }
    }
    return null;
  }
}

class RegistrationException implements Exception {
  RegistrationException(this.message);
  final String message;
  @override
  String toString() => message;
}
