import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';

class AppBarButton extends StatefulWidget {
  const AppBarButton({
    required super.key,
    required this.title,
    required this.beamer,
    required this.uri,
    required this.child,
  });

  final GlobalKey<BeamerState> beamer;
  final String uri;
  final String title;
  final String child;

  @override
  _AppBarButtonState createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton> {
  void _setStateListener() => setState(() {});

  @override
  void initState() {
    super.initState();

    /// only if mounted
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => widget
          .beamer.currentState?.routerDelegate
          .addListener(_setStateListener));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            widget.child,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
          onPressed: () => widget.beamer.currentState?.routerDelegate
              .beamToNamed(widget.uri),
          tooltip: '${widget.title} management page',
        ),
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.beamer.currentState?.routerDelegate
        .removeListener(_setStateListener);
    super.dispose();
  }
}

enum AppBarIcons {
  ads,
  company,
  user,
  statistics,
  inquiry,
  offer,
}

extension AppBarIconsExtension on AppBarIcons {
  String get value {
    switch (this) {
      case AppBarIcons.company:
        return SomAssets.iconDashboard; // Mapping to Dashboard for now

      case AppBarIcons.ads:
        return SomAssets.iconInfo; // Placeholder

      case AppBarIcons.inquiry:
        return SomAssets.iconInquiries;

      case AppBarIcons.offer:
        return SomAssets.iconOffers;

      case AppBarIcons.statistics:
        return SomAssets.iconStatistics;

      case AppBarIcons.user:
        return SomAssets.iconUser;

      default:
        return SomAssets.logoMark;
    }
  }
}
