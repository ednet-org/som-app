import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/db.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/subscription_seed.dart';

Database createTestDb() => Database.open(path: ':memory:', forTesting: true);

CompanyRecord seedCompany(Database db, {String type = 'buyer'}) {
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
  CompanyRepository(db).create(company);
  return company;
}

UserRecord seedUser(Database db, CompanyRecord company,
    {required String email, required String passwordHash, bool confirmed = true}) {
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
    roles: const ['admin'],
    isActive: true,
    emailConfirmed: confirmed,
    lastLoginRole: 'admin',
    createdAt: now,
    updatedAt: now,
    passwordHash: passwordHash,
  );
  UserRepository(db).create(user);
  return user;
}

AuthService createAuthService(Database db) {
  final users = UserRepository(db);
  final tokens = TokenRepository(db);
  final clock = Clock();
  final email = EmailService(outboxPath: 'storage/test_outbox');
  return AuthService(users: users, tokens: tokens, email: email, clock: clock);
}

void seedSubscriptions(Database db) {
  final repo = SubscriptionRepository(db);
  final seeder = SubscriptionSeeder(repository: repo, clock: Clock());
  seeder.seedDefaults();
}
