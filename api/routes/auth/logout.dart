import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/auth_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final authResult = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (authResult == null) {
    return Response(statusCode: 401);
  }
  final header = context.request.headers['authorization'];
  if (header == null || !header.startsWith('Bearer ')) {
    return Response(statusCode: 401);
  }
  final token = header.substring(7);
  final auth = context.read<AuthService>();
  await auth.signOut(token);
  return Response.json(body: {'status': 'logged_out'});
}
