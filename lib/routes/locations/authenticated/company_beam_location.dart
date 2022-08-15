import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

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
        child: CompanyPage(),
      ),
    ];
  }
}

class CompanyPage extends StatelessWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: Text('Moin!'),
    );
  }
}
