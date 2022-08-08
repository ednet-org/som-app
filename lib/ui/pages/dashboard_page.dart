import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/components/layout/app_body.dart';
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
      // TODO: mobile - ContainerX is again broken
      Text(
        'Fritzchen der Käufer',
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ).paddingRight(50),
    ]);
  }

  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    print(Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(color: Theme.of(context).colorScheme.secondary)
        .color);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: appBarTitleWidget(context, 'Dashboard'),
          actions: [
            PopupMenuButton(
              padding: EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
              child: userMenuItem(),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(child: userMenuItem()),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.manage_accounts),
                    title: Text(
                      'User account',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.settings_applications),
                    title: Text('App configuration',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    onTap: () {
                      appStore.logout();
                      CustomerLoginPage().launch(context);
                    },
                  ),
                ),
              ],
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        // drawer: MainMenu(),
        body: AppBody(
          contextMenu: Container(
              child: Text(
            "Context Menu",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          )),
          leftSplit: Text(
            "Newest Inquiries",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          rightSplit: Text(
            "Oldest Inquiries",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ),
    );
  }
}
