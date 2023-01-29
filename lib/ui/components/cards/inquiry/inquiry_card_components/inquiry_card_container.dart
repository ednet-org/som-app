import 'package:flutter/material.dart';

class InquiryCardContainer extends StatelessWidget {
  const InquiryCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        elevation: 5,
        child: SizedBox(
          width: 400,
          height: 375,
        ),
      ),
    );
  }
}
