import 'package:flutter/material.dart';

class HorizontalBody extends StatelessWidget {
  final expandedBodyMenu;

  final expandedBodyContentSplitLeft;

  final expandedBodyContentSplitRight;

  const HorizontalBody({
    Key? key,
    this.expandedBodyMenu,
    this.expandedBodyContentSplitLeft,
    this.expandedBodyContentSplitRight,
  }) : super(key: key);

  Expanded expandedVerticalDivider(context) => Expanded(
      flex: 1,
      child: VerticalDivider(
        color: Theme.of(context).colorScheme.primary,
      ));

  Expanded expandedHorizontalDivider(context) => Expanded(
      flex: 1,
      child: Divider(
        color: Theme.of(context).colorScheme.primary,
      ));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final responsiveContainer = isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                expandedBodyMenu,
                expandedHorizontalDivider(context),
                expandedBodyContentSplitLeft,
                if (expandedBodyContentSplitRight != null)
                  expandedHorizontalDivider(context),
                if (expandedBodyContentSplitRight != null)
                  expandedBodyContentSplitRight,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                expandedBodyMenu,
                expandedVerticalDivider(context),
                expandedBodyContentSplitLeft,
                if (expandedBodyContentSplitRight != null)
                  expandedHorizontalDivider(context),
                if (expandedBodyContentSplitRight != null)
                  expandedBodyContentSplitRight,
              ],
            );

      return responsiveContainer;
    });
  }
}
