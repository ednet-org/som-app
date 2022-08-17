import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/company/company_app_body.dart';

class CompanyBeamLocation extends BeamLocation<BeamState> {
  CompanyBeamLocation({RouteInformation? routeInformation})
      : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/company',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('company page'),
        title: 'Company',
        child: CompanyAppBody(),
      ),
    ];
  }
}
