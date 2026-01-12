import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<InquiryRepository>();
  final inquiry = repo.findById(inquiryId);
  if (inquiry == null) {
    return Response(statusCode: 404);
  }
  return Response.json(body: inquiry.toJson());
}
