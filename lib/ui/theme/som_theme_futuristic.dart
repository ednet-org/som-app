import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final surfaceVariant =
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  final onBackground =
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  final onSurfaceVariant =
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

  // Generate M3 ColorScheme from seed, then override specific roles
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    primary: seedColor,
    secondary: secondary,
    surface: surface,
    error: error,
    onSurface: onBackground,
    onSurfaceVariant: onSurfaceVariant,
    tertiary: surfaceVariant,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'Roboto',
    visualDensity: visualDensity,

    // Typography: Tight tracking for headings
    textTheme: (isDark
            ? Typography.material2021().white
            : Typography.material2021().black)
        .apply(fontFamily: 'Roboto')
        .copyWith(
          displayLarge: const TextStyle(
              letterSpacing: -1.0, fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(
              letterSpacing: -1.0, fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(
              letterSpacing: -0.5, fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(
              letterSpacing: -0.5, fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(
              letterSpacing: -0.5, fontWeight: FontWeight.w600),
          headlineSmall: const TextStyle(fontWeight: FontWeight.w600),
          titleLarge: const TextStyle(fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(height: 1.5, letterSpacing: 0.15),
          bodyMedium: const TextStyle(height: 1.5, letterSpacing: 0.25),
          labelLarge: const TextStyle(
              fontWeight: FontWeight.w600, letterSpacing: 1.0), // Buttons
        ),

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: onBackground),
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
    ),

    // Navigation Bar (Bottom)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface.withValues(alpha: 0.8), // Glass-like
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
      backgroundColor: background,
      indicatorColor: seedColor.withValues(alpha: 0.2),
      selectedIconTheme: const IconThemeData(color: seedColor),
      unselectedIconTheme: IconThemeData(color: onSurfaceVariant),
      labelType: NavigationRailLabelType.none,
      useIndicator: true,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0, // M3 style often uses tonal elevation or outline
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 0.5,
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant.withValues(alpha: isDark ? 0.3 : 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: isDark ? Colors.white10 : Colors.black12),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: seedColor, width: 1.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: error),
      ),
      labelStyle: TextStyle(color: onSurfaceVariant),
      hintStyle: TextStyle(color: onSurfaceVariant.withValues(alpha: 0.5)),
      prefixIconColor: onSurfaceVariant,
      suffixIconColor: onSurfaceVariant,
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: seedColor,
        side: const BorderSide(color: seedColor, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: seedColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 0.5,
        ),
      ),
      titleTextStyle: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: onBackground),
    ),

    // Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 0.5,
        ),
      ),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      thickness: 0.5,
      color: isDark ? Colors.white10 : Colors.black12,
      space: 1,
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: onSurfaceVariant,
      size: 24,
    ),
  );
}
