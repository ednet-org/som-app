import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Responsive filter panel that collapses on narrow widths.
class ResponsiveFilterPanel extends StatelessWidget {
  const ResponsiveFilterPanel({
    super.key,
    required this.title,
    required this.child,
    this.collapseWidth = SomBreakpoints.filterCollapse,
  });

  final String title;
  final Widget child;
  final double collapseWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCollapsed = constraints.maxWidth < collapseWidth;
        if (isCollapsed) {
          return ExpansionTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(SomSpacing.sm),
                child: child,
              ),
            ],
          );
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(SomSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: SomSpacing.sm),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
