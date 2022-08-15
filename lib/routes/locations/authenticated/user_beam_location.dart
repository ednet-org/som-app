import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class UserBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('User page'),
        title: 'User',
        child: Text('User'),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/user',
      ];
}
