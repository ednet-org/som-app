import 'package:flutter/material.dart';
import 'package:som/ui/components/utils/DTWidgets.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

import '../../../ui/components/MainMenu.dart';

class DTMaintenanceScreen extends StatefulWidget {
  @override
  _DTMaintenanceScreenState createState() => _DTMaintenanceScreenState();
}

class _DTMaintenanceScreenState extends State<DTMaintenanceScreen> {
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
      drawer: MainMenu(),
      body: errorWidget(
        context,
        'images/template_storage/maintenance.png',
        'Maintenance Mode',
        'This app is currently under going maintenance and will be back online shortly, Thank you for your patience.',
      ),
    );
  }
}
