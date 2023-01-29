import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';
import 'package:som/domain/model/inquiry_management/inquiry_status.dart';

class InquiryCardStatus extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardStatus({super.key, required this.inquiry});

  Map<String, Color> inquiryStatusColor(context) {
    var inquiryStatus = inquiry.status;
    switch (inquiryStatus) {
      case InquiryStatus.closed:
        return {
          "textColor": Theme.of(context).colorScheme.onPrimary,
          "backgroundColor": Theme.of(context).colorScheme.primary,
        };
      case InquiryStatus.responded:
        return {
          "textColor": Theme.of(context).colorScheme.onPrimary,
          "backgroundColor": Theme.of(context).colorScheme.primary,
        };
      case InquiryStatus.published:
        return {
          "textColor": Theme.of(context).colorScheme.onPrimary,
          "backgroundColor": Theme.of(context).colorScheme.primary,
        };

      case InquiryStatus.draft:
        return {
          "textColor": Theme.of(context).colorScheme.onPrimary,
          "backgroundColor": Theme.of(context).colorScheme.primary,
        };
      default:
        return {
          "textColor": Theme.of(context).colorScheme.onPrimary,
          "backgroundColor": Theme.of(context).colorScheme.primary,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = inquiryStatusColor(context);
    return Badge(
      label: Text(inquiry.status.toString().split('.').last),
      textStyle: Theme.of(context).textTheme.labelSmall,
      textColor: status["textColor"],
      backgroundColor: status["backgroundColor"],
    );
  }
}
