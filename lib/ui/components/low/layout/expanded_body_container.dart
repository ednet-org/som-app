import 'package:flutter/material.dart';

class ExpandedBodyContainer extends StatelessWidget {
  final expandedBodyMenu;

  final expandedBodyContentSplitLeft;

  final expandedBodyContentSplitRight;

  const ExpandedBodyContainer({
    Key? key,
    this.expandedBodyMenu,
    this.expandedBodyContentSplitLeft,
    this.expandedBodyContentSplitRight,
  }) : super(key: key);

  Expanded expandedVerticalDivider(context) =>
      const Expanded(flex: 0, child: VerticalDivider());

  Expanded expandedHorizontalDivider(context) =>
      const Expanded(flex: 0, child: Divider());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraints) {
      final isMobile = constraints.maxWidth < 600;

      /// Row or Column
      final responsiveContainer = isMobile

          /// MOBILE LAYOUT
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// For existing Menu show also a divider
                if (expandedBodyMenu != null) ...[
                  expandedBodyMenu,
                  expandedHorizontalDivider(context),
                ],

                /// ALWAYS rendered
                expandedBodyContentSplitLeft,

                /// For existing right split show also a divider
                if (expandedBodyContentSplitRight != null) ...[
                  expandedHorizontalDivider(context),
                  expandedBodyContentSplitRight,
                ]
              ],
            )

          /// DESKTOP LAYOUT
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// For existing Menu show also a divider
                if (expandedBodyMenu != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text('DEBUG'),
                      expandedBodyMenu,
                    ],
                  ),
                if (expandedBodyMenu != null) expandedVerticalDivider(context),

                /// ALWAYS rendered
                expandedBodyContentSplitLeft,

                /// For existing right split show also a divider
                if (expandedBodyContentSplitRight != null) ...[
                  expandedBodyContentSplitRight,
                  expandedHorizontalDivider(context),
                ]
              ],
            );

      return responsiveContainer;
    });
  }
}
