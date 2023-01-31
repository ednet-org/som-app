import 'package:flutter/material.dart';
import 'package:som/ui/components/cards/inquiry/inquiry_card_components/inquiry_card_divider.dart';
import 'package:som/ui/components/cards/inquiry/inquiry_card_components/inquiry_colors.dart';

import '../../../../domain/model/inquiry_management/inquiry.dart';
import 'inquiry_card_components/inquiry_card_description.dart';
import 'inquiry_card_components/inquiry_card_status.dart';
import 'inquiry_card_components/inquiry_card_title.dart';

class InquiryCard extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryCard({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final status = InquiryColors.inquiryStatusColor(context, inquiry.status);

    return Center(
      child: Card(
        color: status["back"],
        surfaceTintColor: status["front"],
        elevation: 5,
        child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 800,
              minWidth: 300,
              minHeight: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      InquiryCardStatus(inquiry: inquiry),
                      const SizedBox(
                        width: 10,
                      ),
                      InquiryCardTitle(inquiry: inquiry),
                    ],
                  ),
                  const InquiryCardDivider(),
                  InquiryCardDescription(inquiry: inquiry),
                  const Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  const InquiryCardDivider(),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      InquiryBranch(inquiry: inquiry),
                      const SizedBox(
                        width: 10,
                      ),
                      const VerticalDivider(),
                      const SizedBox(
                        width: 10,
                      ),
                      InquiryCategory(inquiry: inquiry),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  ///     return const Center(
//       child: Card(
//         elevation: 5,
//         child: SizedBox(
//           width: 400,
//           height: 375,
//         ),
//       ),
//     );
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
