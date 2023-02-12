import 'package:flutter/material.dart';

import '../../components/low/layout/app_body.dart';

class StatisticsAppBody extends StatelessWidget {
  const StatisticsAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppBody(
      contextMenu: Text('Statistics'),
      leftSplit: Text('User'),
      rightSplit: Text('Inquiry'),
    );
  }
}
