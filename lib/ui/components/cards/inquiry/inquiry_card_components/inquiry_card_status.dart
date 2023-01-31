import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';

class InquiryCardStatus extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardStatus({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(inquiry.status.toString().split('.').last),
      textStyle: Theme.of(context).textTheme.labelSmall,
    );
  }
}
