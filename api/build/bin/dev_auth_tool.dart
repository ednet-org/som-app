import 'dart:io';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/email_event_repository.dart';
import 'package:som_api/infrastructure/repositories/token_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/infrastructure/supabase_service.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/email_service.dart';

void _printUsage() {
  stderr.writeln('Usage: dart run api/bin/dev_auth_tool.dart <command> <email> [password]');
  stderr.writeln('Commands: confirm_email | reset_password | set_password');
}

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    _printUsage();
    exit(64);
  }
  final command = args[0];
  final email = args[1].trim().toLowerCase();
  final password = args.length > 2 ? args[2] : 'DevPass123!';

  final supabase = SupabaseService.fromEnvironment();
  final users = UserRepository(supabase.adminClient);
  final tokens = TokenRepository(supabase.adminClient);
  final emailEvents = EmailEventRepository(supabase.adminClient);
  final auth = AuthService(
    users: users,
    tokens: tokens,
    email: EmailService(),
    emailEvents: emailEvents,
    clock: Clock(),
    adminClient: supabase.adminClient,
    anonClient: supabase.anonClient,
  );

  final user = await users.findByEmail(email);
  if (user == null) {
    stderr.writeln('User not found: $email');
    exit(1);
  }

  switch (command) {
    case 'confirm_email':
      final token = await auth.createRegistrationToken(user);
      stdout.writeln(token);
      return;
    case 'reset_password':
      final token = await auth.createPasswordResetToken(email);
      if (token.isEmpty) {
        stderr.writeln('Failed to create reset token for $email');
        exit(1);
      }
      stdout.writeln(token);
      return;
    case 'set_password':
      await auth.updateAuthPassword(
        userId: user.id,
        password: password,
        emailConfirmed: true,
      );
      await users.confirmEmail(user.id);
      stdout.writeln('OK');
      return;
    default:
      _printUsage();
      exit(64);
  }
}
