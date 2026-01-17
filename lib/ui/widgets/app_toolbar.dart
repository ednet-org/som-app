import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Shared toolbar for page headers.
///
/// Uses a responsive layout that wraps actions on narrow widths
/// to avoid overflow while keeping a consistent Material 3 look.
class AppToolbar extends StatelessWidget {
  const AppToolbar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.padding = const EdgeInsets.symmetric(
      horizontal: SomSpacing.md,
      vertical: SomSpacing.sm,
    ),
  });

  final Widget title;
  final Widget? subtitle;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionBar = Wrap(
      spacing: SomSpacing.sm,
      runSpacing: SomSpacing.xs,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: actions,
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer, // Darker surface
        borderRadius: BorderRadius.circular(SomRadius.md),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        // Gradient overlay for slick look
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.surfaceContainer, theme.colorScheme.surfaceContainerHigh],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;
          final titleColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: theme.textTheme.titleSmall ?? const TextStyle(),
                child: title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: SomSpacing.xs),
                DefaultTextStyle(
                  style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ) ??
                      const TextStyle(),
                  child: subtitle!,
                ),
              ],
            ],
          );

          if (actions.isEmpty) {
            return titleColumn;
          }

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleColumn,
                const SizedBox(height: SomSpacing.sm),
                actionBar,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: titleColumn),
              actionBar,
            ],
          );
        },
      ),
    );
  }
}
