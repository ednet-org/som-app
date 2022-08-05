import 'package:flutter/material.dart';

class SpacedContainer extends StatelessWidget {
  final horizontalBody;

  const SpacedContainer({Key? key, this.horizontalBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: horizontalBody,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class ExpandedSplit extends StatelessWidget {
  final child;

  const ExpandedSplit({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  final contextMenu;

  final leftSplit;
  final rightSplit;

  const AppBody({
    Key? key,
    this.leftSplit,
    this.rightSplit,
    this.contextMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpacedContainer(
      horizontalBody: HorizontalBody(
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

  Widget get currentInquiries {
    return Text("Current Inquiries");
    // return TestHorizontalListView();
  }
}
