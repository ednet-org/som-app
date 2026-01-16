import 'package:flutter/material.dart';

import 'expanded_body_container.dart';
import 'spaced_container.dart';

class AppBody extends StatelessWidget {
  final Widget? contextMenu;
  final Widget? leftSplit;
  final Widget? rightSplit;
  final Widget? body;

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
      horizontalBody: ExpandedBodyContainer(
        toolbar: contextMenu,
        left: leftSplit,
        right: rightSplit,
        body: body,
      ),
    );
  }
}
