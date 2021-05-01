import 'package:flutter/material.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DrawerWidget.dart';

class MaintenanceScreen extends StatefulWidget {
  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
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
      appBar: appBar(context, 'Maintenance'),
      drawer: DrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/maintenance.png',
        'Maintenance Mode',
        'This app is currently under going maintenance and will be back online shortly, Thank you for your patience.',
      ),
    );
  }
}
