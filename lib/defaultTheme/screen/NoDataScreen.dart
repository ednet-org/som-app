import 'package:flutter/material.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DrawerWidget.dart';

class NoDataScreen extends StatefulWidget {
  static String tag = 'NoDataScreen';

  @override
  NoDataScreenState createState() => NoDataScreenState();
}

class NoDataScreenState extends State<NoDataScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'No Data'),
      drawer: DrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/no_data.png',
        'No Data Found',
        'There was no record based on the details you entered.',
      ),
    );
  }
}
