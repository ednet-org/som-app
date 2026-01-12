import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  final repo = context.read<BranchRepository>();
  if (context.request.method == HttpMethod.get) {
    final branches = await repo.listBranches();
    final body = <Map<String, dynamic>>[];
    for (final branch in branches) {
      final categories = await repo.listCategories(branch.id);
      body.add({
        'id': branch.id,
        'name': branch.name,
        'categories': categories
            .map((category) => {
                  'id': category.id,
                  'name': category.name,
                })
            .toList(),
      });
    }
    return Response.json(body: body);
  }
  if (context.request.method == HttpMethod.post) {
    final auth = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET', defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (auth == null || !auth.roles.contains('consultant')) {
      return Response(statusCode: 403);
    }
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = body['name'] as String? ?? '';
    if (name.isEmpty) {
      return Response(statusCode: 400);
    }
    if (await repo.findBranchByName(name) != null) {
      return Response.json(statusCode: 400, body: 'Branch already exists');
    }
    await repo.createBranch(BranchRecord(id: const Uuid().v4(), name: name));
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
