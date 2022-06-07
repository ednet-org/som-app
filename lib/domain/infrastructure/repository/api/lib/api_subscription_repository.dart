import 'package:som/domain/core/model/i_repository.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';
import 'package:som/domain/infrastructure/repository/api/lib/subscription_service.dart';

class ApiSubscriptionRepository extends IRepository<Subscription> {
  final SubscriptionService subscriptionService;

  ApiSubscriptionRepository(this.subscriptionService);

  @override
  Future<List<Subscription>> getAll() async {
    final response = await subscriptionService.getSubscriptions();

    return response.body ?? [];
  }
}
