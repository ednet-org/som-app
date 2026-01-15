import 'package:dart_frog/dart_frog.dart';

import 'dart:async';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/billing_repository.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/cancellation_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/email_event_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/infrastructure/supabase_service.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/cors_middleware.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/registration_service.dart';
import 'package:som_api/services/scheduler.dart';
import 'package:som_api/services/statistics_service.dart';
import 'package:som_api/services/subscription_seed.dart';
import 'package:som_api/services/system_bootstrap.dart';

final _supabase = SupabaseService.fromEnvironment();
final _clock = Clock();
final _email = EmailService();
final _users = UserRepository(_supabase.adminClient);
final _emailEvents = EmailEventRepository(_supabase.adminClient);
final _tokens = TokenRepository(_supabase.adminClient);
final _companies = CompanyRepository(_supabase.adminClient);
final _branches = BranchRepository(_supabase.adminClient);
final _subscriptions = SubscriptionRepository(_supabase.adminClient);
final _providers = ProviderRepository(_supabase.adminClient);
final _inquiries = InquiryRepository(_supabase.adminClient);
final _offers = OfferRepository(_supabase.adminClient);
final _ads = AdsRepository(_supabase.adminClient);
final _billing = BillingRepository(_supabase.adminClient);
final _cancellations = CancellationRepository(_supabase.adminClient);
final _storage =
    FileStorage(client: _supabase.adminClient, bucket: _supabase.storageBucket);
final _notifications = NotificationService(
  ads: _ads,
  users: _users,
  companies: _companies,
  inquiries: _inquiries,
  offers: _offers,
  email: _email,
);
final _auth = AuthService(
  users: _users,
  tokens: _tokens,
  email: _email,
  emailEvents: _emailEvents,
  clock: _clock,
  adminClient: _supabase.adminClient,
  anonClient: _supabase.anonClient,
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
  auth: _auth,
  email: _email,
  notifications: _notifications,
  clock: _clock,
);
final _subscriptionSeeder = SubscriptionSeeder(
  repository: _subscriptions,
  clock: _clock,
);
final _statistics = StatisticsService(_supabase.adminClient);
final _systemBootstrap = SystemBootstrap(
  companies: _companies,
  users: _users,
  auth: _auth,
  branches: _branches,
  providers: _providers,
  subscriptions: _subscriptions,
  inquiries: _inquiries,
  offers: _offers,
  ads: _ads,
);
final _bootstrapFuture = _bootstrap();

Future<void> _bootstrap() async {
  await _subscriptionSeeder.seedDefaults();
  await _systemBootstrap.ensureSystemAdmin();
  await _systemBootstrap.ensureDevFixtures();
  _scheduler.start();
}

Handler middleware(Handler handler) {
  return ((context) async {
    await _bootstrapFuture;
    return handler(context);
  })
      .use(corsHeaders())
      .use(provider<SupabaseService>((_) => _supabase))
      .use(provider<Clock>((_) => _clock))
      .use(provider<EmailService>((_) => _email))
      .use(provider<UserRepository>((_) => _users))
      .use(provider<EmailEventRepository>((_) => _emailEvents))
      .use(provider<TokenRepository>((_) => _tokens))
      .use(provider<CompanyRepository>((_) => _companies))
      .use(provider<BranchRepository>((_) => _branches))
      .use(provider<SubscriptionRepository>((_) => _subscriptions))
      .use(provider<ProviderRepository>((_) => _providers))
      .use(provider<InquiryRepository>((_) => _inquiries))
      .use(provider<OfferRepository>((_) => _offers))
      .use(provider<AdsRepository>((_) => _ads))
      .use(provider<BillingRepository>((_) => _billing))
      .use(provider<CancellationRepository>((_) => _cancellations))
      .use(provider<FileStorage>((_) => _storage))
      .use(provider<NotificationService>((_) => _notifications))
      .use(provider<AuthService>((_) => _auth))
      .use(provider<RegistrationService>((_) => _registration))
      .use(provider<SomDomainModel>((_) => _domain))
      .use(provider<StatisticsService>((_) => _statistics));
}
