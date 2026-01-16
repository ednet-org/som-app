import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String branchId) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final repo = context.read<BranchRepository>();
  if (context.request.method == HttpMethod.delete) {
    final existing = await repo.findBranchById(branchId);
    await repo.deleteBranch(branchId);
    if (existing != null) {
      await context.read<DomainEventService>().emit(
            type: 'branch.deleted',
            entityType: 'branch',
            entityId: branchId,
            actorId: auth.userId,
            payload: {'name': existing.name},
          );
    }
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.put) {
    final payload =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (payload['name'] as String? ?? '').trim();
    if (name.isEmpty) {
      return Response.json(statusCode: 400, body: 'Name is required');
    }
    final existing = await repo.findBranchById(branchId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    final duplicate = await repo.findBranchByName(name);
    if (duplicate != null && duplicate.id != branchId) {
      return Response.json(statusCode: 400, body: 'Branch already exists');
    }
    await repo.updateBranchName(branchId, name);
    await context.read<DomainEventService>().emit(
          type: 'branch.updated',
          entityType: 'branch',
          entityId: branchId,
          actorId: auth.userId,
          payload: {'oldName': existing.name, 'newName': name},
        );
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
