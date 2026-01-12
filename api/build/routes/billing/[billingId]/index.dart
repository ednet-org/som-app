import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/billing_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String billingId) async {
  if (context.request.method != HttpMethod.put) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<BillingRepository>();
  final record = await repo.findById(billingId);
  if (record == null) {
    return Response(statusCode: 404);
  }
  final allowed = auth.roles.contains('consultant') ||
      (auth.roles.contains('admin') &&
          auth.roles.contains('provider') &&
          auth.companyId == record.companyId);
  if (!allowed) {
    return Response(statusCode: 403);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final status = body['status'] as String? ?? record.status;
  DateTime? paidAt = record.paidAt;
  if (body['paidAt'] != null) {
    paidAt = DateTime.parse(body['paidAt'] as String).toUtc();
  } else if (status == 'paid' && paidAt == null) {
    paidAt = DateTime.now().toUtc();
  }
  final updated = BillingRecord(
    id: record.id,
    companyId: record.companyId,
    amountInSubunit: record.amountInSubunit,
    currency: record.currency,
    status: status,
    periodStart: record.periodStart,
    periodEnd: record.periodEnd,
    createdAt: record.createdAt,
    paidAt: paidAt,
  );
  await repo.update(updated);
  return Response.json(body: updated.toJson());
}
