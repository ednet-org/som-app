import 'dart:async';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/email_event_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/scheduler_status_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/infrastructure/supabase_service.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/notification_service.dart';
import 'package:som_api/services/scheduler.dart';

Future<void> main() async {
  final supabase = SupabaseService.fromEnvironment();
  final clock = Clock();
  final email = EmailService.fromEnvironment();
  final users = UserRepository(supabase.adminClient);
  final tokens = TokenRepository(supabase.adminClient);
  final emailEvents = EmailEventRepository(supabase.adminClient);
  final auth = AuthService(
    users: users,
    tokens: tokens,
    email: email,
    emailEvents: emailEvents,
    clock: clock,
    adminClient: supabase.adminClient,
    anonClient: supabase.anonClient,
  );

  final notifications = NotificationService(
    ads: AdsRepository(supabase.adminClient),
    users: users,
    companies: CompanyRepository(supabase.adminClient),
    providers: ProviderRepository(supabase.adminClient),
    inquiries: InquiryRepository(supabase.adminClient),
    offers: OfferRepository(supabase.adminClient),
    email: email,
  );

  final scheduler = Scheduler(
    tokens: tokens,
    users: users,
    auth: auth,
    email: email,
    notifications: notifications,
    clock: clock,
    statusRepository: SchedulerStatusRepository(supabase.adminClient),
  );

  const intervalMinutes = int.fromEnvironment(
    'SCHEDULER_INTERVAL_MINUTES',
    defaultValue: 720,
  );
  const runOnce = bool.fromEnvironment(
    'SCHEDULER_RUN_ONCE',
    defaultValue: false,
  );

  if (runOnce) {
    await scheduler.runOnce();
    return;
  }

  scheduler.start(interval: Duration(minutes: intervalMinutes));
  await Completer<void>().future;
}
