import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/som_application.dart';

class SmartOfferManagementPageLocation extends BeamLocation<BeamState> {
  SmartOfferManagementPageLocation({RouteInformation? routeInformation})
      : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final isCompanyLocation =
        state.routeInformation.location?.contains('company') ?? false;
    return [
      BeamPage(
        key: ValueKey('smart offer management page'),
        title: 'Smart Offer Management',
        child: SomApplication(),
      ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => [
        '/',
        '/*',
      ];
}
