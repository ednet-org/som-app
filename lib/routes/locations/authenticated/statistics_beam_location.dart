import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/statistics/statistics_app_body.dart';

class StatisticsBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('Statistics page'),
        title: 'Statistics',
        child: StatisticsAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/statistics',
      ];
}
