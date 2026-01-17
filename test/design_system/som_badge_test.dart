import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/theme/som_theme_futuristic.dart';
import 'package:som/ui/widgets/design_system/som_badge.dart';

void main() {
  testWidgets('SomBadge renders success variant correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomBadge(
            text: 'Active',
            type: SomBadgeType.success,
          ),
        ),
      ),
    );

    expect(find.text('ACTIVE'), findsOneWidget); // Uppercase
    expect(find.byType(SvgPicture), findsOneWidget); // Icon
    
    // Verify container color (approximate)
    final container = tester.widget<Container>(find.ancestor(
      of: find.text('ACTIVE'),
      matching: find.byType(Container),
    ).first);
    
    final decoration = container.decoration as BoxDecoration;
    // Success color defined in backlog as Emerald #10B981, usually mixed for bg
    // ensuring it's not null and has borderRadius
    expect(decoration.borderRadius, BorderRadius.circular(99)); 
  });

  testWidgets('SomBadge renders warning variant correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomBadge(
            text: 'Pending',
            type: SomBadgeType.warning,
          ),
        ),
      ),
    );

    expect(find.text('PENDING'), findsOneWidget);
  });
}
