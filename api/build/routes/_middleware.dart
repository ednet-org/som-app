import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/db.dart';
import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/cors_middleware.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/registration_service.dart';
import 'package:som_api/services/scheduler.dart';
import 'package:som_api/services/subscription_seed.dart';
import 'package:som_api/services/statistics_service.dart';
import 'package:som_api/services/system_bootstrap.dart';
import 'package:som_api/domain/som_domain.dart';

final _db = Database.open();
final _clock = Clock();
final _email = EmailService();
final _users = UserRepository(_db);
final _tokens = TokenRepository(_db);
final _companies = CompanyRepository(_db);
final _branches = BranchRepository(_db);
final _subscriptions = SubscriptionRepository(_db);
final _providers = ProviderRepository(_db);
final _inquiries = InquiryRepository(_db);
final _offers = OfferRepository(_db);
final _ads = AdsRepository(_db);
final _storage = FileStorage();
final _notifications = NotificationService(
  inquiries: _inquiries,
  offers: _offers,
  email: _email,
);
final _auth = AuthService(
  users: _users,
  tokens: _tokens,
  email: _email,
  clock: _clock,
  jwtSecret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
);
final _domain = SomDomainModel();
final _registration = RegistrationService(
  companies: _companies,
  users: _users,
  providers: _providers,
  subscriptions: _subscriptions,
  branches: _branches,
  auth: _auth,
  clock: _clock,
  domain: _domain,
);
final _scheduler = Scheduler(
  tokens: _tokens,
  users: _users,
  email: _email,
  notifications: _notifications,
  clock: _clock,
);
final _subscriptionSeeder = SubscriptionSeeder(
  repository: _subscriptions,
  clock: _clock,
);
final _statistics = StatisticsService(_db);
final _systemBootstrap = SystemBootstrap(
  companies: _companies,
  users: _users,
  auth: _auth,
);

Handler middleware(Handler handler) {
  _subscriptionSeeder.seedDefaults();
  _systemBootstrap.ensureSystemAdmin();
  _scheduler.start();
  return handler
      .use(corsHeaders())
      .use(provider<Database>((_) => _db))
      .use(provider<Clock>((_) => _clock))
      .use(provider<EmailService>((_) => _email))
      .use(provider<UserRepository>((_) => _users))
      .use(provider<TokenRepository>((_) => _tokens))
      .use(provider<CompanyRepository>((_) => _companies))
      .use(provider<BranchRepository>((_) => _branches))
      .use(provider<SubscriptionRepository>((_) => _subscriptions))
      .use(provider<ProviderRepository>((_) => _providers))
      .use(provider<InquiryRepository>((_) => _inquiries))
      .use(provider<OfferRepository>((_) => _offers))
      .use(provider<AdsRepository>((_) => _ads))
      .use(provider<FileStorage>((_) => _storage))
      .use(provider<AuthService>((_) => _auth))
      .use(provider<RegistrationService>((_) => _registration))
      .use(provider<SomDomainModel>((_) => _domain))
      .use(provider<StatisticsService>((_) => _statistics));
}
