import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';
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
      if (isCompanyLocation)
        BeamPage(
          key: ValueKey('company smart offer management page'),
          title: 'Smart Offer Management',
          child: AppBody(
            contextMenu: Text('Company'),
            leftSplit: Text('Company thingy'),
            rightSplit: Text('Company thingy'),
          ),
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
