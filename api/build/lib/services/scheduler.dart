import 'dart:async';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/scheduler_status_repository.dart';
import '../infrastructure/repositories/token_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import 'auth_service.dart';
import 'email_service.dart';
import 'email_templates.dart';
import 'notification_service.dart';

class Scheduler {
  Scheduler({
    required this.tokens,
    required this.users,
    required this.auth,
    required this.email,
    required this.notifications,
    required this.clock,
    this.statusRepository,
  });

  final TokenRepository tokens;
  final UserRepository users;
  final AuthService auth;
  final EmailService email;
  final NotificationService notifications;
  final Clock clock;
  final SchedulerStatusRepository? statusRepository;

  Timer? _timer;
  bool _running = false;

  void start({Duration interval = const Duration(hours: 12)}) {
    _timer ??= Timer.periodic(interval, (_) => _run());
  }

  Future<void> runOnce() async {
    await _run();
  }

  Future<void> _run() async {
    if (_running) {
      return;
    }
    _running = true;
    try {
      await _runJob(
        'registration.expiry_reminder',
        _sendExpiryReminders,
      );
      await _runJob(
        'registration.cleanup',
        _deleteExpiredInactiveUsers,
      );
      await _runJob(
        'inquiry.offer_notifications',
        notifications.notifyBuyersForOfferCountOrDeadline,
      );
      await _runJob(
        'inquiry.deadline_reminders',
        notifications.notifyProvidersOfUpcomingDeadlines,
      );
      await _runJob(
        'ads.expiry',
        notifications.notifyProvidersForExpiredAds,
      );
    } finally {
      _running = false;
    }
  }

  Future<void> _runJob(
    String name,
    Future<void> Function() job,
  ) async {
    final startedAt = clock.nowUtc();
    try {
      await job();
      await statusRepository?.recordRun(
        jobName: name,
        runAt: startedAt,
        success: true,
      );
    } catch (error) {
      await statusRepository?.recordRun(
        jobName: name,
        runAt: startedAt,
        success: false,
        error: error.toString(),
      );
    }
  }

  Future<void> _sendExpiryReminders() async {
    final remindAt = clock.nowUtc().add(const Duration(days: 3));
    final expiring = await tokens.findExpiringSoon('confirm_email', remindAt);
    for (final token in expiring) {
      final user = await users.findById(token.userId);
      if (user == null || user.emailConfirmed) {
        continue;
      }
      await email.sendTemplate(
        to: user.email,
        templateId: EmailTemplateId.userRegistrationExpiring,
        variables: {'expiresAt': token.expiresAt.toIso8601String()},
      );
      final admins = await users.listAdminsByCompany(user.companyId);
      for (final admin in admins) {
        await email.sendTemplate(
          to: admin.email,
          templateId: EmailTemplateId.adminUserRegistrationExpiring,
          variables: {
            'userEmail': user.email,
            'expiresAt': token.expiresAt.toIso8601String(),
          },
        );
      }
    }
  }

  Future<void> _deleteExpiredInactiveUsers() async {
    final now = clock.nowUtc();
    final expired = await tokens.findExpiringSoon('confirm_email', now);
    for (final token in expired) {
      final user = await users.findById(token.userId);
      if (user == null) {
        continue;
      }
      if (!user.emailConfirmed) {
        await auth.deleteAuthUser(user.id);
        await users.deleteById(user.id);
      }
      await tokens.markUsed(token.id, now);
    }
    await tokens.deleteExpired(now);
  }
}
