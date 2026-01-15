import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<InquiryRepository>();
  final inquiry = await repo.findById(inquiryId);
  if (inquiry == null) {
    return Response(statusCode: 404);
  }
  final isConsultant = auth.roles.contains('consultant');
  final isBuyer = auth.activeRole == 'buyer';
  final ownsInquiry = inquiry.buyerCompanyId == auth.companyId;
  if (!isConsultant && !(isBuyer && ownsInquiry)) {
    return Response(statusCode: 403);
  }
  await repo.closeInquiry(inquiryId, DateTime.now().toUtc());
  return Response(statusCode: 200);
}
