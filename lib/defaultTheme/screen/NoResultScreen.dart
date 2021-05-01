import 'package:flutter/material.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppConstant.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DrawerWidget.dart';

class NoResultScreen extends StatefulWidget {
  @override
  _NoResultScreenState createState() => _NoResultScreenState();
}

class _NoResultScreenState extends State<NoResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'No Result'),
      drawer: DrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/no_result.png',
        'No Result',
        LoremText,
      ),
    );
  }
}
