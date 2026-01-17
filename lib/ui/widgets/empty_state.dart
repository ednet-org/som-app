import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'design_system/som_svg_icon.dart';

/// Shared empty state widget for lists and panels.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon,
    this.asset,
    required this.title,
    this.message,
    this.action,
  });

  final IconData? icon;
  final String? asset;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (asset != null)
              SomSvgIcon(
                asset!,
                size: SomIconSize.xxl,
                color: theme.colorScheme.outline,
              )
            else if (icon != null)
              Icon(
                icon,
                size: SomIconSize.xxl,
                color: theme.colorScheme.outline,
              ),
            const SizedBox(height: SomSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: SomSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: SomSpacing.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
