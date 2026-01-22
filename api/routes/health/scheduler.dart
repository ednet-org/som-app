import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/scheduler_status_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/access_control.dart';
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
  if (auth == null || !isConsultantAdmin(auth)) {
    return Response(statusCode: 403);
  }
  final entries = await context.read<SchedulerStatusRepository>().listAll();
  final body = entries
      .map((entry) => {
            'jobName': entry.jobName,
            'lastRunAt': entry.lastRunAt?.toIso8601String(),
            'lastSuccessAt': entry.lastSuccessAt?.toIso8601String(),
            'lastError': entry.lastError,
            'updatedAt': entry.updatedAt.toIso8601String(),
          })
      .toList();
  return Response.json(body: body);
}
