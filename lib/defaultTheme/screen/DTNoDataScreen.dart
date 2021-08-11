import 'package:flutter/material.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'som/app/MainMenu.dart';

class DTNoDataScreen extends StatefulWidget {
  static String tag = '/DTNoDataScreen';

  @override
  DTNoDataScreenState createState() => DTNoDataScreenState();
}

class DTNoDataScreenState extends State<DTNoDataScreen> {
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
      drawer: MainMenu(),
      body: errorWidget(
        context,
        'images/defaultTheme/no_data.png',
        'No Data Found',
        'There was no record based on the details you entered.',
      ),
    );
  }
}
