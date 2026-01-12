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
  if (auth == null || !auth.roles.contains('buyer')) {
    return Response(statusCode: 403);
  }
  final params = context.request.uri.queryParameters;
  final from = params['from'] == null ? null : DateTime.parse(params['from']!);
  final to = params['to'] == null ? null : DateTime.parse(params['to']!);
  final userId = params['userId'];
  final stats = await context.read<StatisticsService>().buyerStats(
        companyId: auth.companyId,
        userId: userId,
        from: from,
        to: to,
      );
  if (params['format'] == 'csv') {
    final buffer = StringBuffer();
    buffer.writeln('email,open,closed');
    buffer.writeln('${userId ?? 'all'},${stats['open']},${stats['closed']}');
    return Response(
      headers: {'content-type': 'text/csv'},
      body: buffer.toString(),
    );
  }
  return Response.json(body: stats);
}
