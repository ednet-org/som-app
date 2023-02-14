import 'package:flutter/material.dart';

import '../../domain/model/model.dart';


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
