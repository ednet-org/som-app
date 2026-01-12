import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String categoryId) async {
  if (context.request.method != HttpMethod.delete) {
    return Response(statusCode: 405);
  }
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  context.read<BranchRepository>().deleteCategory(categoryId);
  return Response(statusCode: 200);
}
