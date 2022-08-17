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

  Expanded get expandedVerticalDivider =>
      Expanded(flex: 1, child: VerticalDivider());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        expandedBodyMenu,
        expandedBodyContentSplitLeft,
        expandedVerticalDivider,
        expandedBodyContentSplitRight,
      ],
    );
  }
}
