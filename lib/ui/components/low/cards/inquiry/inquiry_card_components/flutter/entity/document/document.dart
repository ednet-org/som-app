import 'package:flutter/material.dart';

import '../../../../../../layout/expanded_body_container.dart';
import '../../../../../../layout/extended_split.dart';
import '../../../../../../layout/spaced_container.dart';
import '../../entity.dart';


// TODO: refactor to document structure fromm AppBody
class EntityDocument<T extends Entity> extends StatelessWidget {
  final Widget? contextMenu;
  final Widget? leftSplit;
  final Widget? rightSplit;
  final Widget? body;

  const EntityDocument({
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
