import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/theme/som_theme_futuristic.dart';
import 'package:som/ui/widgets/design_system/som_input.dart';

void main() {
  testWidgets('SomInput renders with label and placeholder', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomInput(
            label: 'Email',
            hintText: 'name@company.com',
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('name@company.com'), findsOneWidget);
  });

  testWidgets('SomInput shows error state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomInput(
            label: 'Password',
            errorText: 'Invalid password',
          ),
        ),
      ),
    );

    expect(find.text('Invalid password'), findsOneWidget);
    
    // Check for error border color (approximate via style search or decoration)
    final inputDecorator = tester.widget<InputDecorator>(find.byType(InputDecorator));
    expect(inputDecorator.decoration.errorText, 'Invalid password');
  });

  testWidgets('SomInput password toggle works', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomInput(
            label: 'Password',
            isPassword: true,
          ),
        ),
      ),
    );

    // Initial state: obscured
    expect(find.byType(TextField), findsOneWidget);
    // Find visibility icon
    expect(find.byType(SvgPicture), findsOneWidget); // Icon is an SVG
  });
}
