import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/roles/roles_app_body.dart';

class RolesBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('roles page'),
        title: 'Roles',
        child: RolesAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/roles',
      ];
}
