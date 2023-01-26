import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../domain/model/inquiry_management/inquiry.dart';
import 'inquiry_card_components/inquiry_card_container.dart';
import 'inquiry_card_components/inquiry_card_description.dart';
import 'inquiry_card_components/inquiry_card_divider.dart';
import 'inquiry_card_components/inquiry_card_status.dart';
import 'inquiry_card_components/inquiry_card_title.dart';
import 'positioned _info.dart';

class InquiryCard extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCard({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 315,
        height: 375,
        child: Stack(children: <Widget>[
          const PositionedInfo(
              top: 0, left: 0, child: InquiryCardContainer()),
          InquiryCardTitle(inquiry: inquiry),
          InquiryCardDescription(inquiry: inquiry),
          InquiryCardStatus(inquiry: inquiry),
          const InquiryCardDivider(),
        ]));
  }
}
