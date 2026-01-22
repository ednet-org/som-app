import 'package:flutter/material.dart';
import 'package:som/ui/theme/som_assets.dart';

/// Semantic colors for status indicators and feedback.
///
/// These colors provide consistent visual meaning across the application
/// for different states and statuses.
class SomSemanticColors {
  SomSemanticColors._();

  // Feedback colors (Tailwind-inspired palette)
  static const Color success = Color(0xFF22C55E); // Green 500
  static const Color successLight = Color(0xFFDCFCE7); // Green 100
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue 100

  // Neutral colors
  static const Color neutral = Color(0xFF6B7280); // Gray 500
  static const Color neutralLight = Color(0xFFF3F4F6); // Gray 100

  /// Get color for inquiry status
  static Color forInquiryStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'open' || 'published' => warning,
      'closed' => success,
      'draft' => info,
      'expired' => error,
      'responded' => info,
      'assigned' => warning,
      _ => neutral,
    };
  }

  /// Get background color for inquiry status
  static Color forInquiryStatusBackground(String? status) {
    return switch (status?.toLowerCase()) {
      'open' || 'published' => warningLight,
      'closed' => successLight,
      'draft' => infoLight,
      'expired' => errorLight,
      'responded' => infoLight,
      'assigned' => warningLight,
      _ => neutralLight,
    };
  }

  /// Get color for offer status
  /// Backend uses: offer_created, won, lost, ignored, open
  static Color forOfferStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'won' || 'accepted' => success,
      'lost' || 'rejected' => error,
      'offer_created' || 'pending' || 'open' => warning,
      'ignored' || 'expired' => neutral,
      _ => neutral,
    };
  }

  /// Get color for ad status
  static Color forAdStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'active' => success,
      'draft' => info,
      'expired' => error,
      'paused' => warning,
      _ => neutral,
    };
  }

  /// Get color for provider status
  static Color forProviderStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'approved' || 'active' => success,
      'pending' => warning,
      'declined' || 'rejected' || 'inactive' => error,
      'suspended' => error,
      _ => neutral,
    };
  }

  /// Get color for company status (aligns with provider semantics)
  static Color forCompanyStatus(String? status) {
    return forProviderStatus(status);
  }

  /// Get color for branch/category status
  static Color forBranchStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'active' => success,
      'pending' => warning,
      'declined' || 'inactive' => error,
      _ => neutral,
    };
  }

  /// Build a surface-tinted background for badges and messages.
  static Color backgroundFor(Color base, ColorScheme scheme) {
    final alpha = scheme.brightness == Brightness.dark ? 0.18 : 0.12;
    return Color.alphaBlend(
      base.withValues(alpha: alpha),
      scheme.surfaceContainerHigh,
    );
  }

  /// Pick a readable foreground color for status badges.
  static Color foregroundFor(Color base, ColorScheme scheme) {
    final background = backgroundFor(base, scheme);
    final baseContrast = _contrastRatio(base, background);
    if (baseContrast >= 4.5) {
      return base;
    }
    final onSurface = scheme.onSurface;
    final onSurfaceVariant = scheme.onSurfaceVariant;
    final onSurfaceContrast = _contrastRatio(onSurface, background);
    final onVariantContrast = _contrastRatio(onSurfaceVariant, background);
    if (onSurfaceContrast >= onVariantContrast) {
      return onSurfaceContrast >= 4.5 ? onSurface : onSurfaceVariant;
    }
    return onVariantContrast >= 4.5 ? onSurfaceVariant : onSurface;
  }

  static double _contrastRatio(Color a, Color b) {
    final lumA = a.computeLuminance();
    final lumB = b.computeLuminance();
    final brightest = lumA > lumB ? lumA : lumB;
    final darkest = lumA > lumB ? lumB : lumA;
    return (brightest + 0.05) / (darkest + 0.05);
  }

  /// Get icon asset for status
  static String iconAssetForStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'open' || 'published' || 'pending' => SomAssets.inquiryStatusOpen,
      'won' => SomAssets.inquiryStatusWon,
      'lost' => SomAssets.inquiryStatusLost,
      'closed' || 'accepted' || 'approved' || 'active' =>
        SomAssets.offerStatusAccepted,
      'draft' => SomAssets.iconEdit,
      'expired' || 'paused' => SomAssets.iconWarning,
      'rejected' || 'declined' || 'inactive' => SomAssets.offerStatusRejected,
      'assigned' => SomAssets.iconUser,
      'responded' => SomAssets.iconInfo,
      _ => SomAssets.iconInfo,
    };
  }
}
