import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final users = await context.read<UserRepository>().listByCompany(companyId);
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
