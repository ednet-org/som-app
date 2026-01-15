import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/providers/providers_app_body.dart';

class ProvidersBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('providers page'),
        title: 'Providers',
        child: ProvidersAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/providers',
      ];
}
