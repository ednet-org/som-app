import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/theme/som_theme_futuristic.dart';
import 'package:som/ui/widgets/design_system/som_button.dart';

void main() {
  testWidgets('SomButton renders Primary variant correctly', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: Scaffold(
          body: SomButton(
            text: 'Sign In',
            onPressed: () => pressed = true,
            type: SomButtonType.primary,
          ),
        ),
      ),
    );

    // Verify text
    expect(find.text('SIGN IN'), findsOneWidget); // Expecting uppercase

    // Verify background gradient (indirectly via type) or color
    // Note: verifying gradient background on ElevatedButton is tricky in widget tests
    // without inspecting the Container decoration inside, but we verify the widget type usage.

    // Verify tap
    await tester.tap(find.byType(SomButton));
    expect(pressed, true);
  });

  testWidgets('SomButton renders Secondary variant correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: Scaffold(
          body: SomButton(
            text: 'Cancel',
            onPressed: () {},
            type: SomButtonType.secondary,
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
  });

  testWidgets('SomButton renders Ghost variant correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: Scaffold(
          body: SomButton(
            text: 'Skip',
            onPressed: () {},
            type: SomButtonType.ghost,
          ),
        ),
      ),
    );

    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('SomButton renders icons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: Scaffold(
          body: SomButton(
            text: 'Next',
            onPressed: () {},
            icon: SomAssets.iconChevronRight,
            iconPosition: SomButtonIconPosition.right,
          ),
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
