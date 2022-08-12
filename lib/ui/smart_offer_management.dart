import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/components/layout/app_body.dart';
import 'package:som/ui/pages/customer_login_page.dart';
import 'package:som/ui/utils/AppWidget.dart';

class SmartOfferManagement extends StatefulWidget {
  static String tag = '/SmartOfferManagement';

  const SmartOfferManagement({Key? key}) : super(key: key);

  @override
  SmartOfferManagementState createState() => SmartOfferManagementState();
}

class SmartOfferManagementState extends State<SmartOfferManagement> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
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
              ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
        ).paddingRight(10),
      ]),
    );
  }

  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        appBar: AppBar(
          title: appBarTitleWidget(context, 'Smart Offer Management'),
          actions: [
            PopupMenuButton(
              color: Theme.of(context).colorScheme.primary,
              child: userMenuItem(),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(child: userMenuItem()),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.notifications,
                        color: Theme.of(context).colorScheme.onPrimary),
                    title: Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.manage_accounts,
                        color: Theme.of(context).colorScheme.onPrimary),
                    title: Text(
                      'User account',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.settings_applications,
                        color: Theme.of(context).colorScheme.onPrimary),
                    title: Text('App configuration',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onTertiary)),
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.logout,
                        color: Theme.of(context).colorScheme.onPrimary),
                    title: Text('Logout',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onTertiary)),
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
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          )),
          leftSplit: Text(
            "Newest Inquiries",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          rightSplit: Text(
            "Oldest Inquiries",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
    );
  }
}
