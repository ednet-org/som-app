// ignore_for_file: file_names

import 'package:dart_frog/dart_frog.dart';
import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final authResult = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (authResult == null) {
    print('[loadUserWithCompany] Auth failed - returning 401');
    return Response(statusCode: 401);
  }
  print('[loadUserWithCompany] Auth succeeded for user ${authResult.userId}');
  final params = context.request.uri.queryParameters;
  final userId = params['userId'];
  final companyId = params['companyId'];
  if (userId == null) {
    print('[loadUserWithCompany] userId param missing - returning 400');
    return Response(statusCode: 400);
  }
  print('[loadUserWithCompany] Looking up user: $userId');
  final userRepo = context.read<UserRepository>();
  final companyRepo = context.read<CompanyRepository>();
  final user = await userRepo.findById(userId);
  if (user == null) {
    print('[loadUserWithCompany] User $userId not found - returning 404');
    return Response(statusCode: 404);
  }
  print('[loadUserWithCompany] Found user: ${user.email}');
  final isSelf = authResult.userId == userId;
  final isConsultant = authResult.roles.contains('consultant');
  final isAdmin = authResult.roles.contains('admin');
  final sharedCompany =
      await userRepo.findCompanyRole(userId: userId, companyId: authResult.companyId) !=
          null;
  if (!isConsultant && !isSelf && !(isAdmin && sharedCompany)) {
    return Response(statusCode: 403);
  }

  final memberships = await userRepo.listCompanyRolesForUser(userId);
  if (memberships.isEmpty) {
    print('[loadUserWithCompany] No memberships for user $userId - returning 404');
    return Response(statusCode: 404);
  }
  print('[loadUserWithCompany] Found ${memberships.length} memberships');
  var resolvedCompanyId = companyId ?? user.lastLoginCompanyId ?? user.companyId;
  if (!memberships.any((membership) => membership.companyId == resolvedCompanyId)) {
    resolvedCompanyId = memberships.first.companyId;
  }
  print('[loadUserWithCompany] Looking up company: $resolvedCompanyId');
  final company = await companyRepo.findById(resolvedCompanyId);
  if (company == null) {
    print('[loadUserWithCompany] Company $resolvedCompanyId not found - returning 404');
    return Response(statusCode: 404);
  }
  print('[loadUserWithCompany] Found company: ${company.name}');
  final activeMembership = memberships.firstWhere(
    (membership) => membership.companyId == resolvedCompanyId,
    orElse: () => memberships.first,
  );

  final companiesById = <String, dynamic>{};
  for (final membership in memberships) {
    if (companiesById.containsKey(membership.companyId)) {
      continue;
    }
    final companyRecord = await companyRepo.findById(membership.companyId);
    if (companyRecord != null) {
      companiesById[membership.companyId] = companyRecord;
    }
  }
  final companyOptions = memberships
      .where((membership) => companiesById.containsKey(membership.companyId))
      .map((membership) {
    final companyRecord = companiesById[membership.companyId] as dynamic;
    final roles = membership.roles;
    final activeRole =
        roles.contains(user.lastLoginRole) ? user.lastLoginRole : roles.first;
    return {
      'companyId': membership.companyId,
      'companyName': companyRecord.name,
      'companyType': companyTypeToWire(companyRecord.type),
      'roles': roles,
      'activeRole': activeRole,
    };
  }).toList();

  return Response.json(
    body: {
      'userId': user.id,
      'salutation': user.salutation,
      'title': user.title,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'telephoneNr': user.telephoneNr,
      'emailAddress': user.email,
      'roles': activeMembership.roles,
      'activeRole': activeMembership.roles.contains(user.lastLoginRole)
          ? user.lastLoginRole
          : activeMembership.roles.first,
      'companyId': company.id,
      'activeCompanyId': resolvedCompanyId,
      'companyName': company.name,
      'companyAddress': company.address.toJson(),
      'companyType': companyTypeToWire(company.type),
      'companyOptions': companyOptions,
    },
  );
}
