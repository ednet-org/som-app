import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.get) {
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
  if (authResult.companyId != companyId) {
    return Response(statusCode: 403);
  }
  final repo = context.read<UserRepository>();
  late final List users;
  if (authResult.roles.contains('admin')) {
    users = await repo.listByCompany(companyId);
  } else {
    final user = await repo.findById(authResult.userId);
    if (user == null) {
      return Response(statusCode: 403);
    }
    users = [user];
  }
  final body = users
      .map((user) => {
            'email': user.email,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'salutation': user.salutation,
            'roles': user.roles.map(roleToWire).toList(),
            'telephoneNr': user.telephoneNr,
            'title': user.title,
            'companyId': user.companyId,
            'id': user.id,
          })
      .toList();
  return Response.json(body: body);
}
