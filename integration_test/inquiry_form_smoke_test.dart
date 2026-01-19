import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openapi/openapi.dart';
import 'package:som/main.dart' as app;

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);
const _buyerEmail = String.fromEnvironment(
  'BUYER_ADMIN_EMAIL',
  defaultValue: 'buyer-admin@som.local',
);
const _consultantEmail = String.fromEnvironment(
  'CONSULTANT_ADMIN_EMAIL',
  defaultValue: 'consultant-admin@som.local',
);
const _password = String.fromEnvironment(
  'DEV_FIXTURES_PASSWORD',
  defaultValue: 'DevPass123!',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Buyer can create inquiry', (tester) async {
    final api = Openapi(
      dio: Dio(BaseOptions(baseUrl: _apiBaseUrl)),
      serializers: standardSerializers,
    );

    final consultantToken = await _login(api, _consultantEmail, _password);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final branchName = 'E2E Branch $stamp';
    final categoryName = 'E2E Category $stamp';
    final branch = await _ensureBranch(api, consultantToken, branchName);
    final category = await _ensureCategory(
      api,
      consultantToken,
      branch.id!,
      categoryName,
    );

    app.main();
    await _pumpUntil(tester, () => _findLoginFields().evaluate().length >= 2);

    await _loginUi(tester, _buyerEmail, _password);
    await _pumpUntil(
      tester,
      () => find.text('Inquiries').evaluate().isNotEmpty,
    );

    final newInquiryButton = find.text('New inquiry');
    await tester.tap(newInquiryButton);
    await tester.pumpAndSettle();

    await tester.enterText(
      _findTextFormField('Branch *'),
      branch.name ?? branch.id!,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      _findTextFormField('Category *'),
      category.name ?? category.id!,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('SELECT DEADLINE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.enterText(
      _findTextFormField('Delivery ZIPs (comma separated) *'),
      '1010',
    );
    await tester.enterText(
      _findTextFormField('Description'),
      'E2E inquiry $stamp',
    );

    await tester.tap(find.text('CREATE INQUIRY'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Inquiry created.'), findsOneWidget);
  });
}

Finder _findTextFormField(String labelText) {
  return find.ancestor(
    of: find.text(labelText),
    matching: find.byType(TextFormField),
  );
}

Finder _findLoginFields() => find.byType(TextFormField);

Future<void> _loginUi(
  WidgetTester tester,
  String email,
  String password,
) async {
  final fieldsFinder = _findLoginFields();
  await _pumpUntil(tester, () => fieldsFinder.evaluate().length >= 2);
  final emailField = fieldsFinder.at(0);
  final passwordField = fieldsFinder.at(1);

  await tester.enterText(emailField, email);
  await tester.enterText(passwordField, password);

  final loginButton = find.text('Login');
  await _pumpUntil(tester, () => loginButton.evaluate().isNotEmpty);
  await tester.ensureVisible(loginButton);
  await tester.tap(loginButton);
  await tester.pump(const Duration(milliseconds: 200));
}

Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 30),
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

Future<String> _login(Openapi api, String email, String password) async {
  final request = AuthLoginPostRequestBuilder()
    ..email = email
    ..password = password;
  final response = await api.getAuthApi().authLoginPost(
        authLoginPostRequest: request.build(),
      );
  final token = response.data?.token;
  if (token == null || token.isEmpty) {
    throw StateError('Failed to login as $email');
  }
  return token;
}

Map<String, String> _authHeader(String? token) {
  if (token == null || token.isEmpty) return {};
  return {'Authorization': 'Bearer $token'};
}

Future<Branch> _ensureBranch(Openapi api, String token, String name) async {
  final response = await api.getBranchesApi().branchesGet();
  final existing = response.data
      ?.firstWhere((b) => b.name == name, orElse: () => Branch());
  if (existing != null && existing.id != null) {
    return existing;
  }
  final created = await api.getBranchesApi().branchesPost(
        headers: _authHeader(token),
        branchesPostRequest: BranchesPostRequest((b) => b..name = name),
      );
  final branch = created.data;
  if (branch == null || branch.id == null) {
    throw StateError('Failed to create branch');
  }
  return branch;
}

Future<Category> _ensureCategory(
  Openapi api,
  String token,
  String branchId,
  String name,
) async {
  final branches = await api.getBranchesApi().branchesGet();
  final branch = branches.data
      ?.firstWhere((b) => b.id == branchId, orElse: () => Branch());
  final existing = branch?.categories
      ?.firstWhere((c) => c.name == name, orElse: () => Category());
  if (existing != null && existing.id != null) {
    return existing;
  }
  final created = await api.getBranchesApi().branchesBranchIdCategoriesPost(
        branchId: branchId,
        headers: _authHeader(token),
        branchesPostRequest: BranchesPostRequest((b) => b..name = name),
      );
  final category = created.data;
  if (category == null || category.id == null) {
    throw StateError('Failed to create category');
  }
  return category;
}
