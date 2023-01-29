import 'package:flutter/material.dart';

class InquiryCardDivider extends StatelessWidget {
  const InquiryCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 380,
      child: Divider(
        height: 1,
        // thickness: 1,
      ),
    );
  }
}
