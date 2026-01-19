import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/tokens.dart';

import 'domain/application/application.dart';
import 'domain/infrastructure/supabase_realtime.dart';
import 'domain/model/model.dart';
import 'routes/authenticated_pages_delegate.dart';
import 'routes/beamer_provided_key.dart';
import 'routes/locations/auth/auth_login_page_location.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';
import 'package:som/ui/widgets/empty_state.dart';
import 'utils/ui_logger.dart';

class SomApplication extends StatelessWidget {
  static String tag = '/SmartOfferManagement';

  const SomApplication({super.key});

  Widget userMenuItem(BuildContext context, Application appStore) {
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
    final auth = appStore.authorization;
    final isBuyer = auth?.isBuyer ?? false;
    final isProvider = auth?.isProvider ?? false;
    final isConsultant = auth?.isConsultant ?? false;
    final isAdmin = auth?.isAdmin ?? false;
    final beamer = Provider.of<BeamerProvidedKey>(context);
    final width = MediaQuery.of(context).size.width;
    final useNavigationRail = width >= SomBreakpoints.navigationRail;
    final useNavigationBar = width < SomBreakpoints.navigationBar;
    final navItems = _buildNavItems(
      isBuyer: isBuyer,
      isProvider: isProvider,
      isConsultant: isConsultant,
      isAdmin: isAdmin,
    );
    final selectedIndex =
        _selectedIndex(navItems, _currentPath(beamer));
    final beamerWidget = Beamer(
      key: beamer,
      routerDelegate: authenticatedPagesDelegate,
    );
    final actionMaxWidth = width - 200;
    final constrainedActionWidth =
        actionMaxWidth > 200 ? actionMaxWidth : width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Offer Management'),
          actions: [
            if (!useNavigationRail && !useNavigationBar)
              SizedBox(
                width: constrainedActionWidth,
                child: _buildTopNavActions(
                  context,
                  appStore,
                  beamer,
                  navItems,
                  selectedIndex,
                ),
              )
            else
              buildPopupMenuButton(context, appStore),
          ],
          automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: [
              Container(color: Theme.of(context).colorScheme.surface),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: SvgPicture.asset(
                    SomAssets.patternSubtleMesh,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: useNavigationRail
            ? Row(
                children: [
                  _buildNavigationRail(
                    context,
                    beamer,
                    navItems,
                    selectedIndex,
                    width,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: beamerWidget),
                ],
              )
            : beamerWidget,
        bottomNavigationBar: useNavigationBar
            ? _buildNavigationBar(context, beamer, navItems, selectedIndex)
            : null,
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
    final auth = appStore.authorization;
    final themeLabel = switch (appStore.themeMode) {
      ThemeMode.dark => 'Dark',
      ThemeMode.light => 'Light',
      ThemeMode.system => 'System',
    };
    final densityLabel = switch (appStore.density) {
      UiDensity.compact => 'Compact',
      UiDensity.standard => 'Standard',
      UiDensity.comfortable => 'Comfortable',
    };
    final appearanceSummary = '$themeLabel • $densityLabel';
    return PopupMenuButton(
      child: userMenuItem(context, appStore),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(child: userMenuItem(context, appStore)),
        PopupMenuItem(
          child: ListTile(
            leading: SomSvgIcon(
              SomAssets.iconNotification,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (context.mounted) {
                _showNotificationsDialog(context);
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: SomSvgIcon(
              SomAssets.iconUser,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'User account',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        if (auth?.canSwitchRole == true && auth?.activeRole != 'buyer')
          PopupMenuItem(
            child: ListTile(
              leading: SomSvgIcon(
                SomAssets.iconChevronRight,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Switch to buyer portal',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => _switchRole(context, 'buyer'),
            ),
          ),
        if (auth?.canSwitchRole == true && auth?.activeRole != 'provider')
          PopupMenuItem(
            child: ListTile(
              leading: SomSvgIcon(
                SomAssets.iconChevronRight,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Switch to provider portal',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => _switchRole(context, 'provider'),
            ),
          ),
        PopupMenuItem(
          child: ListTile(
            leading: SomSvgIcon(
              SomAssets.iconSettings,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text('Appearance',
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(
              appearanceSummary,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _showAppearanceDialog(context, appStore);
            },
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: ListTile(
            leading: SomSvgIcon(
              SomAssets.iconClose,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title:
                Text('Logout', style: Theme.of(context).textTheme.titleSmall),
            onTap: () {
              _logout(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showAppearanceDialog(
    BuildContext context,
    Application appStore,
  ) async {
    ThemeMode selectedTheme = appStore.themeMode;
    UiDensity selectedDensity = appStore.density;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appearance'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Theme', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              RadioGroup<ThemeMode>(
                groupValue: selectedTheme,
                onChanged: (value) => setState(() {
                  selectedTheme = value ?? ThemeMode.system;
                }),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      title: Text('System'),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      title: Text('Light'),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      title: Text('Dark'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text('Density', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButton<UiDensity>(
                value: selectedDensity,
                items: const [
                  DropdownMenuItem(
                    value: UiDensity.compact,
                    child: Text('Compact'),
                  ),
                  DropdownMenuItem(
                    value: UiDensity.standard,
                    child: Text('Standard'),
                  ),
                  DropdownMenuItem(
                    value: UiDensity.comfortable,
                    child: Text('Comfortable'),
                  ),
                ],
                onChanged: (value) => setState(() {
                  selectedDensity = value ?? UiDensity.standard;
                }),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              appStore.setThemeMode(selectedTheme);
              appStore.setDensity(selectedDensity);
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Future<void> _showNotificationsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const SizedBox(
          width: 360,
          child: EmptyState(
            asset: SomAssets.emptyNotifications,
            title: 'No notifications',
            message: 'You are all caught up.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getAuthApi().authLogoutPost();
    } catch (error, stackTrace) {
      UILogger.silentError('SomApplication._logout', error, stackTrace);
    }
    appStore.logout();
    if (context.mounted) {
      context.beamTo(AuthLoginPageLocation());
    }
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
        appStore.setActiveRole(role);
        SupabaseRealtime.setAuth(token);
      }
    } catch (error, stackTrace) {
      UILogger.silentError('SomApplication._switchRole', error, stackTrace);
    }
  }
}
