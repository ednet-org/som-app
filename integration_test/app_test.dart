import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openapi/openapi.dart';

import 'support/api_helpers.dart';
import 'support/test_env.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('API integration via OpenAPI client', (tester) async {
    final api = buildApi();

    final auth = api.getAuthApi();
    final loginRequest = AuthLoginPostRequestBuilder()
      ..email = TestEnv.systemAdminEmail
      ..password = TestEnv.systemAdminPassword;
    final result = await auth.authLoginPost(
      authLoginPostRequest: loginRequest.build(),
    );
    expect(result.data?.token, isNotNull);

    final subscriptions = await api.getSubscriptionsApi().subscriptionsGet();
    expect(subscriptions.data?.subscriptions?.isNotEmpty, true);
  });
}
