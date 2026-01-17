import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:supabase/supabase.dart' as supa;
import 'package:uuid/uuid.dart';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/email_event_repository.dart';
import '../infrastructure/repositories/token_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import '../models/models.dart';
import 'email_service.dart';

class AuthTokens {
  AuthTokens({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;
}

class AuthService {
  AuthService({
    required this.users,
    required this.tokens,
    required this.email,
    required this.emailEvents,
    required this.clock,
    required supa.SupabaseClient adminClient,
    required supa.SupabaseClient anonClient,
  })  : _adminClient = adminClient,
        _anonClient = anonClient;

  final UserRepository users;
  final TokenRepository tokens;
  final EmailService email;
  final EmailEventRepository emailEvents;
  final Clock clock;
  final supa.SupabaseClient _adminClient;
  final supa.SupabaseClient _anonClient;
  static const int maxFailedLoginAttempts = 5;

  Future<AuthTokens> login(
      {required String emailAddress, required String password}) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null || !user.isActive) {
      throw AuthException('Invalid password or E-Mail');
    }
    if (user.lockedAt != null) {
      final reason = user.lockReason ?? 'Too many failed attempts';
      throw AuthException('Account locked: $reason');
    }
    if (!user.emailConfirmed) {
      throw AuthException('Email not confirmed');
    }
    try {
      final tokens = await performLogin(emailAddress, password);
      await _resetLoginFailures(user);
      final role = user.lastLoginRole ??
          (user.roles.isNotEmpty ? user.roles.first : 'buyer');
      await users.updateLastLoginRole(user.id, role);
      return tokens;
    } catch (_) {
      final message = await _recordFailedLogin(user);
      throw AuthException(message);
    }
  }

  Future<AuthTokens> performLogin(String emailAddress, String password) async {
    late final dynamic response;
    try {
      response = await _anonClient.auth.signInWithPassword(
        email: emailAddress,
        password: password,
      );
    } catch (_) {
      throw AuthException('Invalid password or E-Mail');
    }
    final session = response.session;
    if (session == null) {
      throw AuthException('Invalid password or E-Mail');
    }
    return AuthTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
    );
  }

  Future<void> _resetLoginFailures(UserRecord user) async {
    if (user.failedLoginAttempts == 0 &&
        user.lastFailedLoginAt == null &&
        user.lockedAt == null &&
        user.lockReason == null) {
      return;
    }
    final now = clock.nowUtc();
    await users.update(
      user.copyWith(
        failedLoginAttempts: 0,
        lastFailedLoginAt: null,
        lockedAt: null,
        lockReason: null,
        updatedAt: now,
      ),
    );
  }

  Future<String> _recordFailedLogin(UserRecord user) async {
    final now = clock.nowUtc();
    final attempts = user.failedLoginAttempts + 1;
    final isLocked = attempts >= maxFailedLoginAttempts;
    final reason = isLocked ? 'Too many failed attempts' : user.lockReason;
    await users.update(
      user.copyWith(
        failedLoginAttempts: attempts,
        lastFailedLoginAt: now,
        lockedAt: isLocked ? now : user.lockedAt,
        lockReason: isLocked ? reason : user.lockReason,
        updatedAt: now,
      ),
    );
    if (isLocked) {
      return 'Account locked: $reason';
    }
    return 'Invalid password or E-Mail';
  }

  Future<String> createPasswordResetToken(
    String emailAddress, {
    bool sendEmail = false,
  }) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null) {
      return '';
    }
    final raw = _randomToken();
    await tokens.create(
      TokenRecord(
        id: const Uuid().v4(),
        userId: user.id,
        type: 'reset_password',
        tokenHash: _hashToken(raw),
        expiresAt: clock.nowUtc().add(const Duration(hours: 24)),
        createdAt: clock.nowUtc(),
      ),
    );
    if (sendEmail) {
      await email.send(
        to: user.email,
        subject: 'Reset your SOM password',
        text:
            'Use this link to reset your password: /auth/resetPassword?token=$raw&email=${user.email}',
      );
    }
    return raw;
  }

  Future<void> sendForgotPassword(String emailAddress) async {
    await createPasswordResetToken(emailAddress, sendEmail: true);
  }

  Future<void> resetPassword({
    required String emailAddress,
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw AuthException('Passwords don\'t match');
    }
    final user = await users.findByEmail(emailAddress);
    if (user == null) {
      throw AuthException('Invalid token');
    }
    final hash = _hashToken(token);
    final resetRecord = await tokens.findValidByHash('reset_password', hash);
    final confirmRecord =
        resetRecord ?? await tokens.findValidByHash('confirm_email', hash);
    final record = resetRecord ?? confirmRecord;
    if (record == null || record.expiresAt.isBefore(clock.nowUtc())) {
      throw AuthException(
          'Expired link, please contact the admin for new registration');
    }
    await tokens.markUsed(record.id, clock.nowUtc());
    await updateAuthPassword(
      userId: user.id,
      password: password,
      emailConfirmed: true,
    );
    await users.confirmEmail(user.id);
    if (resetRecord != null) {
      await _sendPasswordChangedEmail(user);
    } else {
      await _sendWelcomeEmail(user);
    }
  }

  Future<void> confirmEmail(
      {required String emailAddress, required String token}) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null) {
      throw AuthException('Invalid token');
    }
    final record =
        await tokens.findValidByHash('confirm_email', _hashToken(token));
    if (record == null || record.expiresAt.isBefore(clock.nowUtc())) {
      throw AuthException(
          'Expired link, please contact the admin for new registration');
    }
  }

  Future<void> changePassword({
    required String userId,
    required String emailAddress,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      throw AuthException('Passwords don\'t match');
    }
    try {
      await performLogin(emailAddress, currentPassword);
    } catch (_) {
      throw AuthException('Invalid password or E-Mail');
    }
    await updateAuthPassword(
      userId: userId,
      password: newPassword,
      emailConfirmed: true,
    );
    final user = await users.findById(userId);
    if (user != null) {
      await _sendPasswordChangedEmail(user);
    }
  }

  Future<void> signOut(String accessToken) async {
    await _adminClient.auth.admin.signOut(accessToken);
  }

  Future<String> createRegistrationToken(UserRecord user) async {
    final raw = _randomToken();
    await tokens.create(
      TokenRecord(
        id: const Uuid().v4(),
        userId: user.id,
        type: 'confirm_email',
        tokenHash: _hashToken(raw),
        expiresAt: clock.nowUtc().add(const Duration(days: 14)),
        createdAt: clock.nowUtc(),
      ),
    );
    await email.send(
      to: user.email,
      subject: 'Complete your SOM registration',
      text:
          'Activate your account: /auth/confirmEmail?token=$raw&email=${user.email}',
    );
    return raw;
  }

  Future<String> ensureAuthUser({
    required String email,
    String? password,
    bool emailConfirmed = false,
  }) async {
    late final dynamic response;
    try {
      response = await _adminClient.auth.admin.createUser(
        supa.AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: emailConfirmed,
        ),
      );
    } on supa.AuthException catch (error) {
      final existingUserId = await _findAuthUserIdByEmail(email);
      if (existingUserId != null) {
        return existingUserId;
      }
      throw AuthException(error.message);
    } catch (_) {
      final existingUserId = await _findAuthUserIdByEmail(email);
      if (existingUserId != null) {
        return existingUserId;
      }
      throw AuthException('Failed to create auth user');
    }
    final userId = response.user?.id;
    if (userId == null) {
      final existingUserId = await _findAuthUserIdByEmail(email);
      if (existingUserId != null) {
        return existingUserId;
      }
      throw AuthException('Failed to create auth user');
    }
    return userId;
  }

  Future<String?> _findAuthUserIdByEmail(String email) async {
    if (email.trim().isEmpty) {
      return null;
    }
    final normalized = email.trim().toLowerCase();
    const perPage = 200;
    var page = 1;
    while (true) {
      final users = await _adminClient.auth.admin.listUsers(
        page: page,
        perPage: perPage,
      );
      if (users.isEmpty) {
        return null;
      }
      for (final user in users) {
        final userEmail = user.email?.toLowerCase();
        if (userEmail == normalized) {
          return user.id;
        }
      }
      if (users.length < perPage) {
        return null;
      }
      page++;
    }
  }

  Future<void> updateAuthPassword({
    required String userId,
    required String password,
    bool emailConfirmed = false,
  }) async {
    await _adminClient.auth.admin.updateUserById(
      userId,
      attributes: supa.AdminUserAttributes(
        password: password,
        emailConfirm: emailConfirmed,
      ),
    );
  }

  Future<void> deleteAuthUser(String userId) async {
    await _adminClient.auth.admin.deleteUser(userId);
  }

  String _randomToken() {
    final rng = Random.secure();
    final values = List<int>.generate(32, (_) => rng.nextInt(256));
    return base64Url.encode(values);
  }

  String _hashToken(String token) {
    final bytes = utf8.encode(token);
    return sha256.convert(bytes).toString();
  }

  Future<void> _sendWelcomeEmail(UserRecord user) async {
    final baseUrl = const String.fromEnvironment(
      'APP_BASE_URL',
      defaultValue: 'http://localhost:8090',
    );
    await email.send(
      to: user.email,
      subject: 'Welcome to SOM',
      text: 'Your account is now active. Sign in: $baseUrl',
    );
    await emailEvents.create(
      EmailEventRecord(
        id: const Uuid().v4(),
        userId: user.id,
        type: 'welcome',
        createdAt: clock.nowUtc(),
      ),
    );
  }

  Future<void> _sendPasswordChangedEmail(UserRecord user) async {
    await email.send(
      to: user.email,
      subject: 'Your SOM password was changed',
      text:
          'Your password was changed. If this was not you, contact support immediately.',
    );
    await emailEvents.create(
      EmailEventRecord(
        id: const Uuid().v4(),
        userId: user.id,
        type: 'password_changed',
        createdAt: clock.nowUtc(),
      ),
    );
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
