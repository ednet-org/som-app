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

  Widget get overdueInquiries {
    return Text("Oldest Inquiries");

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
  }

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

  Widget get currentInquiries {
    return Text("Current Inquiries");
    // return TestHorizontalListView();
  }

  Container get contextMenu => Container(child: Text("Context Menu"));
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
}
