import 'package:flutter/material.dart';

import '../theme/semantic_colors.dart';
import '../theme/som_assets.dart';
import '../theme/tokens.dart';
import 'design_system/som_svg_icon.dart';

enum InlineMessageType { info, success, warning, error }

/// Inline message banner for errors, warnings, and notices.
class InlineMessage extends StatelessWidget {
  const InlineMessage({
    super.key,
    required this.message,
    this.type = InlineMessageType.info,
    this.action,
  });

  final String message;
  final InlineMessageType type;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorForType(type);
    final background = SomSemanticColors.backgroundFor(
      color,
      theme.colorScheme,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SomSpacing.md,
        vertical: SomSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(SomRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SomSvgIcon(
            _iconForType(type),
            size: SomIconSize.sm,
            color: color,
            semanticLabel: '${type.name} message',
          ),
          const SizedBox(width: SomSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: SomSpacing.sm),
            action!,
          ],
        ],
      ),
    );
  }

  String _iconForType(InlineMessageType type) {
    return switch (type) {
      InlineMessageType.success => SomAssets.offerStatusAccepted,
      InlineMessageType.warning => SomAssets.iconWarning,
      InlineMessageType.error => SomAssets.iconClose,
      InlineMessageType.info => SomAssets.iconInfo,
    };
  }

  Color _colorForType(InlineMessageType type) {
    return switch (type) {
      InlineMessageType.success => SomSemanticColors.success,
      InlineMessageType.warning => SomSemanticColors.warning,
      InlineMessageType.error => SomSemanticColors.error,
      InlineMessageType.info => SomSemanticColors.info,
    };
  }
}
