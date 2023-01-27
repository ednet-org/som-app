import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';

class AdsAppBody extends StatelessWidget {
  const AdsAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppBody(
      contextMenu: Text('Context'),
      leftSplit: Text('Ads thingy'),
      rightSplit: Text('Ads right thingy'),
    );
  }
}
