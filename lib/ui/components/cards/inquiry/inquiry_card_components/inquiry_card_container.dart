import 'package:flutter/material.dart';

class InquiryCardContainer extends StatelessWidget {
  const InquiryCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 315,
        height: 375,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(0, 2),
                  blurRadius: 6)
            ],
            color: Color.fromRGBO(255, 251, 255, 1)));
  }
}
