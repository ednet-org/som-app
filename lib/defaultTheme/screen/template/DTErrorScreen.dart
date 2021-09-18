import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../app/MainMenu.dart';

class DTErrorScreen extends StatefulWidget {
  static String tag = '/DTErrorScreen';

  @override
  DTErrorScreenState createState() => DTErrorScreenState();
}

class DTErrorScreenState extends State<DTErrorScreen> {
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
      drawer: MainMenu(),
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
