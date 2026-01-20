import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openapi/openapi.dart';
import 'package:som/main.dart' as app;
import 'package:som/ui/pages/inquiry/widgets/inquiry_create_form.dart';
import 'package:som/ui/widgets/design_system/som_button.dart';

import 'support/test_env.dart';
import 'support/ui_harness.dart';

const _apiBaseUrl = TestEnv.apiBaseUrl;
const _buyerEmail = TestEnv.buyerAdminEmail;
const _consultantEmail = TestEnv.consultantAdminEmail;
const _password = TestEnv.devFixturesPassword;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Buyer can create inquiry', (tester) async {
    final api = Openapi(
      dio: Dio(BaseOptions(baseUrl: _apiBaseUrl)),
      serializers: standardSerializers,
    );

    final consultantToken = await _login(api, _consultantEmail, _password);
    final branchesResponse = await api.getBranchesApi().branchesGet();
    final branches = branchesResponse.data?.toList() ?? const [];
    final asciiName = RegExp(r'^[a-zA-Z0-9\\s]+$');
    Branch branch = branches.firstWhere(
      (b) =>
          b.id != null &&
          b.name != null &&
          asciiName.hasMatch(b.name!) &&
          b.categories?.isNotEmpty == true,
      orElse: () => Branch(),
    );
    Category category = Category();
    if (branch.id == null) {
      final stamp = DateTime.now().millisecondsSinceEpoch;
      branch = await _ensureBranch(api, consultantToken, 'E2E Branch $stamp');
      category = await _ensureCategory(
        api,
        consultantToken,
        branch.id!,
        'E2E Category $stamp',
      );
    } else {
      final activeCategory = branch.categories?.firstWhere(
        (c) =>
            c.status == 'active' &&
            c.name != null &&
            asciiName.hasMatch(c.name!),
        orElse: () => Category(),
      );
      category = activeCategory ?? branch.categories!.first;
      if (category.id == null) {
        final stamp = DateTime.now().millisecondsSinceEpoch;
        category = await _ensureCategory(
          api,
          consultantToken,
          branch.id!,
          'E2E Category $stamp',
        );
      }
    }

    app.main();
    await pumpUntil(tester, () => findLoginFields().evaluate().length >= 2);

    await loginUi(tester, email: _buyerEmail, password: _password);
    await pumpUntil(
      tester,
      () => find.text('Inquiries').evaluate().isNotEmpty,
    );

    final newInquiryButton = find.text('New inquiry');
    await pumpUntil(tester, () => newInquiryButton.evaluate().isNotEmpty);
    await tester.ensureVisible(newInquiryButton);
    await tester.tap(newInquiryButton);
    await tester.pumpAndSettle();
    await pumpUntil(
      tester,
      () => find.text('Close form').evaluate().isNotEmpty,
    );

    final branchName = branch.name ?? branch.id!;
    final branchField = findTextFormField('Branch *');
    await tester.tap(branchField);
    await tester.pumpAndSettle();
    await tester.enterText(branchField, branchName);
    await tester.pumpAndSettle();
    final categoryGate = find
        .descendant(
          of: find.byType(InquiryCreateForm),
          matching: find.byType(IgnorePointer),
        )
        .first;
    await pumpUntil(
      tester,
      () => !tester.widget<IgnorePointer>(categoryGate).ignoring,
    );

    final categoryName = category.name ?? category.id!;
    final categoryField = findTextFormField('Category *');
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.enterText(categoryField, categoryName);
    await tester.pumpAndSettle();

    final deadlineButton = find.byWidgetPredicate(
      (widget) => widget is SomButton && widget.text == 'Select deadline',
    );
    await tester.tap(deadlineButton);
    await tester.pumpAndSettle();
    final now = DateTime.now();
    final targetDate = now.add(const Duration(days: 7));
    if (targetDate.month != now.month || targetDate.year != now.year) {
      final nextMonth = find.byTooltip('Next month');
      if (nextMonth.evaluate().isNotEmpty) {
        await tester.tap(nextMonth);
        await tester.pumpAndSettle();
      }
    }
    await tester.tap(find.text('${targetDate.day}').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.enterText(
      findTextFormField('Delivery ZIPs (comma separated) *'),
      '1010',
    );
    await tester.enterText(
      findTextFormField('Description'),
      'E2E inquiry ${DateTime.now().millisecondsSinceEpoch}',
    );

    final createInquiryButton = find.byWidgetPredicate(
      (widget) => widget is SomButton && widget.text == 'Create inquiry',
    );
    final formScrollable = find
        .descendant(
          of: find.byType(InquiryCreateForm),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      createInquiryButton,
      240,
      scrollable: formScrollable,
    );
    await tester.tap(createInquiryButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final submitDeadline = DateTime.now().add(const Duration(seconds: 45));
    while (DateTime.now().isBefore(submitDeadline)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (find.text('New inquiry').evaluate().isNotEmpty) {
        expect(find.text('Close form'), findsNothing);
        return;
      }
      final snack = snackMessage(tester);
      if (snack != null &&
          snack.isNotEmpty &&
          !snack.toLowerCase().contains('created')) {
        fail('Inquiry submit failed: $snack');
      }
    }
    fail('Timed out waiting for inquiry submission to finish.');
  });
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
