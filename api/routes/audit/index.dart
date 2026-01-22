import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/audit_log_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null ||
      !auth.roles.contains('consultant') ||
      !auth.roles.contains('admin')) {
    return Response(statusCode: 403);
  }
  final limitParam = context.request.uri.queryParameters['limit'];
  final limit = int.tryParse(limitParam ?? '') ?? 100;
  final logs =
      await context.read<AuditLogRepository>().listRecent(limit: limit);
  final body = logs
      .map((entry) => {
            'id': entry.id,
            'actorId': entry.actorId,
            'action': entry.action,
            'entityType': entry.entityType,
            'entityId': entry.entityId,
            'metadata': entry.metadata,
            'createdAt': entry.createdAt.toIso8601String(),
          })
      .toList();
  return Response.json(body: body);
}
