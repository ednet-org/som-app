import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

class ExpandedBodyContainer extends StatelessWidget {
  final Widget? toolbar;
  final Widget? left;
  final Widget? right;
  final Widget? body;

  const ExpandedBodyContainer({
    super.key,
    this.toolbar,
    this.left,
    this.right,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < SomBreakpoints.listDetailSplit;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (toolbar != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SomSpacing.sm),
              child: toolbar!,
            ),
          if (toolbar != null) const SizedBox(height: SomSpacing.sm),
          Expanded(
            child: body ?? _buildSplitLayout(context, isNarrow),
          ),
        ],
      );
    });
  }

  Widget _buildSplitLayout(BuildContext context, bool isNarrow) {
    final leftPanel = left ?? const SizedBox.shrink();
    final rightPanel = right;

    if (isNarrow) {
      return Column(
        children: [
          Expanded(child: _panelPadding(leftPanel)),
          if (rightPanel != null) const Divider(height: 1),
          if (rightPanel != null) Expanded(child: _panelPadding(rightPanel)),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _panelPadding(leftPanel)),
        if (rightPanel != null) const VerticalDivider(width: 1),
        if (rightPanel != null) Expanded(child: _panelPadding(rightPanel)),
      ],
    );
  }

  Widget _panelPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.sm),
      child: child,
    );
  }
}
