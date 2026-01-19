import 'package:flutter/material.dart';

import 'tokens.dart';

class SomTheme {
  SomTheme._();

  static const Color seedColor = Color(0xFF44546A);

  static ThemeData light({VisualDensity visualDensity = VisualDensity.standard}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    );

    return _base(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      visualDensity: visualDensity,
    );
  }

  static ThemeData dark({VisualDensity visualDensity = VisualDensity.standard}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    );

    return _base(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      visualDensity: visualDensity,
    );
  }

  static ThemeData _base({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required VisualDensity visualDensity,
  }) {
    final typography = Typography.material2021();
    final textTheme = (brightness == Brightness.dark
            ? typography.white
            : typography.black)
        .apply(fontFamily: 'Regular');

    final base = ThemeData.from(
      colorScheme: colorScheme,
      textTheme: textTheme,
      useMaterial3: true,
    ).copyWith(visualDensity: visualDensity);

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        space: 1,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: SomSpacing.sm,
          vertical: SomSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SomRadius.md),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SomSpacing.md,
          vertical: SomSpacing.xs,
        ),
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SomRadius.sm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SomRadius.sm),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SomRadius.sm),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SomRadius.md),
          ),
          minimumSize: const Size(0, SomSize.buttonHeight),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SomRadius.md),
          ),
          minimumSize: const Size(0, SomSize.buttonHeight),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, SomSize.buttonHeight),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(SomSize.minTouchTarget, SomSize.minTouchTarget),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
    );
  }
}
