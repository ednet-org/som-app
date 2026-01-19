import 'package:flutter/material.dart';

import '../theme/semantic_colors.dart';
import '../theme/som_assets.dart';
import '../theme/tokens.dart';
import 'design_system/som_svg_icon.dart';

enum SomSnackType { info, success, warning, error }

/// Shared helpers for consistent SnackBar styling.
class SomSnackBars {
  SomSnackBars._();

  static void show(
    BuildContext context, {
    required String message,
    SomSnackType type = SomSnackType.info,
  }) {
    final theme = Theme.of(context);
    final icon = _iconForType(type);
    final color = _colorForType(type);
    final background = SomSemanticColors.backgroundFor(
      color,
      theme.colorScheme,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: background,
        content: Row(
          children: [
            SomSvgIcon(
              icon,
              size: SomIconSize.sm,
              color: color,
              semanticLabel: '${type.name} notification',
            ),
            const SizedBox(width: SomSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: SomSnackType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: SomSnackType.error);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: SomSnackType.warning);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: SomSnackType.info);

  static String _iconForType(SomSnackType type) {
    return switch (type) {
      SomSnackType.success => SomAssets.offerStatusAccepted,
      SomSnackType.warning => SomAssets.iconWarning,
      SomSnackType.error => SomAssets.iconClose,
      SomSnackType.info => SomAssets.iconInfo,
    };
  }

  static Color _colorForType(SomSnackType type) {
    return switch (type) {
      SomSnackType.success => SomSemanticColors.success,
      SomSnackType.warning => SomSemanticColors.warning,
      SomSnackType.error => SomSemanticColors.error,
      SomSnackType.info => SomSemanticColors.info,
    };
  }
}
