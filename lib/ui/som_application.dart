import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/routes/authenticated_pages_delegate.dart';
import 'package:som/routes/beamer_provided_key.dart';
import 'package:som/routes/locations/auth/auth_login_page_location.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/components/app_bar/app_bar_button.dart';
import 'package:som/ui/components/layout/app_body.dart';
import 'package:som/ui/utils/AppWidget.dart';

class SomApplication extends StatelessWidget {
  static String tag = '/SmartOfferManagement';

  const SomApplication({Key? key}) : super(key: key);

  userMenuItem(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Text(
          'Fritzchen der Käufer',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ).paddingRight(10),
        SizedBox(
          width: 60,
          child: CircleAvatar(
            backgroundImage:
                Image.network('https://picsum.photos/id/2/80/80').image,
          ).paddingRight(10.0),
        ),
        // TODO: mobile - ContainerX is again broken
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    final beamer = Provider.of<BeamerProvidedKey>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitleWidget(context, 'Smart Offer Management'),
          actions: [
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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
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
    );
  }

  PopupMenuButton<dynamic> buildPopupMenuButton(
      BuildContext context, Application appStore) {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.primary,
      child: userMenuItem(context),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(child: userMenuItem(context)),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.notifications,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text(
              'Notifications',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.manage_accounts,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text(
              'User account',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
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
        const PopupMenuDivider(),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text('Logout',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onTertiary)),
            onTap: () {
              appStore.logout();
              context.beamTo(AuthLoginPageLocation());
            },
          ),
        ),
      ],
    );
  }
}
