import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
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
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || auth.activeRole != 'provider') {
    return Response(statusCode: 403);
  }
  final params = context.request.uri.queryParameters;
  final from = params['from'] == null ? null : DateTime.parse(params['from']!);
  final to = params['to'] == null ? null : DateTime.parse(params['to']!);
  if (params['format'] == 'csv') {
    final userRepo = context.read<UserRepository>();
    final inquiryRepo = context.read<InquiryRepository>();
    final offerRepo = context.read<OfferRepository>();
    final isAdmin = auth.roles.contains('admin');
    final users = isAdmin
        ? await userRepo.listByCompany(auth.companyId)
        : [
            await userRepo.findById(auth.userId, companyId: auth.companyId),
          ].whereType().toList();

    final assignments =
        await inquiryRepo.countAssignmentsForProvider(auth.companyId);
    final offers = await offerRepo.listByProviderCompany(auth.companyId);
    final filteredOffers = offers.where((offer) {
      if (from != null && offer.createdAt.isBefore(from)) {
        return false;
      }
      if (to != null && offer.createdAt.isAfter(to)) {
        return false;
      }
      return true;
    }).toList();

    final totalsByUser = <String, Map<String, int>>{};
    for (final offer in filteredOffers) {
      final userId = offer.providerUserId;
      if (userId == null) continue;
      final entry = totalsByUser.putIfAbsent(userId, () {
        return {
          'offer_created': 0,
          'lost': 0,
          'won': 0,
          'ignored': 0,
          'total': 0,
        };
      });
      entry['total'] = (entry['total'] ?? 0) + 1;
      entry[offer.status] = (entry[offer.status] ?? 0) + 1;
    }

    final writer = CsvWriter();
    writer.writeRow(['email', 'open', 'offerCreated', 'lost', 'won', 'ignored']);
    for (final user in users) {
      final entry = totalsByUser[user.id] ??
          {
            'offer_created': 0,
            'lost': 0,
            'won': 0,
            'ignored': 0,
            'total': 0,
          };
      final open = (assignments - (entry['total'] ?? 0)).clamp(0, assignments);
      writer.writeRow([
        user.email,
        open,
        entry['offer_created'],
        entry['lost'],
        entry['won'],
        entry['ignored'],
      ]);
    }
    await context.read<AuditService>().log(
          action: 'stats.exported',
          entityType: 'stats',
          entityId: auth.companyId,
          actorId: auth.userId,
          metadata: {
            'format': 'csv',
            'role': auth.activeRole,
          },
        );
    return Response(
      headers: {'content-type': 'text/csv'},
      body: writer.toString(),
    );
  }
  final stats = await context.read<StatisticsService>().providerStats(
        companyId: auth.companyId,
        from: from,
        to: to,
      );
  return Response.json(body: stats);
}
