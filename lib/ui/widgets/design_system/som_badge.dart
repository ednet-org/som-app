import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';

enum SomBadgeType { success, warning, error, info }

class SomBadge extends StatelessWidget {
  final String text;
  final SomBadgeType type;

  const SomBadge({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final iconPath = _getIconPath();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(colors.foreground, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: colors.foreground,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getIconPath() {
    switch (type) {
      case SomBadgeType.success:
        return SomAssets.offerStatusAccepted;
      case SomBadgeType.warning:
        return SomAssets.iconWarning;
      case SomBadgeType.error:
        return SomAssets.iconClose;
      case SomBadgeType.info:
        return SomAssets.iconInfo;
    }
  }

  ({Color background, Color border, Color foreground}) _getColors(BuildContext context) {
    // Colors from BACKLOG/Theme:
    // success: #10B981, warning: #F59E0B, error: #EF4444, info: #3B82F6
    Color base;
    switch (type) {
      case SomBadgeType.success:
        base = const Color(0xFF10B981);
        break;
      case SomBadgeType.warning:
        base = const Color(0xFFF59E0B);
        break;
      case SomBadgeType.error:
        base = const Color(0xFFEF4444);
        break;
      case SomBadgeType.info:
        base = const Color(0xFF3B82F6);
        break;
    }

    return (
      background: base.withValues(alpha: 0.1),
      border: base.withValues(alpha: 0.3),
      foreground: base,
    );
  }
}
