import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/offers/offers_app_body.dart';

class OffersBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('offers page'),
        title: 'Offers',
        child: OffersAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/offers'];
}
