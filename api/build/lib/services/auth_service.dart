import 'dart:convert';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
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
    String? jwtSecret,
  }) : _jwtSecret = jwtSecret ?? 'som_dev_secret';

  final UserRepository users;
  final TokenRepository tokens;
  final EmailService email;
  final Clock clock;
  final String _jwtSecret;

  String hashPassword(String password) => BCrypt.hashpw(password, BCrypt.gensalt());

  bool verifyPassword(String password, String hash) => BCrypt.checkpw(password, hash);

  Future<AuthTokens> login({required String emailAddress, required String password}) async {
    final user = users.findByEmail(emailAddress);
    if (user == null || !user.isActive || user.passwordHash == null) {
      throw AuthException('Invalid password or E-Mail');
    }
    if (!user.emailConfirmed) {
      throw AuthException('Email not confirmed');
    }
    if (!verifyPassword(password, user.passwordHash!)) {
      throw AuthException('Invalid password or E-Mail');
    }
    final role = user.lastLoginRole ?? user.roles.first;
    users.updateLastLoginRole(user.id, role);
    final accessToken = _createJwt(user, role: role);
    final refreshToken = _createRefreshToken(user.id);
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  String _createJwt(UserRecord user, {required String role}) {
    final jwt = JWT(
      {
        'sub': user.id,
        'companyId': user.companyId,
        'email': user.email,
        'roles': user.roles,
        'activeRole': role,
      },
      issuer: 'som-api',
    );
    return jwt.sign(SecretKey(_jwtSecret), expiresIn: const Duration(hours: 2));
  }

  String issueAccessToken(UserRecord user, {required String role}) {
    return _createJwt(user, role: role);
  }

  String _createRefreshToken(String userId) {
    final raw = _randomToken();
    final hashed = _hashToken(raw);
    final now = clock.nowUtc();
    tokens.createRefresh(
      RefreshTokenRecord(
        id: const Uuid().v4(),
        userId: userId,
        tokenHash: hashed,
        expiresAt: now.add(const Duration(days: 30)),
        createdAt: now,
      ),
    );
    return raw;
  }

  Future<void> sendForgotPassword(String emailAddress) async {
    final user = users.findByEmail(emailAddress);
    if (user == null) {
      return;
    }
    final raw = _randomToken();
    tokens.create(
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
    final user = users.findByEmail(emailAddress);
    if (user == null) {
      throw AuthException('Invalid token');
    }
    final record = tokens.findValidByHash('reset_password', _hashToken(token));
    if (record == null || record.expiresAt.isBefore(clock.nowUtc())) {
      throw AuthException('Expired link, please contact the admin for new registration');
    }
    tokens.markUsed(record.id, clock.nowUtc());
    users.setPassword(user.id, hashPassword(password));
  }

  Future<void> confirmEmail({required String emailAddress, required String token}) async {
    final user = users.findByEmail(emailAddress);
    if (user == null) {
      throw AuthException('Invalid token');
    }
    final record = tokens.findValidByHash('confirm_email', _hashToken(token));
    if (record == null || record.expiresAt.isBefore(clock.nowUtc())) {
      throw AuthException('Expired link, please contact the admin for new registration');
    }
    tokens.markUsed(record.id, clock.nowUtc());
    users.confirmEmail(user.id);
  }

  Future<String> createRegistrationToken(UserRecord user) async {
    final raw = _randomToken();
    tokens.create(
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
