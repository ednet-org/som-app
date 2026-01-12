import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:som/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntil(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (condition()) {
        return;
      }
    }
    throw TestFailure('Timed out waiting for condition');
  }

  testWidgets('UI login smoke flow', (tester) async {
    app.main();
    await tester.pump(const Duration(milliseconds: 200));

    final fieldsFinder = find.byType(TextFormField);
    await pumpUntil(
      tester,
      () => fieldsFinder.evaluate().length >= 2,
    );
    final emailField = fieldsFinder.at(0);
    final passwordField = fieldsFinder.at(1);

    await tester.enterText(
      emailField,
      const String.fromEnvironment(
        'SYSTEM_ADMIN_EMAIL',
        defaultValue: 'system-admin@som.local',
      ),
    );
    await tester.enterText(
      passwordField,
      const String.fromEnvironment(
        'SYSTEM_ADMIN_PASSWORD',
        defaultValue: 'ChangeMe123!',
      ),
    );

    final loginButton = find.text('Login');
    await pumpUntil(
      tester,
      () => loginButton.evaluate().isNotEmpty,
    );
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump(const Duration(milliseconds: 200));

    await pumpUntil(
      tester,
      () => find
          .byKey(const ValueKey('InquiriesManagementMenuItem'))
          .evaluate()
          .isNotEmpty,
    );
  });
}
