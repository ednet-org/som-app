import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
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
  final isConsultant = auth.roles.contains('consultant');
  final isAdmin = auth.roles.contains('admin') && auth.companyId == companyId;
  if (!isConsultant && !isAdmin) {
    return Response(statusCode: 403);
  }
  final profile =
      await context.read<ProviderRepository>().findByCompany(companyId);
  if (profile == null) {
    return Response(statusCode: 404);
  }
  return Response.json(
    body: {
      'companyId': profile.companyId,
      'bankDetails': profile.bankDetails.toJson(),
      'branchIds': profile.branchIds,
      'pendingBranchIds': profile.pendingBranchIds,
      'subscriptionPlanId': profile.subscriptionPlanId,
      'paymentInterval': profile.paymentInterval,
      'providerType': profile.providerType,
      'status': profile.status,
      'rejectionReason': profile.rejectionReason,
      'rejectedAt': profile.rejectedAt?.toIso8601String(),
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt.toIso8601String(),
    },
  );
}
