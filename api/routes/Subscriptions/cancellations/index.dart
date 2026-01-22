// ignore_for_file: file_names

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/cancellation_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
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
  final params = context.request.uri.queryParameters;
  final status = params['status'];
  String? companyId;
  if (auth.roles.contains('consultant')) {
    companyId = params['companyId'];
  } else if (auth.roles.contains('admin') && auth.roles.contains('provider')) {
    companyId = auth.companyId;
  } else {
    return Response(statusCode: 403);
  }
  final cancellations = await context
      .read<CancellationRepository>()
      .list(companyId: companyId, status: status);
  return Response.json(
    body: cancellations.map((record) => record.toJson()).toList(),
  );
}
