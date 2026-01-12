import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openapi/openapi.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('API integration via OpenAPI client', (tester) async {
    final api = Openapi(
      dio: Dio(BaseOptions(baseUrl: apiBaseUrl)),
      serializers: standardSerializers,
    );

    final auth = api.getAuthApi();
    final loginRequest = AuthLoginPostRequestBuilder()
      ..email = const String.fromEnvironment(
        'SYSTEM_ADMIN_EMAIL',
        defaultValue: 'system-admin@som.local',
      )
      ..password = const String.fromEnvironment(
        'SYSTEM_ADMIN_PASSWORD',
        defaultValue: 'ChangeMe123!',
      );
    final result = await auth.authLoginPost(
      authLoginPostRequest: loginRequest.build(),
    );
    expect(result.data?.token, isNotNull);

    final subscriptions = await api.getSubscriptionsApi().subscriptionsGet();
    expect(subscriptions.data?.subscriptions?.isNotEmpty, true);
  });
}
