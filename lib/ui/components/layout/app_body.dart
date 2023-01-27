import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/extended_split.dart';
import 'package:som/ui/components/layout/expanded_body_container.dart';
import 'package:som/ui/components/layout/spaced_container.dart';

class AppBody extends StatelessWidget {
  final contextMenu;

  final leftSplit;
  final rightSplit;

  final body;

  const AppBody({
    super.key,
    this.leftSplit,
    this.rightSplit,
    this.contextMenu,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return SpacedContainer(
      horizontalBody: body != null
          ? ExpandedBodyContainer(
              expandedBodyMenu: contextMenu,
              expandedBodyContentSplitLeft: ExpandedSplit(child: body),
            )
          : ExpandedBodyContainer(
              expandedBodyMenu: contextMenu,
              expandedBodyContentSplitLeft: ExpandedSplit(child: leftSplit),
              expandedBodyContentSplitRight:
                  rightSplit != null ? ExpandedSplit(child: rightSplit) : null,
            ),
    );
  }

  Widget get expandedBodyMenu {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: contextMenu,
      ),
    );
  }
}
