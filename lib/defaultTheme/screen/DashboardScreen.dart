import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:som/defaultTheme/screen/DashboardWidget.dart';
import 'package:som/main.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DrawerWidget.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = 'DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
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
            title: appBarTitleWidget(context, 'SOM Dashboard'),
          ),
          drawer: DrawerWidget(),
          body: DashboardWidget(),
        ),
      ),
    );
  }
}
