import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
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
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final params = context.request.uri.queryParameters;
  final from = params['from'] == null ? null : DateTime.parse(params['from']!);
  final to = params['to'] == null ? null : DateTime.parse(params['to']!);
  final type = params['type'] ?? 'status';
  final statsService = context.read<StatisticsService>();
  Map<String, int> stats;
  switch (type) {
    case 'period':
      stats = await statsService.consultantPeriodStats(from: from, to: to);
      break;
    case 'providerType':
      stats =
          await statsService.consultantProviderTypeStats(from: from, to: to);
      break;
    case 'providerSize':
      stats =
          await statsService.consultantProviderSizeStats(from: from, to: to);
      break;
    case 'status':
    default:
      stats = await statsService.consultantStatusStats(from: from, to: to);
  }
  if (params['format'] == 'csv') {
    final buffer = StringBuffer();
    buffer.writeln('$type,count');
    stats.forEach((key, value) {
      buffer.writeln('$key,$value');
    });
    return Response(
      headers: {'content-type': 'text/csv'},
      body: buffer.toString(),
    );
  }
  return Response.json(body: stats);
}
