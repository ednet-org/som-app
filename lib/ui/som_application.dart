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
        body: useNavigationRail && navItems.isNotEmpty
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

  List<_NavItem> _buildNavItems({
    required bool isBuyer,
    required bool isProvider,
    required bool isConsultant,
    required bool isAdmin,
  }) {
    final items = <_NavItem>[
      if (isBuyer || isProvider || isConsultant)
        const _NavItem(
          label: 'Inquiries',
          route: '/inquiries',
          icon: SomAssets.iconInquiries,
        ),
      if (isBuyer || isProvider || isConsultant)
        const _NavItem(
          label: 'Offers',
          route: '/offers',
          icon: SomAssets.iconOffers,
        ),
      if (isBuyer || isProvider || isConsultant)
        const _NavItem(
          label: 'Statistics',
          route: '/statistics',
          icon: SomAssets.iconStatistics,
        ),
      if (isBuyer || isConsultant || (isProvider && isAdmin))
        const _NavItem(
          label: 'Ads',
          route: '/ads',
          icon: SomAssets.iconOffers,
        ),
      if (isAdmin && (isBuyer || isProvider))
        const _NavItem(
          label: 'User',
          route: '/user',
          icon: SomAssets.iconUser,
        ),
      if (isAdmin && (isBuyer || isProvider))
        const _NavItem(
          label: 'Company',
          route: '/company',
          icon: SomAssets.iconSettings,
        ),
      if (isConsultant)
        const _NavItem(
          label: 'Branches',
          route: '/branches',
          icon: SomAssets.iconSettings,
        ),
      if (isConsultant)
        const _NavItem(
          label: 'User Mgmt',
          route: '/consultants',
          icon: SomAssets.iconUser,
        ),
      if (isConsultant)
        const _NavItem(
          label: 'Companies',
          route: '/companies',
          icon: SomAssets.iconSettings,
        ),
      if (isConsultant && isAdmin)
        const _NavItem(
          label: 'Providers',
          route: '/providers',
          icon: SomAssets.iconSettings,
        ),
      if (isConsultant && isAdmin)
        const _NavItem(
          label: 'Subscriptions',
          route: '/subscriptions',
          icon: SomAssets.iconStatistics,
        ),
      if (isConsultant && isAdmin)
        const _NavItem(
          label: 'Roles',
          route: '/roles',
          icon: SomAssets.iconUser,
        ),
      if (isConsultant && isAdmin)
        const _NavItem(
          label: 'Audit',
          route: '/audit',
          icon: SomAssets.iconStatistics,
        ),
    ];
    return items;
  }

  String _currentPath(BeamerProvidedKey beamer) {
    final state =
        beamer.currentState?.routerDelegate.currentBeamLocation.state;
    if (state is BeamState) {
      return state.uri.path;
    }
    return state?.routeInformation.uri.path ?? '';
  }

  int _selectedIndex(List<_NavItem> items, String path) {
    if (items.isEmpty) return 0;
    for (var i = 0; i < items.length; i++) {
      if (items[i].matches(path)) return i;
    }
    return 0;
  }

  void _navigate(BeamerProvidedKey beamer, String route) {
    beamer.currentState?.routerDelegate.beamToNamed(route);
  }

  Widget _buildTopNavActions(
    BuildContext context,
    Application appStore,
    BeamerProvidedKey beamer,
    List<_NavItem> navItems,
    int selectedIndex,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 8),
            for (var i = 0; i < navItems.length; i++) ...[
              _TopNavButton(
                item: navItems[i],
                selected: i == selectedIndex,
                onPressed: () => _navigate(beamer, navItems[i].route),
              ),
              const SizedBox(width: 4),
            ],
            buildPopupMenuButton(context, appStore),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRail(
    BuildContext context,
    BeamerProvidedKey beamer,
    List<_NavItem> navItems,
    int selectedIndex,
    double width,
  ) {
    if (navItems.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final extended = width >= SomBreakpoints.navigationRail + 160;
    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) =>
          _navigate(beamer, navItems[index].route),
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      destinations: navItems
          .map(
            (item) => NavigationRailDestination(
              icon: SomSvgIcon(
                item.icon,
                size: SomIconSize.sm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: SomSvgIcon(
                item.icon,
                size: SomIconSize.sm,
                color: theme.colorScheme.primary,
              ),
              label: Text(item.label),
            ),
          )
          .toList(),
    );
  }

  Widget? _buildNavigationBar(
    BuildContext context,
    BeamerProvidedKey beamer,
    List<_NavItem> navItems,
    int selectedIndex,
  ) {
    if (navItems.isEmpty) return null;
    final theme = Theme.of(context);
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) =>
          _navigate(beamer, navItems[index].route),
      destinations: navItems
          .map(
            (item) => NavigationDestination(
              icon: SomSvgIcon(
                item.icon,
                size: SomIconSize.sm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: SomSvgIcon(
                item.icon,
                size: SomIconSize.sm,
                color: theme.colorScheme.primary,
              ),
              label: item.label,
            ),
          )
          .toList(),
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
        if (auth?.switchableContexts.isNotEmpty == true)
          ...auth!.switchableContexts.map(
            (option) => PopupMenuItem(
              child: ListTile(
                leading: SomSvgIcon(
                  SomAssets.iconChevronRight,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  'Switch to ${option.activeRole} • ${option.companyName}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () => _switchRole(
                  context,
                  option.activeRole,
                  option.companyId,
                ),
              ),
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
    await appStore.logout();
    if (context.mounted) {
      context.beamTo(AuthLoginPageLocation());
    }
  }

  Future<void> _switchRole(
    BuildContext context,
    String role,
    String companyId,
  ) async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    if (appStore.authorization == null) {
      return;
    }
    try {
      final response = await api.getAuthApi().authSwitchRolePost(
            authSwitchRolePostRequest:
                AuthSwitchRolePostRequest((b) => b
                  ..role = role
                  ..companyId = companyId),
          );
      final token = response.data?.token;
      if (token != null) {
        final userId = appStore.authorization?.userId;
        final profile = userId == null
            ? null
            : await api.getUsersApi().usersLoadUserWithCompanyGet(
                  userId: userId,
                  headers: {'Authorization': 'Bearer $token'},
                );
        final profileData = profile?.data;
        final companyOptions = _mapCompanyOptions(profileData);
        await appStore.login(
          appStore.authorization!.copyWith(
            token: token,
            roles: profileData?.roles?.toList() ??
                appStore.authorization?.roles,
            activeRole: profileData?.activeRole ?? role,
            companyId: profileData?.companyId ?? companyId,
            activeCompanyId: profileData?.activeCompanyId ?? companyId,
            companyName: profileData?.companyName ??
                appStore.authorization?.companyName,
            companyType: _companyTypeFromApi(profileData?.companyType) ??
                appStore.authorization?.companyType,
            companyOptions: companyOptions.isNotEmpty
                ? companyOptions
                : appStore.authorization!.companyOptions,
          ),
        );
        SupabaseRealtime.setAuth(token);
      }
    } catch (error, stackTrace) {
      UILogger.silentError('SomApplication._switchRole', error, stackTrace);
    }
  }

  List<CompanyContext> _mapCompanyOptions(
    UsersLoadUserWithCompanyGet200Response? data,
  ) {
    final options = data?.companyOptions;
    if (options != null && options.isNotEmpty) {
      return options
          .map(
            (option) => CompanyContext(
              companyId: option.companyId ?? '',
              companyName: option.companyName ?? '',
              companyType:
                  _companyTypeFromOption(option.companyType) ?? 0,
              roles: option.roles?.toList() ?? const [],
              activeRole: option.activeRole ?? '',
            ),
          )
          .where((option) => option.companyId.isNotEmpty)
          .toList();
    }
    final companyId = data?.companyId ?? '';
    if (companyId.isEmpty) return const [];
    return [
      CompanyContext(
        companyId: companyId,
        companyName: data?.companyName ?? '',
        companyType: _companyTypeFromApi(data?.companyType) ?? 0,
        roles: data?.roles?.toList() ?? const [],
        activeRole: data?.activeRole ?? '',
      ),
    ];
  }

  int? _companyTypeFromOption(
    UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum?
        value,
  ) {
    switch (value) {
      case UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
            .number0:
        return 0;
      case UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
            .number1:
        return 1;
      case UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
            .number2:
        return 2;
      case null:
        return null;
    }
    return null;
  }

  int? _companyTypeFromApi(
    UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? value,
  ) {
    switch (value) {
      case UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.number0:
        return 0;
      case UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.number1:
        return 1;
      case UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.number2:
        return 2;
      case null:
        return null;
    }
    return null;
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final String icon;

  bool matches(String path) {
    if (path == route) return true;
    return path.startsWith('$route/');
  }
}

class _TopNavButton extends StatelessWidget {
  const _TopNavButton({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return TextButton.icon(
      onPressed: onPressed,
      icon: SomSvgIcon(
        item.icon,
        size: SomIconSize.sm,
        color: color,
      ),
      label: Text(item.label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: theme.textTheme.labelLarge,
      ),
    );
  }
}
