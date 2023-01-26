import 'package:flutter/material.dart';

class InquiryCardContainer extends StatelessWidget {
  const InquiryCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
        width: 400,
        height: 375,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: theme.shadowColor,
                  offset: const Offset(0, 2),
                  blurRadius: 4)
            ],
            color: theme.colorScheme.surface));
  }
}
