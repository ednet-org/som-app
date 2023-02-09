import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';
import 'package:som/domain/model/inquiry_management/inquiry_status.dart';

class InquiryCardStatus extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardStatus({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.black;
    switch (inquiry.status) {
      case InquiryStatus.draft:
        backgroundColor = Colors.green;
        break;
      case InquiryStatus.published:
        backgroundColor = Colors.red;
        break;
      case InquiryStatus.responded:
        backgroundColor = Colors.yellow;
        break;
      case InquiryStatus.expired:
        backgroundColor = Colors.blue;
        break;
      case InquiryStatus.closed:
        backgroundColor = Colors.purple;
        break;
    }
    return Badge(
      label: Text(inquiry.status.toString().split('.').last),
      textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white,
          ),
      backgroundColor: backgroundColor,
    );
  }
}
