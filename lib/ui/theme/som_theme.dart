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
        color: colorScheme.surfaceContainerLow,
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
        contentPadding: SomDensityTokens.listTilePadding(visualDensity),
        minVerticalPadding: SomSpacing.xs,
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        selectedTileColor:
            colorScheme.primaryContainer.withValues(alpha: 0.3),
        hoverColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SomRadius.sm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: SomDensityTokens.inputPadding(visualDensity),
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
        backgroundColor: colorScheme.surfaceContainerHigh,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(SomRadius.sm),
          border: BorderSide(color: colorScheme.outlineVariant),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
        ),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        visualDensity: visualDensity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SomRadius.sm),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.outline,
        ),
        visualDensity: visualDensity,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: 0.4)
              : colorScheme.surfaceContainerHighest,
        ),
        visualDensity: visualDensity,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor:
            WidgetStateProperty.all(colorScheme.surfaceContainerHigh),
        dataRowColor: WidgetStateProperty.all(colorScheme.surface),
        headingTextStyle: textTheme.labelLarge,
        dataTextStyle: textTheme.bodySmall,
        dividerThickness: 1,
      ),
    );
  }
}
