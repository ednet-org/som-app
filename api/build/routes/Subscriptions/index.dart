import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/subscription_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final repository = context.read<SubscriptionRepository>();
  final plans = repository.listPlans();
  final body = {
    'subscriptions': plans.map((plan) => plan.toDtoJson()).toList(),
  };
  return Response.json(body: body);
}
