import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:som/main.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DTDrawerWidget.dart';
import 'DTWorkInProgressScreen.dart';

class DTDashboardScreen extends StatefulWidget {
  static String tag = '/DTDashboardScreen';

  @override
  DTDashboardScreenState createState() => DTDashboardScreenState();
}

class DTDashboardScreenState extends State<DTDashboardScreen> {
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
          floatingActionButton: ActionChip(
            avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                backgroundImage: AssetImage(
                    'images/widgets/materialWidgets/mwInformationDisplayWidgets/gridview/ic_item4.jpg')),
            label: Text('Fritzchen der Käufer'),
            onPressed: () {
              print("Will open user menu");
            },
          ).paddingLeft(16.0),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          drawer: DTDrawerWidget(),
          body: DTWorkInProgressScreen(),
          // body: DTDashboardWidget(),
        ),
      ),
    );
  }
}
