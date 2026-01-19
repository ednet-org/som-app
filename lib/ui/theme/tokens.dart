/// Design tokens for consistent spacing, sizing, and styling.
///
/// These tokens provide a single source of truth for visual consistency
/// across the application.
library;

import 'package:flutter/material.dart';

/// Spacing scale following 4px base unit
class SomSpacing {
  SomSpacing._();

  /// 4px - Extra small (tight spacing)
  static const double xs = 4.0;

  /// 8px - Small (default inline spacing)
  static const double sm = 8.0;

  /// 16px - Medium (default section spacing)
  static const double md = 16.0;

  /// 24px - Large (section separation)
  static const double lg = 24.0;

  /// 32px - Extra large (major sections)
  static const double xl = 32.0;

  /// 48px - 2X large (page padding)
  static const double xxl = 48.0;
}

/// Border radius scale
class SomRadius {
  SomRadius._();

  /// 4px - Subtle rounding
  static const double sm = 4.0;

  /// 8px - Default rounding
  static const double md = 8.0;

  /// 12px - Pronounced rounding
  static const double lg = 12.0;

  /// 16px - Large rounding
  static const double xl = 16.0;

  /// 999px - Full/pill rounding
  static const double full = 999.0;
}

/// Icon sizes
class SomIconSize {
  SomIconSize._();

  /// 16px - Small icons (inline)
  static const double sm = 16.0;

  /// 20px - Default icon size
  static const double md = 20.0;

  /// 24px - Large icons
  static const double lg = 24.0;

  /// 32px - Extra large icons
  static const double xl = 32.0;

  /// 48px - Hero icons
  static const double xxl = 48.0;
}

/// Common sizing constraints
class SomSize {
  SomSize._();

  /// Minimum touch target (48x48 for accessibility)
  static const double minTouchTarget = 48.0;

  /// Default avatar size
  static const double avatar = 40.0;

  /// Small avatar size
  static const double avatarSm = 32.0;

  /// Large avatar size
  static const double avatarLg = 56.0;

  /// Default button height
  static const double buttonHeight = 44.0;

  /// Input field height
  static const double inputHeight = 48.0;

  /// Card minimum width
  static const double cardMinWidth = 280.0;

  /// Card maximum width
  static const double cardMaxWidth = 400.0;

  /// Detail panel width
  static const double detailPanelWidth = 400.0;

  /// Form max width
  static const double formMaxWidth = 600.0;
}

/// Animation durations
class SomDuration {
  SomDuration._();

  /// 100ms - Micro interactions
  static const Duration fast = Duration(milliseconds: 100);

  /// 200ms - Default transitions
  static const Duration normal = Duration(milliseconds: 200);

  /// 300ms - Deliberate animations
  static const Duration slow = Duration(milliseconds: 300);

  /// 500ms - Complex animations
  static const Duration slower = Duration(milliseconds: 500);
}

/// Typography scale tokens aligned with Material 3 type roles.
class SomTypeScale {
  SomTypeScale._();

  static const double display = 32;
  static const double headline = 24;
  static const double title = 18;
  static const double body = 14;
  static const double label = 12;
}

/// Breakpoints used for responsive layouts.
class SomBreakpoints {
  SomBreakpoints._();

  static const double navigationRail = 1100;
  static const double navigationBar = 720;
  static const double listDetailSplit = 900;
  static const double filterCollapse = 720;
}

/// Density helpers for component padding.
class SomDensityTokens {
  SomDensityTokens._();

  static EdgeInsets listTilePadding(VisualDensity density) {
    final vertical = (SomSpacing.xs + density.vertical).clamp(2.0, 12.0);
    return EdgeInsets.symmetric(horizontal: SomSpacing.md, vertical: vertical);
  }

  static EdgeInsets inputPadding(VisualDensity density) {
    final vertical = (SomSpacing.sm + density.vertical).clamp(6.0, 18.0);
    return EdgeInsets.symmetric(horizontal: SomSpacing.md, vertical: vertical);
  }
}
