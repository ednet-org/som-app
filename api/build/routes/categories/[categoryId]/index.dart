import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String categoryId) async {
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
    final existing = await repo.findCategoryById(categoryId);
    await repo.deleteCategory(categoryId);
    if (existing != null) {
      await context.read<DomainEventService>().emit(
        type: 'category.deleted',
        entityType: 'category',
        entityId: categoryId,
        actorId: auth.userId,
        payload: {
          'name': existing.name,
          'branchId': existing.branchId,
        },
      );
    }
    return Response(statusCode: 200);
  }
  if (context.request.method == HttpMethod.put) {
    final payload =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (payload['name'] as String?)?.trim();
    final status = (payload['status'] as String?)?.trim();
    if ((name == null || name.isEmpty) && (status == null || status.isEmpty)) {
      return Response.json(statusCode: 400, body: 'Name or status is required');
    }
    if (status != null &&
        status.isNotEmpty &&
        status != 'active' &&
        status != 'pending' &&
        status != 'declined') {
      return Response.json(statusCode: 400, body: 'Invalid status');
    }
    final existing = await repo.findCategoryById(categoryId);
    if (existing == null) {
      return Response(statusCode: 404);
    }
    if (name != null && name.isNotEmpty) {
      final duplicate = await repo.findCategory(existing.branchId, name);
      if (duplicate != null && duplicate.id != categoryId) {
        return Response.json(statusCode: 400, body: 'Category already exists');
      }
    }
    await repo.updateCategory(
      categoryId,
      name: name?.isEmpty == true ? null : name,
      status: status?.isEmpty == true ? null : status,
    );
    await context.read<DomainEventService>().emit(
      type: 'category.updated',
      entityType: 'category',
      entityId: categoryId,
      actorId: auth.userId,
      payload: {
        'branchId': existing.branchId,
        if (name != null && name.isNotEmpty) 'oldName': existing.name,
        if (name != null && name.isNotEmpty) 'newName': name,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
