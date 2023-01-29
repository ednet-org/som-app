import 'package:flutter/material.dart';
import 'package:som/ui/components/cards/inquiry/inquiry_card_components/inquiry_card_divider.dart';

import '../../../../domain/model/inquiry_management/inquiry.dart';
import 'inquiry_card_components/inquiry_card_container.dart';
import 'inquiry_card_components/inquiry_card_description.dart';
import 'inquiry_card_components/inquiry_card_status.dart';
import 'inquiry_card_components/inquiry_card_title.dart';
import 'positioned _info.dart';

class InquiryCard extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCard({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 375,
      child: Stack(
        children: <Widget>[
          const PositionedInfo(
            top: 0,
            left: 0,
            child: InquiryCardContainer(),
          ),
          PositionedInfo(
            top: 20,
            left: 20,
            child: InquiryCardStatus(inquiry: inquiry),
          ),
          PositionedInfo(
            top: 20,
            left: 50,
            child: InquiryCardTitle(inquiry: inquiry),
          ),
          const PositionedInfo(
            top: 70,
            left: 10,
            child: InquiryCardDivider(),
          ),
          PositionedInfo(
            top: 80,
            left: 10,
            child: InquiryCardDescription(inquiry: inquiry),
          ),
          PositionedInfo(
            top: 260,
            left: 10,
            child: InquiryBranch(inquiry: inquiry),
          ),
          PositionedInfo(
            top: 260,
            left: 250,
            child: InquiryCategory(inquiry: inquiry),
          ),
          const PositionedInfo(
            top: 300,
            left: 10,
            child: InquiryCardDivider(),
          ),
        ],
      ),
    );
  }
}

class InquiryBranch extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryBranch({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 150,
      child: Text(
        inquiry.branch.toString(),
        maxLines: 2,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class InquiryCategory extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCategory({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 150,
      child: Text(
        inquiry.category.toString(),
        maxLines: 2,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
