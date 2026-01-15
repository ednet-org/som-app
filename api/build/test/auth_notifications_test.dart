import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/services/auth_service.dart';
import 'test_utils.dart';

void main() {
  group('Auth notification emails', () {
    test('sends welcome email on activation and records event', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final tokens = InMemoryTokenRepository();
      final emailEvents = InMemoryEmailEventRepository();
      final email = TestEmailService();
      final auth = TestAuthService(
        users: users,
        tokens: tokens,
        email: email,
        emailEvents: emailEvents,
        clock: Clock(),
      );

      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'new-user@som.local',
        confirmed: false,
        roles: const ['buyer'],
      );

      final token = await auth.createRegistrationToken(user);
      await auth.resetPassword(
        emailAddress: user.email,
        token: token,
        password: 'NewPass123!',
        confirmPassword: 'NewPass123!',
      );

      expect(
        email.sent.any((message) => message.subject == 'Welcome to SOM'),
        isTrue,
      );
      final events = await emailEvents.listByUser(user.id);
      expect(events.any((event) => event.type == 'welcome'), isTrue);
    });

    test('sends password change notification and records event', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final tokens = InMemoryTokenRepository();
      final emailEvents = InMemoryEmailEventRepository();
      final email = TestEmailService();
      final auth = TestAuthService(
        users: users,
        tokens: tokens,
        email: email,
        emailEvents: emailEvents,
        clock: Clock(),
      );

      final company = await seedCompany(companies);
      final user = await seedUser(
        users,
        company,
        email: 'user@som.local',
        confirmed: true,
        roles: const ['buyer'],
      );
      auth.setPassword(user.email, 'OldPass123!');

      await auth.changePassword(
        userId: user.id,
        emailAddress: user.email,
        currentPassword: 'OldPass123!',
        newPassword: 'NewPass123!',
        confirmPassword: 'NewPass123!',
      );

      expect(
        email.sent.any(
            (message) => message.subject == 'Your SOM password was changed'),
        isTrue,
      );
      final events = await emailEvents.listByUser(user.id);
      expect(events.any((event) => event.type == 'password_changed'), isTrue);
    });
  });
}
