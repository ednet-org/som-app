import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/role_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
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
  if (context.request.method == HttpMethod.get) {
    final roles = await repo.listAll();
    final body = roles
        .map((role) => {
              'id': role.id,
              'name': role.name,
              'description': role.description,
              'createdAt': role.createdAt.toIso8601String(),
              'updatedAt': role.updatedAt.toIso8601String(),
            })
        .toList();
    return Response.json(body: body);
  }
  if (context.request.method == HttpMethod.post) {
    final payload =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (payload['name'] as String? ?? '').trim().toLowerCase();
    final description = (payload['description'] as String?)?.trim();
    if (name.isEmpty) {
      return Response.json(statusCode: 400, body: 'Role name is required.');
    }
    final existing = await repo.findByName(name);
    if (existing != null) {
      return Response.json(statusCode: 400, body: 'Role already exists.');
    }
    final now = DateTime.now().toUtc();
    final record = RoleRecord(
      id: const Uuid().v4(),
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    await repo.create(record);
    await context.read<AuditService>().log(
          action: 'role.created',
          entityType: 'role',
          entityId: record.id,
          actorId: auth.userId,
          metadata: {'name': record.name},
        );
    return Response.json(
      body: {
        'id': record.id,
        'name': record.name,
        'description': record.description,
      },
    );
  }
  return Response(statusCode: 405);
}
