import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main.dart';
import 'package:som/ui/components/MainMenu.dart';
import 'package:som/ui/pages/customer_login_page.dart';
import 'package:som/ui/utils/AppWidget.dart';

class DashboardPage extends StatefulWidget {
  static String tag = '/DashboardScreen';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
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
            child: Scaffold(
              appBar: AppBar(
                title: appBarTitleWidget(context, 'Dashboard'),
                actions: [
                  PopupMenuButton(
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
                            CustomerLoginPage().launch(context);
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
          )
        : CustomerLoginPage();
  }
}
