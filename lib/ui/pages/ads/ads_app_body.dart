import 'package:flutter/material.dart';

import '../../domain/model/model.dart';


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
