import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatefulWidget {
  AppBarButton({
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => widget
        .beamer.currentState?.routerDelegate
        .addListener(_setStateListener));
  }

  @override
  Widget build(BuildContext context) {
    final path = (context.currentBeamLocation.state as BeamState).uri.path;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          // hoverColor: Theme.of(context).colorScheme.secondary,
          icon: ImageIcon(
            AssetImage(widget.child),
            // color: Theme.of(context).colorScheme.primaryContainer,
          ),
          onPressed: () => widget.beamer.currentState?.routerDelegate
              .beamToNamed(widget.uri),
          tooltip: widget.title,
          iconSize: 50,
        ));
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
        return "images/som/icons/company_icon_outlined.png";

      case AppBarIcons.ads:
        return "images/som/icons/ads_icon_outlined.png";

      case AppBarIcons.inquiry:
        return "images/som/icons/inquiries_icon_outlined_sec.png";

      case AppBarIcons.offer:
        return "images/som/icons/offer_icon_outlined.png";

      case AppBarIcons.statistics:
        return "images/som/icons/statistics_icon_outlined.png";

      case AppBarIcons.user:
        return "images/som/icons/user_icon_outlined.png";

      default:
        return "";
    }
  }
}
