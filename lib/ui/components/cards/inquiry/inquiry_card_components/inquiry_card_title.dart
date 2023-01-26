import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';

import '../positioned _info.dart';

class InquiryCardTitle extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCardTitle({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
        top: 20,
        left: 10,
        child: Text(inquiry.id,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)));
  }
}
