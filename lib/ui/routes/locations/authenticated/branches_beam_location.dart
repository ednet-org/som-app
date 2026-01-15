import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/branches/branches_app_body.dart';

class BranchesBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('branches page'),
        title: 'Branches',
        child: BranchesAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/branches',
      ];
}
