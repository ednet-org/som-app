import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';

class StatisticsAppBody extends StatelessWidget {
  const StatisticsAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text('Statistics'),
      leftSplit: Text('User'),
      rightSplit: Text('Inquiry'),
    );
  }
}
