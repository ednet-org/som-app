import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../template/DTWorkInProgressScreen.dart';
import 'MainMenu.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: appStore.appBarColor,
            title: appBarTitleWidget(context, 'Dashboard'),
            iconTheme: IconThemeData(color: appStore.iconColor),
            actions: [
              PopupMenuButton(
                child: Row(children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: AssetImage(
                        'images/widgets/materialWidgets/mwInformationDisplayWidgets/gridview/ic_item4.jpg'),
                  ).paddingRight(15.0),
                  Text('Fritzchen der Käufer').paddingRight(50),
                ]),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.manage_accounts),
                      title: Text('User account'),
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.settings_applications),
                      title: Text('App configuration'),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          drawer: MainMenu(),
          body: DTWorkInProgressScreen(),
          // body: DTDashboardWidget(),
        ),
      ),
    );
  }
}
