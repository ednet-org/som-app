import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/services/request_auth.dart';
import 'package:som_api/services/statistics_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null || !auth.roles.contains('provider')) {
    return Response(statusCode: 403);
  }
  final params = context.request.uri.queryParameters;
  final from = params['from'] == null ? null : DateTime.parse(params['from']!);
  final to = params['to'] == null ? null : DateTime.parse(params['to']!);
  final stats = context.read<StatisticsService>().providerStats(
        companyId: auth.companyId,
        from: from,
        to: to,
      );
  if (params['format'] == 'csv') {
    final buffer = StringBuffer();
    buffer.writeln('email,open,offer_created,lost,won,ignored');
    buffer.writeln('${auth.userId},${stats['open']},${stats['offer_created']},${stats['lost']},${stats['won']},${stats['ignored']}');
    return Response(
      headers: {'content-type': 'text/csv'},
      body: buffer.toString(),
    );
  }
  return Response.json(body: stats);
}
