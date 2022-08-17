import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/user/user_app_body.dart';

class UserBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('User page'),
        title: 'User',
        child: UserAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/user',
      ];
}
