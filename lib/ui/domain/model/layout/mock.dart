import 'package:flutter/material.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

class TestHorizontalListView extends StatefulWidget {
  const TestHorizontalListView({super.key});

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

  final ScrollController _horizontalScrollController = ScrollController();

  // ignore: unused_element
  Widget _buildCard(String value) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            width: 300,
            height: 400,
            child: Card(
              child: Expanded(
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30))),
            )));
  }

  void _scrollRight() {
    _horizontalScrollController.animateTo(
      _horizontalScrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollLeft() {
    _horizontalScrollController.animateTo(
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
            child: SizedBox(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  FloatingActionButton.small(
                    onPressed: _scrollRight,
                    child: SomSvgIcon(
                      SomAssets.iconChevronRight,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: lstData.length,
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.vertical,
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
                    child: SomSvgIcon(
                      SomAssets.iconChevronLeft,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
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

  // ignore: unused_element
  Widget _buildCardB(String value) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            width: 300,
            height: 400,
            child: Card(
              child: Expanded(
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30))),
            )));
  }
}
