import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';

class InquiryCardDescription<T> extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardDescription({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(inquiry.description,
        maxLines: 10,
        style: theme.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis);
  }
}
