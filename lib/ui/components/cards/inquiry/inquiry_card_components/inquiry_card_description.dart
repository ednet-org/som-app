import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';

import '../positioned _info.dart';

class InquiryCardDescription<T extends Entity> extends StatelessWidget {
  final T inquiry;

  const InquiryCardDescription({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
      top: 15,
      left: 108,
      child: Text(inquiry.description.toString()),
    );
  }
}
