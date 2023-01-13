import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../positioned _info.dart';

class InquiryCardTitle<T extends Entity> extends StatelessWidget {
  final T inquiry;

  const InquiryCardTitle({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
        top: 20,
        left: 10,
        child: Text(inquiry.name,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)));
  }
}
