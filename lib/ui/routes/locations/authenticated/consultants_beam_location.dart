import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/consultants/consultants_app_body.dart';

class ConsultantsBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('consultants page'),
        title: 'Consultants',
        child: ConsultantsAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/consultants',
      ];
}
