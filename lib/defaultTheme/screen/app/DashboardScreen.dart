import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:som/main.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'MainMenu.dart';
import '../template/DTWorkInProgressScreen.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool isUserMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) => Scaffold(
          appBar: AppBar(
              backgroundColor: appStore.appBarColor,
              title: appBarTitleWidget(context, 'Dashboard'),
              iconTheme: IconThemeData(color: appStore.iconColor)),
          floatingActionButton: userMenu(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          drawer: MainMenu(),
          body: DTWorkInProgressScreen(),
          // body: DTDashboardWidget(),
        ),
      ),
    );
  }

  userMenu() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ActionChip(
              avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: AssetImage(
                      'images/widgets/materialWidgets/mwInformationDisplayWidgets/gridview/ic_item4.jpg')),
              label: Text('Fritzchen der Käufer'),
              onPressed: () {
                setState(() {
                  isUserMenuExpanded = !isUserMenuExpanded;
                });
              },
            ),
            Positioned(
              top: 200,
              child: SizedBox(
                height: 300,
                child: Positioned(
                    top: 200,
                    child: Container(
                        height: 300,
                        color: Colors.amber,
                        child: Text("BOlje juce nego sutra"))),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ItemTile extends StatefulWidget {
//   final OrderItem orderItem;

//   OrderItemTile(this.title);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  var _expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? 350 : 100,
      child: Container(
        width: 300,
        child: Card(
          elevation: 10,
          color: Theme.of(context).canvasColor,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              ListTile(
                title: (Text(
                  'File',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
                trailing: IconButton(
                    icon: _expanded
                        ? Icon(Icons.expand_less)
                        : Icon(Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    }),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _expanded ? 300 : 0,
                width: MediaQuery.of(context).size.width,
                child: ItemExpandedTile(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemExpandedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            child: Container(
              height: 90,
              width: 200,
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      1.0,
                      1.0,
                    ),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
