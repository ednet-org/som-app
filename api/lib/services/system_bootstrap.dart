import 'package:uuid/uuid.dart';

import '../infrastructure/repositories/company_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import '../models/models.dart';
import 'auth_service.dart';

class SystemBootstrap {
  SystemBootstrap({
    required this.companies,
    required this.users,
    required this.auth,
  });

  final CompanyRepository companies;
  final UserRepository users;
  final AuthService auth;

  void ensureSystemAdmin() {
    final email = const String.fromEnvironment(
      'SYSTEM_ADMIN_EMAIL',
      defaultValue: 'system-admin@som.local',
    ).toLowerCase();
    final password = const String.fromEnvironment(
      'SYSTEM_ADMIN_PASSWORD',
      defaultValue: 'ChangeMe123!',
    );
    final existing = users.findByEmail(email);
    if (existing != null) {
      return;
    }
    final systemCompany = _ensureSystemCompany();
    final now = DateTime.now().toUtc();
    final user = UserRecord(
      id: const Uuid().v4(),
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
      passwordHash: auth.hashPassword(password),
    );
    users.create(user);
  }

  CompanyRecord _ensureSystemCompany() {
    final existing = companies.findByRegistrationNr('SYSTEM');
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
    companies.create(company);
    return company;
  }
}
