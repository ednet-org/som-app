import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/audit/audit_app_body.dart';

class AuditBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('audit page'),
        title: 'Audit',
        child: AuditAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/audit',
      ];
}
