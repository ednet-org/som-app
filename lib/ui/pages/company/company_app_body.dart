import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';

class CompanyAppBody extends StatelessWidget {
  const CompanyAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text('Company'),
      leftSplit: Text('Company thingy'),
      rightSplit: Text('Company thingy'),
    );
  }
}
