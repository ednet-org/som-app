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

class TestHorizontalListView extends StatefulWidget {
  TestHorizontalListView({Key? key}) : super(key: key);

  @override
  State<TestHorizontalListView> createState() => _TestHorizontalListViewState();
}

class _TestHorizontalListViewState extends State<TestHorizontalListView> {
  List<String> lstData = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'U',
    'V',
    'W'
  ];

  final ScrollController _horizontal_scrollcontroller = ScrollController();

  _buildCard(String value) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            width: 300,
            height: 400,
            child: Card(
              child: Expanded(
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30))),
            )));
  }

  void _scrollRight() {
    _horizontal_scrollcontroller.animateTo(
      _horizontal_scrollcontroller.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollLeft() {
    _horizontal_scrollcontroller.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    //   TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: SingleChildScrollView(
            child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  FloatingActionButton.small(
                    onPressed: _scrollRight,
                    child: const Icon(Icons.arrow_right),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: lstData.length,
                          controller: _horizontal_scrollcontroller,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                width: 100,
                                height: 100,
                                child: Card(
                                  child: Text(lstData[index],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 30)),
                                ));
                          }),
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: _scrollLeft,
                    child: const Icon(Icons.arrow_left),
                  ),
                ]))));
  }

  // Widget get overdueInquiries {
  // return CustomScrollView(
  //   slivers: <Widget>[
  //     SliverToBoxAdapter(
  //       child: Container(
  //         height: 50.0,
  //         width: double.infinity,
  //         color: Colors.yellow,
  //       ),
  //     ),
  //     SliverPadding(padding: EdgeInsets.only(top: 10)),
  //     SliverGrid(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           childAspectRatio: 1.0,
  //           mainAxisSpacing: 10.0,
  //           crossAxisSpacing: 10.0),
  //       delegate: SliverChildBuilderDelegate(
  //         (context, index) {
  //           return BodyWidget();
  //         },
  //         childCount: 30,
  //       ),
  //     ),
  //     SliverPadding(
  //       padding: const EdgeInsets.only(bottom: 80.0),
  //     )
  //   ],
  // );
  // }

  //
  // Column get overdueInquiries {
  //   return Column(
  //     children: [
  //       _buildCard("1"),
  //       _buildCard("2"),
  //       _buildCard("3"),
  //       _buildCard("4"),
  //       _buildCard("5"),
  //       _buildCard("6"),
  //       _buildCard("7"),
  //       _buildCard("5"),
  //       _buildCard("5"),
  //       _buildCard("5"),
  //     ],
  //   );
  // }

  _buildCardB(String value) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            width: 300,
            height: 400,
            child: Card(
              child: Expanded(
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30))),
            )));
  }
}
