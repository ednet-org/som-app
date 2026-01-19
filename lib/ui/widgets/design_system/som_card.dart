import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';

class SomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isFeatured;

  const SomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor =
        theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    return Card(
      color: cardColor,
      shape: theme.cardTheme.shape,
      clipBehavior: theme.cardTheme.clipBehavior,
      margin: theme.cardTheme.margin,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: kIsWeb
                  ? Container(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                    )
                  : SvgPicture.asset(
                      SomAssets.patternDotNoise,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (isFeatured)
            Positioned.fill(
              child: Opacity(
                opacity: 0.5, // Subtle overlay
                child: SvgPicture.asset(
                  SomAssets.patternSubtleMesh,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
