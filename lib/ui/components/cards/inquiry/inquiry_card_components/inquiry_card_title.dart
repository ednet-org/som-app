import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';

class InquiryCardTitle extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardTitle({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 295,
      child: Text(
        inquiry.title.value ?? '',
        maxLines: 4,
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}
