import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class StatisticsBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('Statistics page'),
        title: 'Statistics',
        child: Text('Statistics'),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/statistics',
      ];
}
