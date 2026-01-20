import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/theme/som_assets.dart';
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
    final context = tester.element(find.byType(SomCard));
    final theme = Theme.of(context);
    final expectedColor =
        theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    expect(card.color, expectedColor);
    expect(card.clipBehavior, Clip.antiAlias);
    
    final shape = card.shape as RoundedRectangleBorder;
    final expectedShape =
        (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius;
    expect(shape.borderRadius, expectedShape);
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

    final meshFinder = find.byWidgetPredicate((widget) {
      if (widget is! SvgPicture) return false;
      final loader = widget.bytesLoader;
      return loader is SvgAssetLoader &&
          loader.assetName == SomAssets.patternSubtleMesh;
    });

    expect(meshFinder, findsOneWidget);
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
