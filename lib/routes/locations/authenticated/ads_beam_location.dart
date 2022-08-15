import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class AdsBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('ads page'),
        title: 'Ads',
        child: Text('Ads'),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/ads',
      ];
}
