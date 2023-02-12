import 'package:openapi/openapi.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';

import '../../../../../ui/domain/i_repository.dart';

class ApiSubscriptionRepository extends IRepository<Subscription> {
  final SubscriptionsApi subscriptionService;

  ApiSubscriptionRepository(this.subscriptionService);

  @override
  Future<List<Subscription>> getAll() async {
    final response = await subscriptionService.subscriptionsGet();

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map((e) => Subscription(
              e["id"],
              isActive: e["isActive"] == true,
              priceInSubunit: e["priceInSubunit"],
              rules: e["rules"],
            ))
        .toList();
  }
}
