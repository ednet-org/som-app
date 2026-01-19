import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'design_system/som_svg_icon.dart';

/// Shared card container for detail sections.
class DetailSection extends StatelessWidget {
  const DetailSection({
    super.key,
    required this.title,
    this.icon,
    this.iconAsset,
    required this.child,
    this.subtitle,
  });

  final String title;
  final IconData? icon;
  final String? iconAsset;
  final Widget child;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(SomSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SomRadius.md),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconAsset != null) ...[
                SomSvgIcon(
                  iconAsset!,
                  size: SomIconSize.sm,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: SomSpacing.xs),
              ] else if (icon != null) ...[
                Icon(
                  icon,
                  size: SomIconSize.sm,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: SomSpacing.xs),
              ],
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: SomSpacing.xs),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: SomSpacing.sm),
          child,
        ],
      ),
    );
  }
}

/// Shared key/value row for detail panels.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth = 120,
    this.valueStyle,
  });

  final String label;
  final String? value;
  final double labelWidth;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SomSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: valueStyle ?? theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailItem {
  const DetailItem({
    required this.label,
    required this.value,
    this.isMeta = false,
  });

  final String label;
  final String? value;
  final bool isMeta;
}

/// Responsive grid of key/value items.
class DetailGrid extends StatelessWidget {
  const DetailGrid({
    super.key,
    required this.items,
    this.columnSpacing = SomSpacing.lg,
    this.rowSpacing = SomSpacing.sm,
    this.minColumnWidth = 240,
  });

  final List<DetailItem> items;
  final double columnSpacing;
  final double rowSpacing;
  final double minColumnWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= minColumnWidth * 2
            ? 2
            : 1;
        final itemWidth = columns == 2
            ? (constraints.maxWidth - columnSpacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: columnSpacing,
          runSpacing: rowSpacing,
          children: items
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: _DetailItemView(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _DetailItemView extends StatelessWidget {
  const _DetailItemView({required this.item});

  final DetailItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = item.isMeta
        ? theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
          )
        : theme.textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SomSpacing.xs),
        Text(item.value ?? '-', style: valueStyle),
      ],
    );
  }
}
