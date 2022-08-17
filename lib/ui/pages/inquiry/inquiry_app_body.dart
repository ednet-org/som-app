import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';

class InquiryAppBody extends StatelessWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text('Inquiry'),
      leftSplit: Text('New one'),
      rightSplit: Text('Old one'),
    );
  }
}
