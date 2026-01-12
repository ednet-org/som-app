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
    final companyType = companyTypeFromWire(companyJson['type'] as int? ?? 0);

    final address = Address.fromJson(
      (companyJson['address'] as Map<String, dynamic>? ?? {}),
    );

    final companyRecord = CompanyRecord(
      id: companyId,
      name: companyJson['name'] as String? ?? '',
      type: companyType,
      address: address,
      uidNr: companyJson['uidNr'] as String? ?? '',
      registrationNr: companyJson['registrationNr'] as String? ?? '',
      companySize: companySizeFromWire(companyJson['companySize'] as int? ?? 0),
      websiteUrl: companyJson['websiteUrl'] as String?,
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

    companies.create(companyRecord);

    if (companyType == 'provider') {
      final providerData = companyJson['providerData'] as Map<String, dynamic>?;
      final bankDetailsJson =
          providerData?['bankDetails'] as Map<String, dynamic>? ?? {};
      final branchIds = (providerData?['branchIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();

      final pendingBranchIds = <String>[];
      final confirmedBranchIds = <String>[];
      for (final branchId in branchIds) {
        final existing = branches.listBranches().any((b) => b.id == branchId);
        if (existing) {
          confirmedBranchIds.add(branchId);
        } else {
          pendingBranchIds.add(branchId);
        }
      }

      final subscriptionPlanId =
          providerData?['subscriptionPlanId'] as String? ?? '';
      final paymentInterval =
          paymentIntervalFromWire(providerData?['paymentInterval'] as int? ?? 0);

      providers.createProfile(
        ProviderProfileRecord(
          companyId: companyId,
          bankDetails: BankDetails.fromJson(bankDetailsJson),
          branchIds: confirmedBranchIds,
          pendingBranchIds: pendingBranchIds,
          subscriptionPlanId: subscriptionPlanId,
          paymentInterval: paymentInterval,
          status: pendingBranchIds.isEmpty ? 'active' : 'pending',
          createdAt: now,
          updatedAt: now,
        ),
      );

      if (subscriptionPlanId.isNotEmpty) {
        final startDate = DateTime.utc(now.year, now.month + 1, 1);
        final endDate = DateTime.utc(startDate.year + 1, startDate.month, 1)
            .subtract(const Duration(days: 1));
        subscriptions.createSubscription(
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

    final createdUsers = <UserRecord>[];
    for (final entry in usersJson) {
      final userJson = entry as Map<String, dynamic>;
      final roles = (userJson['roles'] as List<dynamic>? ?? [])
          .map((e) => roleFromWire(e as int? ?? 2))
          .toList();
      final user = UserRecord(
        id: const Uuid().v4(),
        companyId: companyId,
        email: (userJson['email'] as String? ?? '').toLowerCase(),
        firstName: userJson['firstName'] as String? ?? '',
        lastName: userJson['lastName'] as String? ?? '',
        salutation: userJson['salutation'] as String? ?? '',
        title: userJson['title'] as String?,
        telephoneNr: userJson['telephoneNr'] as String?,
        roles: roles.isEmpty ? ['buyer'] : roles,
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
      _ensureUniqueEmail(user.email);
      users.create(user);
      createdUsers.add(user);
    }

    final adminExists = createdUsers.any((user) => user.roles.contains('admin'));
    if (!adminExists) {
      throw RegistrationException('Admin user is required');
    }

    for (final user in createdUsers) {
      await auth.createRegistrationToken(user);
    }

    return companyRecord;
  }

  void _ensureUniqueEmail(String email) {
    final existing = users.findByEmail(email);
    if (existing != null) {
      throw RegistrationException('E-mail already used.');
    }
  }
}

class RegistrationException implements Exception {
  RegistrationException(this.message);
  final String message;
  @override
  String toString() => message;
}
