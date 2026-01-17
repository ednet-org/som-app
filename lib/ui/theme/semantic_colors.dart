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
  static Color forOfferStatus(String? status) {
    return switch (status?.toLowerCase()) {
      'accepted' => success,
      'rejected' => error,
      'pending' => warning,
      'expired' => neutral,
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
      'declined' || 'rejected' => error,
      'suspended' => error,
      _ => neutral,
    };
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
      'expired' => SomAssets.iconWarning,
      'rejected' || 'declined' => SomAssets.offerStatusRejected,
      'assigned' => SomAssets.iconUser,
      'responded' => SomAssets.iconInfo,
      _ => SomAssets.iconInfo,
    };
  }
}
