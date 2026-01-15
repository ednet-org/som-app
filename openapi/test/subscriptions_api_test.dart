import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SubscriptionsApi
void main() {
  final instance = Openapi().getSubscriptionsApi();

  group(SubscriptionsApi, () {
    // Request subscription cancellation
    //
    //Future subscriptionsCancelPost(SubscriptionsCancelPostRequest subscriptionsCancelPostRequest) async
    test('test subscriptionsCancelPost', () async {
      // TODO
    });

    // Resolve cancellation request
    //
    //Future subscriptionsCancellationsCancellationIdPut(String cancellationId, SubscriptionsCancellationsCancellationIdPutRequest subscriptionsCancellationsCancellationIdPutRequest) async
    test('test subscriptionsCancellationsCancellationIdPut', () async {
      // TODO
    });

    // List subscription cancellation requests
    //
    //Future<BuiltList<SubscriptionCancellation>> subscriptionsCancellationsGet({ String companyId, String status }) async
    test('test subscriptionsCancellationsGet', () async {
      // TODO
    });

    // Get current subscription
    //
    //Future<SubscriptionCurrent> subscriptionsCurrentGet() async
    test('test subscriptionsCurrentGet', () async {
      // TODO
    });

    // List subscription plans
    //
    //Future<SubscriptionsGet200Response> subscriptionsGet() async
    test('test subscriptionsGet', () async {
      // TODO
    });

    // Delete subscription plan
    //
    //Future subscriptionsPlansPlanIdDelete(String planId) async
    test('test subscriptionsPlansPlanIdDelete', () async {
      // TODO
    });

    // Get subscription plan
    //
    //Future<SubscriptionPlan> subscriptionsPlansPlanIdGet(String planId) async
    test('test subscriptionsPlansPlanIdGet', () async {
      // TODO
    });

    // Update subscription plan
    //
    //Future subscriptionsPlansPlanIdPut(String planId, SubscriptionPlanInput subscriptionPlanInput) async
    test('test subscriptionsPlansPlanIdPut', () async {
      // TODO
    });

    // Create subscription plan
    //
    //Future<SubscriptionPlan> subscriptionsPost(SubscriptionPlanInput subscriptionPlanInput) async
    test('test subscriptionsPost', () async {
      // TODO
    });

    // Upgrade subscription plan
    //
    //Future subscriptionsUpgradePost(SubscriptionsUpgradePostRequest subscriptionsUpgradePostRequest) async
    test('test subscriptionsUpgradePost', () async {
      // TODO
    });

  });
}
