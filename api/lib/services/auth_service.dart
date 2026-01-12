import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

import '../infrastructure/clock.dart';
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
    required this.clock,
    required SupabaseClient adminClient,
    required SupabaseClient anonClient,
  })  : _adminClient = adminClient,
        _anonClient = anonClient;

  final UserRepository users;
  final TokenRepository tokens;
  final EmailService email;
  final Clock clock;
  final SupabaseClient _adminClient;
  final SupabaseClient _anonClient;

  Future<AuthTokens> login({required String emailAddress, required String password}) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null || !user.isActive) {
      throw AuthException('Invalid password or E-Mail');
    }
    if (!user.emailConfirmed) {
      throw AuthException('Email not confirmed');
    }
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
    final role =
        user.lastLoginRole ?? (user.roles.isNotEmpty ? user.roles.first : 'buyer');
    await users.updateLastLoginRole(user.id, role);
    return AuthTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
    );
  }

  Future<void> sendForgotPassword(String emailAddress) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null) {
      return;
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
    await email.send(
      to: user.email,
      subject: 'Reset your SOM password',
      text: 'Use this link to reset your password: /auth/resetPassword?token=$raw&email=${user.email}',
    );
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
    final record = await tokens.findValidByHash('reset_password', _hashToken(token));
    if (record == null || record.expiresAt.isBefore(clock.nowUtc())) {
      throw AuthException('Expired link, please contact the admin for new registration');
    }
    await tokens.markUsed(record.id, clock.nowUtc());
    await _adminClient.auth.admin.updateUserById(
      user.id,
      attributes: AdminUserAttributes(
        password: password,
        emailConfirm: true,
      ),
    );
    await users.confirmEmail(user.id);
  }

  Future<void> confirmEmail({required String emailAddress, required String token}) async {
    final user = await users.findByEmail(emailAddress);
    if (user == null) {
      throw AuthException('Invalid token');
    }
    final record = await tokens.findValidByHash('confirm_email', _hashToken(token));
    if (record == null || record.expiresAt.isBefore(clock.nowUtc())) {
      throw AuthException('Expired link, please contact the admin for new registration');
    }
    await tokens.markUsed(record.id, clock.nowUtc());
    await _adminClient.auth.admin.updateUserById(
      user.id,
      attributes: AdminUserAttributes(emailConfirm: true),
    );
    await users.confirmEmail(user.id);
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
      text: 'Activate your account: /auth/confirmEmail?token=$raw&email=${user.email}',
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
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: emailConfirmed,
        ),
      );
    } catch (_) {
      throw AuthException('E-mail already used.');
    }
    final userId = response.user?.id;
    if (userId == null) {
      throw AuthException('Failed to create auth user');
    }
    return userId;
  }

  Future<void> updateAuthPassword({
    required String userId,
    required String password,
    bool emailConfirmed = false,
  }) async {
    await _adminClient.auth.admin.updateUserById(
      userId,
      attributes: AdminUserAttributes(
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
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
