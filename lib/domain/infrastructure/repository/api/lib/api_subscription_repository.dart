import 'package:openapi/openapi.dart';

import '../../../../../ui/domain/infrastructure/i_repository.dart';

class ApiSubscriptionRepository extends IRepository<SubscriptionPlan> {
  final SubscriptionsApi subscriptionService;

  ApiSubscriptionRepository(this.subscriptionService);

  @override
  Future<List<SubscriptionPlan>> getAll() async {
    final response = await subscriptionService.subscriptionsGet();
    return response.data?.subscriptions?.toList() ?? [];
  }
}
