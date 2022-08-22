import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/extended_split.dart';
import 'package:som/ui/components/layout/horizontal_body.dart';
import 'package:som/ui/components/layout/spaced_container.dart';

class AppBody extends StatelessWidget {
  final contextMenu;

  final leftSplit;
  final rightSplit;

  final body;

  const AppBody(
      {Key? key, this.leftSplit, this.rightSplit, this.contextMenu, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpacedContainer(
      horizontalBody: body != null
          ? ExpandedSplit(child: body)
          : HorizontalBody(
              expandedBodyMenu: contextMenu,
              expandedBodyContentSplitLeft: ExpandedSplit(child: leftSplit),
              expandedBodyContentSplitRight: ExpandedSplit(child: rightSplit),
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
