import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/cancellation_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(
    RequestContext context, String cancellationId) async {
  if (context.request.method != HttpMethod.put) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final repo = context.read<CancellationRepository>();
  final existing = await repo.findById(cancellationId);
  if (existing == null) {
    return Response(statusCode: 404);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final status = body['status'] as String? ?? existing.status;
  final resolvedAt = DateTime.now().toUtc();
  final updated = SubscriptionCancellationRecord(
    id: existing.id,
    companyId: existing.companyId,
    requestedByUserId: existing.requestedByUserId,
    reason: existing.reason,
    status: status,
    requestedAt: existing.requestedAt,
    effectiveEndDate: existing.effectiveEndDate,
    resolvedAt: resolvedAt,
  );
  await repo.update(updated);
  await context.read<AuditService>().log(
        action: 'subscription.cancellation.updated',
        entityType: 'subscription_cancellation',
        entityId: updated.id,
        actorId: auth.userId,
        metadata: {
          'companyId': updated.companyId,
          'status': updated.status,
        },
      );
  final admins = await context
      .read<UserRepository>()
      .listAdminsByCompany(existing.companyId);
  final email = context.read<EmailService>();
  for (final admin in admins) {
    await email.send(
      to: admin.email,
      subject: 'Subscription cancellation update',
      text: 'Your cancellation request ${existing.id} is now $status.',
    );
  }
  return Response.json(body: updated.toJson());
}
