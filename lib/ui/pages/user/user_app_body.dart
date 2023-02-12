import 'package:flutter/material.dart';

import '../../components/low/layout/app_body.dart';

class UserAppBody extends StatelessWidget {
  const UserAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppBody(
      contextMenu: Text('Context'),
      leftSplit: Text('Users'),
      rightSplit: Text('Roles'),
    );
  }
}
