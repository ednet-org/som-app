import 'package:flutter/material.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppConstant.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../pages/MainMenu.dart';

class DTNoResultScreen extends StatefulWidget {
  @override
  _DTNoResultScreenState createState() => _DTNoResultScreenState();
}

class _DTNoResultScreenState extends State<DTNoResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'No Result'),
      drawer: MainMenu(),
      body: errorWidget(
        context,
        'images/defaultTheme/no_result.png',
        'No Result',
        LoremText,
      ),
    );
  }
}
