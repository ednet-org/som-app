import 'package:flutter/material.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../app/MainMenu.dart';

class DTWorkInProgressScreen extends StatefulWidget {
  @override
  _DTWorkInProgressScreenState createState() => _DTWorkInProgressScreenState();
}

class _DTWorkInProgressScreenState extends State<DTWorkInProgressScreen> {
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
    return actionInfoWidget(
      context,
      'images/defaultTheme/maintenance.png',
      '*** stealth mode ***',
      'This app is currently being developed but we encourage you to ',
      'Sign Up',
      ' so that you can be notified when lunch is ready, Thank you for your interest.',
    );
  }
}