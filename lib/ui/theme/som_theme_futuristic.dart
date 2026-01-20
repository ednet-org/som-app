import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// Returns the "Corporate Futuristic" ThemeData for the SOM App.
/// Adheres to the "Slick" and "Minimalist" design language using strict Material 3.
ThemeData somFuturisticTheme({
  Brightness brightness = Brightness.dark,
  VisualDensity visualDensity = VisualDensity.standard,
}) {
  // Core Palette
  const seedColor = Color(0xFF38BDF8); // Electric Blue
  const secondary = Color(0xFF818CF8); // Indigo
  const error = Color(0xFFEF4444);

  final isDark = brightness == Brightness.dark;
  final background =
      isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  final surface = isDark ? const Color(0xFF1E293B) : Colors.white;
  final surfaceContainer =
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  final surfaceContainerHigh =
      isDark ? const Color(0xFF475569) : const Color(0xFFE5E7EB);
  final onBackground =
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  final onSurfaceVariant =
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
  final outline = isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

  // Generate M3 ColorScheme from seed, then override specific roles
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  ).copyWith(
    primary: seedColor,
    secondary: secondary,
    error: error,
    surface: surface,
    onSurface: onBackground,
    onSurfaceVariant: onSurfaceVariant,
    surfaceContainerLowest: surface,
    surfaceContainerLow: surface,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHigh,
    outline: outline,
    outlineVariant: outline.withValues(alpha: 0.7),
  );

  final baseTextTheme = (isDark
          ? Typography.material2021().white
          : Typography.material2021().black)
      .apply(fontFamily: 'Roboto');
  final textTheme = baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(
      fontSize: SomTypeScale.display,
      letterSpacing: -0.9,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: baseTextTheme.displayMedium?.copyWith(
      fontSize: SomTypeScale.display - 4,
      letterSpacing: -0.7,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: baseTextTheme.displaySmall?.copyWith(
      fontSize: SomTypeScale.headline,
      letterSpacing: -0.4,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: baseTextTheme.headlineLarge?.copyWith(
      fontSize: SomTypeScale.headline,
      letterSpacing: -0.3,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(
      fontSize: SomTypeScale.headline - 2,
      letterSpacing: -0.15,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(
      fontSize: SomTypeScale.title,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: baseTextTheme.titleLarge?.copyWith(
      fontSize: SomTypeScale.title,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: baseTextTheme.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: baseTextTheme.titleSmall?.copyWith(
      fontSize: SomTypeScale.body,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(
      fontSize: SomTypeScale.body,
      height: 1.5,
      letterSpacing: 0.2,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      fontSize: SomTypeScale.body,
      height: 1.5,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(
      fontSize: SomTypeScale.label,
      height: 1.4,
    ),
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      fontSize: SomTypeScale.label,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelMedium: baseTextTheme.labelMedium?.copyWith(
      fontSize: SomTypeScale.label - 1,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
    ),
    labelSmall: baseTextTheme.labelSmall?.copyWith(
      fontSize: SomTypeScale.label - 2,
      letterSpacing: 0.2,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'Roboto',
    visualDensity: visualDensity,

    textTheme: textTheme,

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Navigation Bar (Bottom)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: seedColor.withValues(alpha: 0.2),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: seedColor);
        }
        return IconThemeData(color: onSurfaceVariant);
      }),
    ),

    // Navigation Rail (Sidebar)
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: seedColor.withValues(alpha: 0.2),
      selectedIconTheme: const IconThemeData(color: seedColor),
      unselectedIconTheme: IconThemeData(color: onSurfaceVariant),
      labelType: NavigationRailLabelType.none,
      useIndicator: true,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: SomSpacing.sm,
        vertical: SomSpacing.xs,
      ),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SomRadius.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 0.6,
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLowest,
      contentPadding: SomDensityTokens.inputPadding(visualDensity),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SomRadius.sm),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SomRadius.sm),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SomRadius.sm),
        borderSide: const BorderSide(color: seedColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SomRadius.sm),
        borderSide: const BorderSide(color: error),
      ),
      labelStyle: TextStyle(color: onSurfaceVariant),
      hintStyle: TextStyle(color: onSurfaceVariant.withValues(alpha: 0.6)),
      prefixIconColor: onSurfaceVariant,
      suffixIconColor: onSurfaceVariant,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: SomDensityTokens.listTilePadding(visualDensity),
      minVerticalPadding: SomSpacing.xs,
      iconColor: onSurfaceVariant,
      textColor: onBackground,
      selectedColor: colorScheme.onPrimaryContainer,
      selectedTileColor:
          colorScheme.primaryContainer.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SomRadius.sm),
      ),
    ),

    // Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(0, SomSize.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(0, SomSize.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: seedColor,
        side: const BorderSide(color: seedColor, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(0, SomSize.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: seedColor,
        minimumSize: const Size(0, SomSize.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize:
            const Size(SomSize.minTouchTarget, SomSize.minTouchTarget),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: seedColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Dialogs
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SomRadius.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 0.6,
        ),
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: onBackground,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyMedium,
    ),

    // Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(SomRadius.lg)),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 0.6,
        ),
      ),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      thickness: 1,
      color: colorScheme.outlineVariant,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.surfaceContainer,
      selectedColor: colorScheme.primaryContainer,
      labelStyle: textTheme.labelMedium,
      secondaryLabelStyle: textTheme.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: SomSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SomRadius.full),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(SomRadius.sm),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      textStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.surfaceContainerHigh,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
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
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor:
          WidgetStateProperty.all(colorScheme.surfaceContainerHigh),
      dataRowColor: WidgetStateProperty.all(colorScheme.surface),
      headingTextStyle: textTheme.labelLarge,
      dataTextStyle: textTheme.bodySmall,
      dividerThickness: 1,
    ),
    // Icon Theme
    iconTheme: IconThemeData(
      color: onSurfaceVariant,
      size: 24,
    ),
  );
}
