import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';

class InquiryCardDescription<T> extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardDescription({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 380,
      child: Text(inquiry.description.toString(),
          maxLines: 10,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface)),
    );
  }
}
