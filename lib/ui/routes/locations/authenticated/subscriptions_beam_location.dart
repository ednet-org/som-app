import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/subscriptions/subscriptions_app_body.dart';

class SubscriptionsBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return const [
      BeamPage(
        key: ValueKey('subscriptions page'),
        title: 'Subscriptions',
        child: SubscriptionsAppBody(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/subscriptions',
      ];
}
