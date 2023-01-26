import 'package:flutter/material.dart';

class InquiryCardDivider extends StatelessWidget {
  const InquiryCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 380,
      child: Divider(
        color: theme.colorScheme.onSurface,
        height: 1,
        // thickness: 1,
      ),
    );
  }
}
