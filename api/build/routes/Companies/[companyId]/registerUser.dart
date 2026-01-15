// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  if (!authResult.roles.contains('admin') ||
      authResult.companyId != companyId) {
    return Response(statusCode: 403);
  }
  final repo = context.read<UserRepository>();
  final auth = context.read<AuthService>();
  final company =
      await context.read<CompanyRepository>().findById(companyId);
  if (company == null) {
    return Response(statusCode: 404);
  }
  if (company.type == 'provider' || company.type == 'buyer_provider') {
    final provider =
        await context.read<ProviderRepository>().findByCompany(companyId);
    if (provider == null) {
      return Response.json(
        statusCode: 400,
        body: 'Provider profile is required.',
      );
    }
    final plan = await context
        .read<SubscriptionRepository>()
        .findPlanById(provider.subscriptionPlanId);
    if (plan != null) {
      final maxUsers = _maxUsersForPlan(plan);
      if (maxUsers != null && maxUsers > 0) {
        final activeUsers = (await repo.listByCompany(companyId))
            .where((user) => user.isActive)
            .length;
        if (activeUsers + 1 > maxUsers) {
          return Response.json(
            statusCode: 400,
            body: 'User limit exceeded for subscription plan.',
          );
        }
      }
    }
  }
  final body = await context.request.body();
  final jsonBody = jsonDecode(body) as Map<String, dynamic>;
  final email = (jsonBody['email'] as String? ?? '').toLowerCase();
  if (await repo.findByEmail(email) != null) {
    return Response.json(statusCode: 400, body: 'E-mail already used.');
  }
  late final String authUserId;
  try {
    authUserId = await auth.ensureAuthUser(email: email);
  } on AuthException catch (error) {
    return Response.json(statusCode: 400, body: error.message);
  }
  final now = DateTime.now().toUtc();
  final normalizedRoles = _ensureBaseRoles(
    roles: (jsonBody['roles'] as List<dynamic>? ?? [2])
        .map((e) => e is int ? roleFromWire(e) : e.toString())
        .toList(),
    companyType: company?.type ?? 'buyer',
  );
  final user = UserRecord(
    id: authUserId,
    companyId: companyId,
    email: email,
    firstName: jsonBody['firstName'] as String? ?? '',
    lastName: jsonBody['lastName'] as String? ?? '',
    salutation: jsonBody['salutation'] as String? ?? '',
    title: jsonBody['title'] as String?,
    telephoneNr: jsonBody['telephoneNr'] as String?,
    roles: normalizedRoles,
    isActive: true,
    emailConfirmed: false,
    lastLoginRole: null,
    createdAt: now,
    updatedAt: now,
  );
  await repo.create(user);
  await auth.createRegistrationToken(user);
  return Response(statusCode: 200);
}

int? _maxUsersForPlan(SubscriptionPlanRecord plan) {
  for (final rule in plan.rules) {
    if ((rule['restriction'] as int? ?? -1) == 0) {
      final limit = rule['upperLimit'] as int? ?? 0;
      return limit > 0 ? limit : null;
    }
  }
  return null;
}

List<String> _ensureBaseRoles({
  required List<String> roles,
  required String companyType,
}) {
  final normalized = <String>{...roles};
  if (normalized.contains('admin')) {
    if (companyType == 'buyer' || companyType == 'buyer_provider') {
      normalized.add('buyer');
    }
    if (companyType == 'provider' || companyType == 'buyer_provider') {
      normalized.add('provider');
    }
  }
  final ordered = <String>[];
  if (normalized.contains('buyer')) {
    ordered.add('buyer');
  }
  if (normalized.contains('provider')) {
    ordered.add('provider');
  }
  if (normalized.contains('consultant')) {
    ordered.add('consultant');
  }
  if (normalized.contains('admin')) {
    ordered.add('admin');
  }
  for (final role in normalized) {
    if (!ordered.contains(role)) {
      ordered.add(role);
    }
  }
  return ordered;
}
