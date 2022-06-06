import 'package:chopper/chopper.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';

part 'subscription_service.chopper.dart';

@ChopperApi(baseUrl: "/Subscriptions")
abstract class SubscriptionService extends ChopperService {
  // A helper method that helps instantiating the service. You can omit this method and use the generated class directly instead.
  static SubscriptionService create([ChopperClient? client]) =>
      _$SubscriptionService(client);

  @Get()
  Future<Response<List<Subscription>>> getSubscriptions();
}
