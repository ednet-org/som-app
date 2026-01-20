import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:som/main.dart' as app;

import 'support/test_env.dart';
import 'support/ui_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('UI login smoke flow', (tester) async {
    app.main();
    await tester.pump(const Duration(milliseconds: 200));

    final fieldsFinder = findLoginFields();
    await pumpUntil(
      tester,
      () => fieldsFinder.evaluate().length >= 2,
    );
    await loginUi(
      tester,
      email: TestEnv.systemAdminEmail,
      password: TestEnv.systemAdminPassword,
    );

    await pumpUntil(
      tester,
      () => find.text('Inquiries').evaluate().isNotEmpty,
    );
  });
}
