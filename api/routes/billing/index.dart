import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/billing_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/email_templates.dart';
import 'package:som_api/services/access_control.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return _handleList(context);
  }
  if (context.request.method == HttpMethod.post) {
    return _handleCreate(context);
  }
  return Response(statusCode: 405);
}

Future<Response> _handleList(RequestContext context) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final params = context.request.uri.queryParameters;
  final requestedCompanyId = params['companyId'];
  String? companyId;
  if (auth.roles.contains('consultant')) {
    companyId = requestedCompanyId;
  } else if (auth.roles.contains('admin') && auth.roles.contains('provider')) {
    if (requestedCompanyId != null && requestedCompanyId != auth.companyId) {
      return Response(statusCode: 403);
    }
    companyId = auth.companyId;
  } else {
    return Response(statusCode: 403);
  }
  final records =
      await context.read<BillingRepository>().list(companyId: companyId);
  return Response.json(body: records.map((record) => record.toJson()).toList());
}

Future<Response> _handleCreate(RequestContext context) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !isConsultantAdmin(auth)) {
    return Response(statusCode: 403);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final companyId = body['companyId'] as String? ?? '';
  if (companyId.isEmpty) {
    return Response(statusCode: 400);
  }
  final amount = int.tryParse(body['amountInSubunit']?.toString() ?? '');
  if (amount == null || amount <= 0) {
    return Response(statusCode: 400);
  }
  final currency = (body['currency'] as String? ?? 'EUR').toUpperCase();
  final periodStart = DateTime.parse(body['periodStart'] as String);
  final periodEnd = DateTime.parse(body['periodEnd'] as String);
  final now = DateTime.now().toUtc();
  final record = BillingRecord(
    id: const Uuid().v4(),
    companyId: companyId,
    amountInSubunit: amount,
    currency: currency,
    status: 'pending',
    periodStart: periodStart,
    periodEnd: periodEnd,
    createdAt: now,
    paidAt: null,
  );
  await context.read<BillingRepository>().create(record);
  await context.read<AuditService>().log(
        action: 'billing.created',
        entityType: 'billing_record',
        entityId: record.id,
        actorId: auth.userId,
        metadata: {
          'companyId': record.companyId,
          'amountInSubunit': record.amountInSubunit,
          'currency': record.currency,
        },
      );
  final email = context.read<EmailService>();
  final admins =
      await context.read<UserRepository>().listAdminsByCompany(companyId);
  for (final admin in admins) {
    await email.sendTemplate(
      to: admin.email,
      templateId: EmailTemplateId.billingCreated,
      variables: {'billingId': record.id},
    );
  }
  return Response.json(body: record.toJson());
}
