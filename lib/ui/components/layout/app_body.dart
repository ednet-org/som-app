import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return spacedContainer;
  }

  Padding get spacedContainer {
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
                    child: HorizontalBody,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row get HorizontalBody {
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

  Expanded get expandedBodyContentSplitRight {
    return Expanded(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: overdueInquiries,
          ),
        ),
      ),
    );
  }

  Expanded get expandedVerticalDivider =>
      Expanded(flex: 1, child: VerticalDivider());

  Expanded get expandedBodyContentSplitLeft {
    return Expanded(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: currentInquiries,
          ),
        ),
      ),
    );
  }

  Expanded get expandedBodyMenu {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: contextMenu,
      ),
    );
  }

  Column get overdueInquiries {
    return Column(
      children: [
        Text("1"),
        Text("2"),
        Text("3"),
      ],
    );
  }

  Column get currentInquiries {
    return Column(
      children: [Text("1"), Text("2")],
    );
  }

  Container get contextMenu => Container(child: SizedBox());
}
