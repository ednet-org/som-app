import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/theme/som_theme_futuristic.dart';
import 'package:som/ui/widgets/design_system/som_card.dart';

void main() {
  testWidgets('SomCard renders content and applies styling', (tester) async {
    const childKey = Key('child');
    
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomCard(
            child: Text('Card Content', key: childKey),
          ),
        ),
      ),
    );

    // Verify content is rendered
    expect(find.byKey(childKey), findsOneWidget);
    expect(find.text('Card Content'), findsOneWidget);

    // Verify Styling
    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, const Color(0xFF1E293B)); // surface/bg-secondary
    expect(card.clipBehavior, Clip.antiAlias);
    
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(16));
  });

  testWidgets('SomCard shows mesh background when isFeatured is true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomCard(
            isFeatured: true,
            child: Text('Featured Card'),
          ),
        ),
      ),
    );

    // Should find SVG picture for the mesh pattern
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('SomCard has correct padding', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: somFuturisticTheme(),
        home: const Scaffold(
          body: SomCard(
            padding: EdgeInsets.all(32),
            child: Text('Padded Content'),
          ),
        ),
      ),
    );

    final padding = tester.widget<Padding>(find.ancestor(
      of: find.text('Padded Content'),
      matching: find.byType(Padding),
    ).first);

    expect(padding.padding, const EdgeInsets.all(32));
  });
}
