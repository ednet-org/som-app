import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
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
  // Allow consultants or any admin (buyer or provider) to view their company's subscription
  if (!auth.roles.contains('consultant') && !auth.roles.contains('admin')) {
    return Response(statusCode: 403);
  }
  final repository = context.read<SubscriptionRepository>();
  final subscription =
      await repository.findSubscriptionByCompany(auth.companyId);
  if (subscription == null) {
    return Response(statusCode: 404);
  }
  final plan = await repository.findPlanById(subscription.planId);
  return Response.json(
    body: {
      'subscription': {
        'companyId': subscription.companyId,
        'planId': subscription.planId,
        'status': subscription.status,
        'paymentInterval': subscription.paymentInterval,
        'startDate': subscription.startDate.toIso8601String(),
        'endDate': subscription.endDate.toIso8601String(),
        'createdAt': subscription.createdAt.toIso8601String(),
      },
      'plan': plan?.toDtoJson(),
    },
  );
}
