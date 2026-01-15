import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/companies/companies_app_body.dart';

class CompaniesBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('companies page'),
        title: 'Companies',
        child: CompaniesAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/companies',
      ];
}
