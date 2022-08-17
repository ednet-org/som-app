import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';

class UserAppBody extends StatelessWidget {
  const UserAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text('Context'),
      leftSplit: Text('Users'),
      rightSplit: Text('Roles'),
    );
  }
}
