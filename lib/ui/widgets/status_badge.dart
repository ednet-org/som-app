import 'package:flutter/material.dart';

import '../theme/semantic_colors.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';
import 'design_system/som_svg_icon.dart';

/// A badge widget for displaying status with appropriate coloring.
///
/// Provides consistent status visualization across the application
/// with semantic colors and icons.
class StatusBadge extends StatelessWidget {
  final String status;
  final StatusType type;
  final bool showIcon;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.type = StatusType.inquiry,
    this.showIcon = true,
    this.compact = false,
  });

  /// Create a badge for inquiry status
  const StatusBadge.inquiry({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  }) : type = StatusType.inquiry;

  /// Create a badge for offer status
  const StatusBadge.offer({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  }) : type = StatusType.offer;

  /// Create a badge for ad status
  const StatusBadge.ad({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  }) : type = StatusType.ad;

  /// Create a badge for provider status
  const StatusBadge.provider({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  }) : type = StatusType.provider;

  /// Create a badge for company status
  const StatusBadge.company({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  }) : type = StatusType.company;

  /// Create a badge for branch status
  const StatusBadge.branch({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  }) : type = StatusType.branch;

  Color get _color => switch (type) {
        StatusType.inquiry => SomSemanticColors.forInquiryStatus(status),
        StatusType.offer => SomSemanticColors.forOfferStatus(status),
        StatusType.ad => SomSemanticColors.forAdStatus(status),
        StatusType.provider => SomSemanticColors.forProviderStatus(status),
        StatusType.company => SomSemanticColors.forCompanyStatus(status),
        StatusType.branch => SomSemanticColors.forBranchStatus(status),
      };

  Color _backgroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (type) {
      StatusType.inquiry =>
        SomSemanticColors.backgroundFor(_color, scheme),
      _ => SomSemanticColors.backgroundFor(_color, scheme),
    };
  }

  String get _iconAsset => SomSemanticColors.iconAssetForStatus(status);

  String get _label => SomFormatters.capitalize(status);

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildFull(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SomSpacing.sm,
        vertical: SomSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(SomRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            SomSvgIcon(
              _iconAsset,
              size: SomIconSize.sm,
              color: _color,
            ),
            const SizedBox(width: SomSpacing.xs),
          ],
          Text(
            _label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Tooltip(
      message: _label,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Dot indicator for status (minimal version)
class StatusDot extends StatelessWidget {
  final String status;
  final StatusType type;
  final double size;

  const StatusDot({
    super.key,
    required this.status,
    this.type = StatusType.inquiry,
    this.size = 8.0,
  });

  Color get _color => switch (type) {
        StatusType.inquiry => SomSemanticColors.forInquiryStatus(status),
        StatusType.offer => SomSemanticColors.forOfferStatus(status),
        StatusType.ad => SomSemanticColors.forAdStatus(status),
        StatusType.provider => SomSemanticColors.forProviderStatus(status),
        StatusType.company => SomSemanticColors.forCompanyStatus(status),
        StatusType.branch => SomSemanticColors.forBranchStatus(status),
      };

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: SomFormatters.capitalize(status),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

enum StatusType {
  inquiry,
  offer,
  ad,
  provider,
  company,
  branch,
}
