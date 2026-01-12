import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String branchId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final repo = context.read<BranchRepository>();
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final name = body['name'] as String? ?? '';
  if (name.isEmpty) {
    return Response(statusCode: 400);
  }
  if (repo.findCategory(branchId, name) != null) {
    return Response.json(statusCode: 400, body: 'Category already exists');
  }
  repo.createCategory(CategoryRecord(id: const Uuid().v4(), branchId: branchId, name: name));
  return Response(statusCode: 200);
}
