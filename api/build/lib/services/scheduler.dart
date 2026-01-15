import 'dart:async';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/token_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import 'auth_service.dart';
import 'email_service.dart';
import 'notification_service.dart';

class Scheduler {
  Scheduler({
    required this.tokens,
    required this.users,
    required this.auth,
    required this.email,
    required this.notifications,
    required this.clock,
  });

  final TokenRepository tokens;
  final UserRepository users;
  final AuthService auth;
  final EmailService email;
  final NotificationService notifications;
  final Clock clock;

  Timer? _timer;

  void start() {
    _timer ??= Timer.periodic(const Duration(hours: 12), (_) => _run());
  }

  Future<void> _run() async {
    await _sendExpiryReminders();
    await _deleteExpiredInactiveUsers();
    await notifications.notifyBuyersForOfferCountOrDeadline();
    await notifications.notifyProvidersForExpiredAds();
  }

  Future<void> _sendExpiryReminders() async {
    final remindAt = clock.nowUtc().add(const Duration(days: 3));
    final expiring = await tokens.findExpiringSoon('confirm_email', remindAt);
    for (final token in expiring) {
      final user = await users.findById(token.userId);
      if (user == null || user.emailConfirmed) {
        continue;
      }
      await email.send(
        to: user.email,
        subject: 'Your SOM registration link is expiring soon',
        text:
            'Your registration link will expire on ${token.expiresAt.toIso8601String()}. Please complete your registration.',
      );
      final admins = await users.listAdminsByCompany(user.companyId);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'User registration link expiring',
          text:
              'User ${user.email} has a registration link expiring on ${token.expiresAt.toIso8601String()}.',
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
