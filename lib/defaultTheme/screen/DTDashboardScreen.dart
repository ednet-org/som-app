import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:som/defaultTheme/screen/DTDashboardWidget.dart';
import 'package:som/main.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DTDrawerWidget.dart';

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
            title: appBarTitleWidget(context, 'SOM Dashboard'),
          ),
          drawer: DTDrawerWidget(),
          body: DTDashboardWidget(),
        ),
      ),
    );
  }
}
