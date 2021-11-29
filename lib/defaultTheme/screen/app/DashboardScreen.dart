import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/som/customer/LoginOrRegister.dart';
import 'package:som/main.dart';
import 'package:som/main/utils/AppColors.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'MainMenu.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool isUserMenuExpanded = false;

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

  userMenuItem() {
    return Row(children: [
      CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage(
            'images/widgets/materialWidgets/mwInformationDisplayWidgets/gridview/ic_item4.jpg'),
      ).paddingRight(10.0),
      // TODO: mobile
      Text('Fritzchen der Käufer').paddingRight(50),
    ]);
  }

  Widget build(BuildContext context) {
    return appStore.isAuthenticated
        ? SafeArea(
            child: Observer(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: appStore.appBarColor,
                  title: appBarTitleWidget(context, 'Dashboard'),
                  iconTheme: IconThemeData(color: appStore.iconColor),
                  actions: [
                    PopupMenuButton(
                      color: appStore.appBarColor,
                      child: userMenuItem(),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(child: userMenuItem()),
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
                            onTap: () {
                              appStore.logout();
                              LoginOrRegister().launch(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                drawer: MainMenu(),
                body: Text(''),
                // body: DTDashboardWidget(),
              ),
            ),
          )
        : LoginOrRegister();
  }
}
