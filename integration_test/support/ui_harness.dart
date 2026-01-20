import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder findLoginFields() => find.byType(TextFormField);

Finder findTextFormField(String labelText) {
  return find.ancestor(
    of: find.text(labelText),
    matching: find.byType(TextFormField),
  );
}

Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 45),
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

Future<void> loginUi(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  final fieldsFinder = findLoginFields();
  await pumpUntil(tester, () => fieldsFinder.evaluate().length >= 2);
  final emailField = fieldsFinder.at(0);
  final passwordField = fieldsFinder.at(1);

  await tester.enterText(emailField, email);
  await tester.enterText(passwordField, password);

  final loginButton = find.text('Login');
  await pumpUntil(tester, () => loginButton.evaluate().isNotEmpty);
  await tester.ensureVisible(loginButton);
  await tester.tap(loginButton);
  await tester.pump(const Duration(milliseconds: 200));
}

String? snackMessage(WidgetTester tester) {
  final snackBarFinder = find.byType(SnackBar);
  if (snackBarFinder.evaluate().isEmpty) return null;
  final textFinder = find.descendant(
    of: snackBarFinder,
    matching: find.byType(Text),
  );
  final messages = textFinder.evaluate().map((element) {
    final textWidget = element.widget as Text;
    return textWidget.data ?? '';
  }).where((text) => text.isNotEmpty).toList();
  if (messages.isEmpty) return null;
  return messages.join(' ');
}
