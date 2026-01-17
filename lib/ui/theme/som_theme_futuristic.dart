import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Returns the "Corporate Futuristic" ThemeData for the SOM App.
/// Adheres to the "Slick" and "Minimalist" design language using strict Material 3.
ThemeData somFuturisticTheme() {
  // Core Palette
  const seedColor = Color(0xFF38BDF8); // Electric Blue
  const secondary = Color(0xFF818CF8); // Indigo
  const background = Color(0xFF0F172A); // Deep Slate (bg-primary)
  const surface = Color(0xFF1E293B); // Lighter Slate (bg-secondary)
  const surfaceVariant = Color(0xFF334155); // Tertiary/Hover
  const error = Color(0xFFEF4444);
  const onBackground = Color(0xFFF8FAFC); // text-primary
  const onSurfaceVariant = Color(0xFF94A3B8); // text-secondary

  // Generate M3 ColorScheme from seed, then override specific roles
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
    primary: seedColor,
    secondary: secondary,
    surface: surface,
    // surfaceTint: Colors.transparent, // Disable tint if preferred, but M3 uses it
    error: error,
    onSurface: onBackground,
    onSurfaceVariant: onSurfaceVariant,
    tertiary: surfaceVariant,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'Roboto',

    // Typography: Tight tracking for headings
    textTheme: const TextTheme(
      displayLarge: TextStyle(letterSpacing: -1.0, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(letterSpacing: -1.0, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(height: 1.5, letterSpacing: 0.15),
      bodyMedium: TextStyle(height: 1.5, letterSpacing: 0.25),
      labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.0), // Buttons
    ),

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
        side: const BorderSide(color: Colors.white10, width: 0.5),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4), topRight: Radius.circular(4)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white10),
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
        side: const BorderSide(color: Colors.white10, width: 0.5),
      ),
      titleTextStyle: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: onBackground),
    ),

    // Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Colors.white10, width: 0.5),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      thickness: 0.5,
      color: Colors.white10,
      space: 1,
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: onSurfaceVariant,
      size: 24,
    ),
  );
}
