import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/csv_writer.dart';
import 'package:som_api/services/request_auth.dart';
import 'package:som_api/services/statistics_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || auth.activeRole != 'buyer') {
    return Response(statusCode: 403);
  }
  final params = context.request.uri.queryParameters;
  final from = params['from'] == null ? null : DateTime.parse(params['from']!);
  final to = params['to'] == null ? null : DateTime.parse(params['to']!);
  final userId = params['userId'];
  if (params['format'] == 'csv') {
    final userRepo = context.read<UserRepository>();
    final inquiryRepo = context.read<InquiryRepository>();
    final isAdmin = auth.roles.contains('admin');
    if (userId != null && !isAdmin && userId != auth.userId) {
      return Response(statusCode: 403);
    }
    final users = isAdmin
        ? await userRepo.listByCompany(auth.companyId)
        : [
            await userRepo.findById(auth.userId, companyId: auth.companyId),
          ].whereType().toList();
    final inquiries = await inquiryRepo.listByBuyerCompany(auth.companyId);
    final filtered = inquiries.where((inquiry) {
      if (userId != null && inquiry.createdByUserId != userId) {
        return false;
      }
      if (from != null && inquiry.createdAt.isBefore(from)) {
        return false;
      }
      if (to != null && inquiry.createdAt.isAfter(to)) {
        return false;
      }
      return true;
    }).toList();
    final counts = <String, Map<String, int>>{};
    for (final inquiry in filtered) {
      final entry = counts.putIfAbsent(
        inquiry.createdByUserId,
        () => {'open': 0, 'closed': 0},
      );
      entry[inquiry.status == 'closed' ? 'closed' : 'open'] =
          (entry[inquiry.status == 'closed' ? 'closed' : 'open'] ?? 0) + 1;
    }
    final writer = CsvWriter();
    writer.writeRow(['email', 'open', 'closed']);
    for (final user in users) {
      if (userId != null && user.id != userId) {
        continue;
      }
      final entry = counts[user.id] ?? {'open': 0, 'closed': 0};
      writer.writeRow([user.email, entry['open'], entry['closed']]);
    }
    await context.read<AuditService>().log(
          action: 'stats.exported',
          entityType: 'stats',
          entityId: auth.companyId,
          actorId: auth.userId,
          metadata: {
            'format': 'csv',
            'role': auth.activeRole,
            'scope': userId == null ? 'company' : 'user',
          },
        );
    return Response(
      headers: {'content-type': 'text/csv'},
      body: writer.toString(),
    );
  }
  final stats = await context.read<StatisticsService>().buyerStats(
        companyId: auth.companyId,
        userId: userId,
        from: from,
        to: to,
      );
  return Response.json(body: stats);
}
