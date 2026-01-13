import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import 'domain/application/application.dart';
import 'domain/model/model.dart';
import 'routes/authenticated_pages_delegate.dart';
import 'routes/beamer_provided_key.dart';
import 'routes/locations/auth/auth_login_page_location.dart';

class SomApplication extends StatelessWidget {
  static String tag = '/SmartOfferManagement';

  const SomApplication({Key? key}) : super(key: key);

  userMenuItem(context, Application appStore) {
    final label = appStore.authorization?.emailAddress ??
        appStore.authorization?.companyName ??
        'User';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ).paddingRight(10),
        SizedBox(
          width: 60,
          child: CircleAvatar(
            backgroundImage:
                Image.network('https://picsum.photos/id/2/80/80').image,
          ).paddingRight(10.0),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    final beamer = Provider.of<BeamerProvidedKey>(context);
    final actionMaxWidth = MediaQuery.of(context).size.width - 200;
    final constrainedActionWidth =
        actionMaxWidth > 200 ? actionMaxWidth : MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Offer Management'),
          actions: [
            SizedBox(
              width: constrainedActionWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      AppBarButton(
                        key: const ValueKey('InquiriesManagementMenuItem'),
                        title: 'Inquiries',
                        child: AppBarIcons.inquiry.value,
                        beamer: beamer,
                        uri: '/inquiries',
                      ),
                      AppBarButton(
                        key: const ValueKey('CompanyManagementMenuItem'),
                        title: 'Company',
                        child: AppBarIcons.company.value,
                        beamer: beamer,
                        uri: '/company',
                      ),
                      AppBarButton(
                        key: const ValueKey('UserManagementMenuItem'),
                        title: 'User',
                        child: AppBarIcons.user.value,
                        beamer: beamer,
                        uri: '/user',
                      ),
                      AppBarButton(
                        key: const ValueKey('AdsManagementMenuItem'),
                        title: 'Ads',
                        child: AppBarIcons.ads.value,
                        beamer: beamer,
                        uri: '/ads',
                      ),
                      AppBarButton(
                        key: const ValueKey('StatisticsMenuItem'),
                        title: 'Statistics',
                        child: AppBarIcons.statistics.value,
                        beamer: beamer,
                        uri: '/statistics',
                      ),
                      buildPopupMenuButton(context, appStore),
                    ],
                  ),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Beamer(
          key: beamer,
          routerDelegate: authenticatedPagesDelegate,
        ),
      ),
    );
  }

  AppBody homePageBody(BuildContext context) {
    return AppBody(
      contextMenu: Text(
        "Context Menu",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      leftSplit: Text(
        "Newest Inquiries",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      rightSplit: Text(
        "Oldest Inquiries",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  PopupMenuButton<dynamic> buildPopupMenuButton(
      BuildContext context, Application appStore) {
    return PopupMenuButton(
      child: userMenuItem(context, appStore),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(child: userMenuItem(context, appStore)),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: Text(
              'User account',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(
              'Switch to buyer portal',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () => _switchRole(context, 'buyer'),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(
              'Switch to provider portal',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () => _switchRole(context, 'provider'),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.settings_applications),
            title: Text('App configuration',
                style: Theme.of(context).textTheme.titleSmall),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title:
                Text('Logout', style: Theme.of(context).textTheme.titleSmall),
            onTap: () {
              appStore.logout();
              context.beamTo(AuthLoginPageLocation());
            },
          ),
        ),
      ],
    );
  }

  Future<void> _switchRole(BuildContext context, String role) async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    if (appStore.authorization == null) {
      return;
    }
    try {
      final response = await api.getAuthApi().authSwitchRolePost(
            authSwitchRolePostRequest:
                AuthSwitchRolePostRequest((b) => b..role = role),
          );
      final token = response.data?.token;
      if (token != null) {
        appStore.authorization!.token = token;
      }
    } catch (_) {}
  }
}
