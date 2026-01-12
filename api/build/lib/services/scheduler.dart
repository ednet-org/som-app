import 'dart:async';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/token_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import 'email_service.dart';
import 'notification_service.dart';

class Scheduler {
  Scheduler({
    required this.tokens,
    required this.users,
    required this.email,
    required this.notifications,
    required this.clock,
  });

  final TokenRepository tokens;
  final UserRepository users;
  final EmailService email;
  final NotificationService notifications;
  final Clock clock;

  Timer? _timer;

  void start() {
    _timer ??= Timer.periodic(const Duration(hours: 12), (_) => _run());
  }

  Future<void> _run() async {
    await _sendExpiryReminders();
    _deleteExpiredInactiveUsers();
    await notifications.notifyBuyersForOfferCountOrDeadline();
  }

  Future<void> _sendExpiryReminders() async {
    final remindAt = clock.nowUtc().add(const Duration(days: 3));
    final expiring = tokens.findExpiringSoon('confirm_email', remindAt);
    for (final token in expiring) {
      final user = users.findById(token.userId);
      if (user == null || user.emailConfirmed) {
        continue;
      }
      await email.send(
        to: user.email,
        subject: 'Your SOM registration link is expiring soon',
        text:
            'Your registration link will expire on ${token.expiresAt.toIso8601String()}. Please complete your registration.',
      );
      final admins = users.listAdminsByCompany(user.companyId);
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

  void _deleteExpiredInactiveUsers() {
    final now = clock.nowUtc();
    final expired = tokens.findExpiringSoon('confirm_email', now);
    for (final token in expired) {
      final user = users.findById(token.userId);
      if (user == null) {
        continue;
      }
      if (!user.emailConfirmed) {
        users.deleteById(user.id);
      }
      tokens.markUsed(token.id, now);
    }
    tokens.deleteExpired(now);
  }
}
