import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/som_assets.dart';
import 'design_system/som_svg_icon.dart';
import 'status_badge.dart';

class StatusLegendItem {
  const StatusLegendItem({
    required this.label,
    required this.status,
    required this.type,
  });

  final String label;
  final String status;
  final StatusType type;
}

class StatusLegend extends StatelessWidget {
  const StatusLegend({super.key, required this.items});

  final List<StatusLegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SomSpacing.sm,
      runSpacing: SomSpacing.sm,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusBadge(
                  status: item.status,
                  type: item.type,
                  showIcon: false,
                ),
                const SizedBox(width: SomSpacing.xs),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class StatusLegendButton extends StatelessWidget {
  const StatusLegendButton({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<StatusLegendItem> items;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Status legend',
      icon: SomSvgIcon(
        SomAssets.iconInfo,
        size: SomIconSize.md,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: StatusLegend(items: items),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
