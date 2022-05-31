import 'package:flutter/material.dart';
import 'package:som/ui/components/utils/DTWidgets.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

import '../../../ui/components/MainMenu.dart';

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
        'images/template_storage/no_data.png',
        'No Data Found',
        'There was no record based on the details you entered.',
      ),
    );
  }
}
