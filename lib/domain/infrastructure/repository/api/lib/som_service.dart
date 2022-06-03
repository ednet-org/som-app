import 'package:chopper/chopper.dart';

import '../models/subscription.dart';

part '../som_service.chopper.dart';

@ChopperApi(baseUrl: "/Subscriptions")
abstract class SomService extends ChopperService {
  // A helper method that helps instantiating the service. You can omit this method and use the generated class directly instead.
  static SomService create([ChopperClient? client]) => _$SomService(client);

  @Get()
  Future<Response<List<Subscription>>> getSubscriptions();
}
