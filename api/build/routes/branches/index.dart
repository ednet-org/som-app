import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';
import 'package:som_api/utils/name_normalizer.dart';

Future<Response> onRequest(RequestContext context) async {
  final repo = context.read<BranchRepository>();
  if (context.request.method == HttpMethod.get) {
    final params = context.request.uri.queryParameters;
    final limitParam = params['limit'];
    final offsetParam = params['offset'];
    final status = params['status'];

    // If pagination params provided, return paginated response
    if (limitParam != null || offsetParam != null) {
      final limit = int.tryParse(limitParam ?? '') ?? 50;
      final offset = int.tryParse(offsetParam ?? '') ?? 0;
      final branches = await repo.listBranchesWithCategories(
        limit: limit,
        offset: offset,
        status: status,
      );
      final total = await repo.countBranches(status: status);
      return Response.json(body: {
        'data': branches,
        'total': total,
        'limit': limit,
        'offset': offset,
      });
    }

    // Backward compatible: return flat list with reasonable limit
    final branches = await repo.listBranchesWithCategories(
      limit: 200,
      offset: 0,
      status: status,
    );
    return Response.json(body: branches);
  }
  if (context.request.method == HttpMethod.post) {
    final auth = await parseAuth(
      context,
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
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
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (body['name'] as String? ?? '').trim();
    if (name.isEmpty) {
      return Response(statusCode: 400);
    }
    final normalized = normalizeName(name);
    final existing = await repo.findBranchByNormalizedName(normalized);
    if (existing != null) {
      final categories = await repo.listCategories(existing.id);
      return Response.json(
        statusCode: 200,
        body: {
          'id': existing.id,
          'name': existing.name,
          'status': existing.status,
          'categories': categories
              .map((category) => {
                    'id': category.id,
                    'name': category.name,
                    'status': category.status,
                  })
              .toList(),
        },
      );
    }
    final status = isConsultant ? 'active' : 'pending';
    final branchId = const Uuid().v4();
    await repo.createBranch(
      BranchRecord(
        id: branchId,
        name: name,
        status: status,
        normalizedName: normalized,
      ),
    );
    return Response.json(
      statusCode: 200,
      body: {
        'id': branchId,
        'name': name,
        'status': status,
        'categories': <Map<String, dynamic>>[],
      },
    );
  }
  return Response(statusCode: 405);
}
