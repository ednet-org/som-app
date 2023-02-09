import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:som/template_storage/main/store/application.dart';
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

    final appStore = Provider.of<Application>(context);
    final CurrentLayoutAndUIConstraints layout = appStore.layout;
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
            constraints: const BoxConstraints(
              maxWidth: 450, // layout.constraints.containerLayout.maxWidth,
              maxHeight: 500, //layout.constraints.containerLayout.maxHeight,
              minWidth: 350, //layout.constraints.containerLayout.minWidth,
              minHeight: 350, //layout.constraints.containerLayout.minHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      InquiryCardTitle(inquiry: inquiry),
                      Expanded(
                        child: InquiryCardStatus(
                          inquiry: inquiry,
                        ),
                      ),
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
