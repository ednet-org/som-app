import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DrawerWidget.dart';

class ErrorScreen extends StatefulWidget {
  static String tag = 'ErrorScreen';

  @override
  ErrorScreenState createState() => ErrorScreenState();
}

class ErrorScreenState extends State<ErrorScreen> {
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
      appBar: appBar(context, 'Error'),
      drawer: DrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/error.png',
        'Error!',
        'Something went wrong. Please try again later',
        showRetry: true,
        onRetry: () {
          toast('Retrying');
        },
      ),
    );
  }
}
