import 'package:flutter/material.dart';

class InquiryCardDivider extends StatelessWidget {
  const InquiryCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      child: Divider(
        thickness: 3,
        height: 1,
        // thickness: 1,
      ),
    );
  }
}
