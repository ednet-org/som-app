// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/cancellation_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/email_templates.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final isConsultant = auth.roles.contains('consultant');
  final isProviderAdmin =
      auth.roles.contains('admin') && auth.activeRole == 'provider';
  if (!isConsultant && !isProviderAdmin) {
    return Response(statusCode: 403);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final reason = body['reason'] as String?;
  final subscriptions = context.read<SubscriptionRepository>();
  final current = await subscriptions.findSubscriptionByCompany(auth.companyId);
  final effectiveEndDate = current?.endDate;
  final now = DateTime.now().toUtc();
  final record = SubscriptionCancellationRecord(
    id: const Uuid().v4(),
    companyId: auth.companyId,
    requestedByUserId: auth.userId,
    reason: reason,
    status: 'pending',
    requestedAt: now,
    effectiveEndDate: effectiveEndDate,
    resolvedAt: null,
  );
  await context.read<CancellationRepository>().create(record);
  await context.read<AuditService>().log(
        action: 'subscription.cancellation.requested',
        entityType: 'subscription_cancellation',
        entityId: record.id,
        actorId: auth.userId,
        metadata: {
          'companyId': auth.companyId,
          'reason': reason,
        },
      );
  final consultants =
      await context.read<UserRepository>().listByRole('consultant');
  final email = context.read<EmailService>();
  for (final consultant in consultants) {
    await email.sendTemplate(
      to: consultant.email,
      templateId: EmailTemplateId.subscriptionCancellationRequested,
      variables: {
        'companyId': auth.companyId,
        'cancellationId': record.id,
      },
    );
  }
  return Response.json(body: record.toJson());
}
