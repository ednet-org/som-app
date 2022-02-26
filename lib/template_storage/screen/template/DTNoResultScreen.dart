import 'package:flutter/material.dart';
import 'package:som/ui/components/utils/DTWidgets.dart';
import 'package:som/template_storage/main/utils/AppConstant.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

import '../../../ui/components/MainMenu.dart';

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
        'images/template_storage/no_result.png',
        'No Result',
        LoremText,
      ),
    );
  }
}
