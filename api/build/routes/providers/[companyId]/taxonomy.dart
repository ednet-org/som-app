import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_taxonomy_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment(
      'SUPABASE_JWT_SECRET',
      defaultValue: 'som_dev_secret',
    ),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }

  final repo = context.read<CompanyTaxonomyRepository>();

  switch (context.request.method) {
    case HttpMethod.get:
      final taxonomy = await repo.fetchCompanyTaxonomy(companyId);
      return Response.json(body: taxonomy.toJson());
    case HttpMethod.put:
      final body = jsonDecode(await context.request.body());
      if (body is! Map<String, dynamic>) {
        return Response(statusCode: 400, body: 'Invalid JSON body');
      }
      final branchIds = (body['branchIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();
      final categoryIds = (body['categoryIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();

      await repo.replaceCompanyBranches(
        companyId: companyId,
        branchIds: branchIds,
        source: 'manual',
        status: 'active',
      );
      await repo.replaceCompanyCategories(
        companyId: companyId,
        categoryIds: categoryIds,
        source: 'manual',
        status: 'active',
      );

      final taxonomy = await repo.fetchCompanyTaxonomy(companyId);
      return Response.json(body: taxonomy.toJson());
    default:
      return Response(statusCode: 405);
  }
}
