import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';
import 'package:som_api/utils/name_normalizer.dart';

Future<Response> onRequest(RequestContext context, String branchId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 403);
  }
  final isConsultant = auth.roles.contains('consultant');
  final isBuyer = auth.roles.contains('buyer');
  if (!isConsultant && !isBuyer) {
    return Response(statusCode: 403);
  }
  final repo = context.read<BranchRepository>();
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final name = (body['name'] as String? ?? '').trim();
  if (name.isEmpty) {
    return Response(statusCode: 400);
  }
  final normalized = normalizeName(name);
  final existing =
      await repo.findCategoryByNormalizedName(branchId, normalized);
  if (existing != null) {
    return Response.json(
      statusCode: 200,
      body: {
        'id': existing.id,
        'name': existing.name,
        'status': existing.status,
      },
    );
  }
  final branch = await repo.findBranchById(branchId);
  if (branch == null) {
    return Response(statusCode: 404);
  }
  final status = isConsultant ? 'active' : 'pending';
  final categoryId = const Uuid().v4();
  await repo.createCategory(
    CategoryRecord(
      id: categoryId,
      branchId: branchId,
      name: name,
      status: status,
      normalizedName: normalized,
    ),
  );
  return Response.json(
    statusCode: 200,
    body: {
      'id': categoryId,
      'name': name,
      'status': status,
    },
  );
}
