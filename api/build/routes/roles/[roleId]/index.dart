import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/role_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/request_auth.dart';

const _baseRoles = {'buyer', 'provider', 'consultant', 'admin'};

Future<Response> onRequest(RequestContext context, String roleId) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final isConsultantAdmin =
      auth.roles.contains('consultant') && auth.roles.contains('admin');
  if (!isConsultantAdmin) {
    return Response(statusCode: 403);
  }

  final repo = context.read<RoleRepository>();
  final existing = await repo.findById(roleId);
  if (existing == null) {
    return Response(statusCode: 404);
  }

  if (context.request.method == HttpMethod.put) {
    final payload =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (payload['name'] as String?)?.trim().toLowerCase();
    final description = (payload['description'] as String?)?.trim();
    if (_baseRoles.contains(existing.name) &&
        name != null &&
        name.isNotEmpty &&
        name != existing.name) {
      return Response.json(
        statusCode: 400,
        body: 'Base roles cannot be renamed.',
      );
    }
    final updated = RoleRecord(
      id: existing.id,
      name: name != null && name.isNotEmpty ? name : existing.name,
      description: description ?? existing.description,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    await repo.update(updated);
    await context.read<AuditService>().log(
          action: 'role.updated',
          entityType: 'role',
          entityId: updated.id,
          actorId: auth.userId,
          metadata: {
            'before': {
              'name': existing.name,
              'description': existing.description,
            },
            'after': {
              'name': updated.name,
              'description': updated.description,
            },
          },
        );
    return Response.json(body: {
      'id': updated.id,
      'name': updated.name,
      'description': updated.description,
    });
  }

  if (context.request.method == HttpMethod.delete) {
    if (_baseRoles.contains(existing.name)) {
      return Response.json(
        statusCode: 400,
        body: 'Base roles cannot be deleted.',
      );
    }
    await repo.delete(roleId);
    await context.read<AuditService>().log(
          action: 'role.deleted',
          entityType: 'role',
          entityId: existing.id,
          actorId: auth.userId,
          metadata: {'name': existing.name},
        );
    return Response(statusCode: 200);
  }

  return Response(statusCode: 405);
}
