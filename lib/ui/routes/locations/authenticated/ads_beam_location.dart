import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/ads/ads_page.dart';

class AdsBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('ads page'),
        title: 'Ads',
        child: AdsPage(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/ads',
      ];
}
