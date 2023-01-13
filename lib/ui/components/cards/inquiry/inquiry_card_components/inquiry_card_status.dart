import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry_status.dart';

import '../positioned _info.dart';

class InquiryCardStatus<T extends Entity> extends StatelessWidget {
  final T inquiry;

  const InquiryCardStatus({super.key, required this.inquiry});

  Color get inquiryStatusColor {
    var inquiryStatus = inquiry.status;
    switch (inquiryStatus) {
      case InquiryStatus.closed:
        return Colors.green;
      case InquiryStatus.responded:
        return Colors.yellow;
      case InquiryStatus.published:
        return Colors.red;
      case InquiryStatus.draft:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
        top: 20.5,
        left: 270,
        child: Container(
            width: 17,
            height: 15,
            decoration: BoxDecoration(
              color: inquiryStatusColor,
              borderRadius: const BorderRadius.all(Radius.elliptical(17, 15)),
            )));
  }
}
