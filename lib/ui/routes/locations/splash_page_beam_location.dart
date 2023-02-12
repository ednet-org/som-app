import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/splash_page.dart';

class SplashPageBeamLocation extends BeamLocation<BeamState> {
  SplashPageBeamLocation({RouteInformation? routeInformation})
      : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/splash',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('Splash Page'),
        title: 'Welcome to Smart Offer Management',
        child: SplashPage(),
      ),
    ];
  }
}
