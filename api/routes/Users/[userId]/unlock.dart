import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String userId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  final isConsultantAdmin = authResult.roles.contains('consultant') &&
      authResult.roles.contains('admin');
  if (!isConsultantAdmin) {
    return Response(statusCode: 403);
  }
  final users = context.read<UserRepository>();
  final user = await users.findById(userId);
  if (user == null) {
    return Response(statusCode: 404);
  }
  final now = context.read<Clock>().nowUtc();
  await users.update(
    user.copyWith(
      failedLoginAttempts: 0,
      lastFailedLoginAt: null,
      lockedAt: null,
      lockReason: null,
      updatedAt: now,
    ),
  );
  await context.read<AuditService>().log(
        action: 'user.unlocked',
        entityType: 'user',
        entityId: user.id,
        actorId: authResult.userId,
      );
  return Response.json(body: {'status': 'unlocked'});
}
