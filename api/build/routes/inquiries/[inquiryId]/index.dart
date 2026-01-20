import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/access_control.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method != HttpMethod.get) {
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
  if (!isConsultant(auth)) {
    if (auth.activeRole == 'provider') {
      final provider = await context
          .read<ProviderRepository>()
          .findByCompany(auth.companyId);
      if (provider == null || provider.status != 'active') {
        return Response.json(
          statusCode: 403,
          body: 'Provider registration is pending.',
        );
      }
      final assigned = await repo.isAssignedToProvider(
        inquiryId,
        auth.companyId,
      );
      if (!assigned) {
        return Response.json(
          statusCode: 403,
          body: 'Inquiry not assigned to provider.',
        );
      }
    } else if (auth.activeRole == 'buyer') {
      if (inquiry.buyerCompanyId != auth.companyId) {
        return Response(statusCode: 403);
      }
    } else {
      return Response(statusCode: 403);
    }
  }
  return Response.json(body: inquiry.toJson());
}
