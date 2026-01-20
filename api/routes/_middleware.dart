import 'package:dart_frog/dart_frog.dart';

import 'dart:async';

import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/billing_repository.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/cancellation_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/company_taxonomy_repository.dart';
import 'package:som_api/infrastructure/repositories/domain_event_repository.dart';
import 'package:som_api/infrastructure/repositories/audit_log_repository.dart';
import 'package:som_api/infrastructure/repositories/email_event_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/role_repository.dart';
import 'package:som_api/infrastructure/repositories/product_repository.dart';
import 'package:som_api/infrastructure/repositories/schema_version_repository.dart';
import 'package:som_api/infrastructure/repositories/scheduler_status_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/infrastructure/supabase_service.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/cors_middleware.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/pdf_generator.dart';
import 'package:som_api/services/rate_limit_middleware.dart';
import 'package:som_api/services/registration_service.dart';
import 'package:som_api/services/role_seed.dart';
import 'package:som_api/services/scheduler.dart';
import 'package:som_api/services/schema_version_service.dart';
import 'package:som_api/services/security_headers.dart';
import 'package:som_api/services/statistics_service.dart';
import 'package:som_api/services/subscription_seed.dart';
import 'package:som_api/services/system_bootstrap.dart';

final _supabase = SupabaseService.fromEnvironment();
final _clock = Clock();
final _email = EmailService.fromEnvironment();
final _users = UserRepository(_supabase.adminClient);
final _emailEvents = EmailEventRepository(_supabase.adminClient);
final _roles = RoleRepository(_supabase.adminClient);
final _tokens = TokenRepository(_supabase.adminClient);
final _companies = CompanyRepository(_supabase.adminClient);
final _companyTaxonomy = CompanyTaxonomyRepository(_supabase.adminClient);
final _branches = BranchRepository(_supabase.adminClient);
final _subscriptions = SubscriptionRepository(_supabase.adminClient);
final _providers = ProviderRepository(_supabase.adminClient);
final _products = ProductRepository(_supabase.adminClient);
final _inquiries = InquiryRepository(_supabase.adminClient);
final _offers = OfferRepository(_supabase.adminClient);
final _ads = AdsRepository(_supabase.adminClient);
final _billing = BillingRepository(_supabase.adminClient);
final _cancellations = CancellationRepository(_supabase.adminClient);
final _domainEvents = DomainEventRepository(_supabase.adminClient);
final _auditLog = AuditLogRepository(_supabase.adminClient);
final _schemaVersions = SchemaVersionRepository(_supabase.adminClient);
final _schedulerStatus = SchedulerStatusRepository(_supabase.adminClient);
final _storage =
    FileStorage(client: _supabase.adminClient, bucket: _supabase.storageBucket);
final _pdfGenerator = PdfGenerator();
final _notifications = NotificationService(
  ads: _ads,
  users: _users,
  companies: _companies,
  providers: _providers,
  inquiries: _inquiries,
  offers: _offers,
  email: _email,
);
final _domainEventService = DomainEventService(
  repository: _domainEvents,
  notifications: _notifications,
  companies: _companies,
  inquiries: _inquiries,
);
final _auditService = AuditService(repository: _auditLog);
final _schemaVersionService = SchemaVersionService(repository: _schemaVersions);
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
  companyTaxonomy: _companyTaxonomy,
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
  statusRepository: _schedulerStatus,
);
final _rateLimiter = RateLimiter(clock: _clock);
final _rateLimitPolicy = RateLimitPolicy.fromEnvironment();
final _subscriptionSeeder = SubscriptionSeeder(
  repository: _subscriptions,
  clock: _clock,
);
final _roleSeeder = RoleSeeder(
  repository: _roles,
  clock: _clock,
);
final _statistics = StatisticsService(_supabase.adminClient);
final _systemBootstrap = SystemBootstrap(
  companies: _companies,
  users: _users,
  auth: _auth,
  branches: _branches,
  providers: _providers,
  companyTaxonomy: _companyTaxonomy,
  subscriptions: _subscriptions,
  inquiries: _inquiries,
  offers: _offers,
  ads: _ads,
);
final _bootstrapFuture = _bootstrap();

Future<void> _bootstrap() async {
  await _roleSeeder.seedDefaults();
  await _subscriptionSeeder.seedDefaults();
  await _systemBootstrap.ensureSystemAdmin();
  await _systemBootstrap.ensureDevFixtures();
  const enableScheduler =
      bool.fromEnvironment('ENABLE_SCHEDULER', defaultValue: false);
  if (enableScheduler) {
    _scheduler.start();
  }
}

Handler middleware(Handler handler) {
  final baseHandler = ((context) async {
    await _bootstrapFuture;
    await _schemaVersionService.ensureVersion();
    return handler(context);
  })
      .use(provider<SupabaseService>((_) => _supabase))
      .use(provider<Clock>((_) => _clock))
      .use(provider<EmailService>((_) => _email))
      .use(provider<UserRepository>((_) => _users))
      .use(provider<EmailEventRepository>((_) => _emailEvents))
      .use(provider<RoleRepository>((_) => _roles))
      .use(provider<TokenRepository>((_) => _tokens))
      .use(provider<CompanyRepository>((_) => _companies))
      .use(provider<CompanyTaxonomyRepository>((_) => _companyTaxonomy))
      .use(provider<BranchRepository>((_) => _branches))
      .use(provider<SubscriptionRepository>((_) => _subscriptions))
      .use(provider<ProviderRepository>((_) => _providers))
      .use(provider<ProductRepository>((_) => _products))
      .use(provider<InquiryRepository>((_) => _inquiries))
      .use(provider<OfferRepository>((_) => _offers))
      .use(provider<AdsRepository>((_) => _ads))
      .use(provider<BillingRepository>((_) => _billing))
      .use(provider<CancellationRepository>((_) => _cancellations))
      .use(provider<DomainEventRepository>((_) => _domainEvents))
      .use(provider<AuditLogRepository>((_) => _auditLog))
      .use(provider<SchemaVersionRepository>((_) => _schemaVersions))
      .use(provider<SchedulerStatusRepository>((_) => _schedulerStatus))
      .use(provider<FileStorage>((_) => _storage))
      .use(provider<PdfGenerator>((_) => _pdfGenerator))
      .use(provider<NotificationService>((_) => _notifications))
      .use(provider<DomainEventService>((_) => _domainEventService))
      .use(provider<AuditService>((_) => _auditService))
      .use(provider<SchemaVersionService>((_) => _schemaVersionService))
      .use(provider<AuthService>((_) => _auth))
      .use(provider<RegistrationService>((_) => _registration))
      .use(provider<SomDomainModel>((_) => _domain))
      .use(provider<StatisticsService>((_) => _statistics));

  return baseHandler
      .use(rateLimitMiddleware(
        limiter: _rateLimiter,
        policy: _rateLimitPolicy,
      ))
      .use(securityHeaders())
      .use(corsHeaders());
}
