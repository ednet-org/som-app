import 'package:flutter/material.dart';

// import 'package:som/ui/components/cards/inquiry_info_card.dart';
import 'package:som/ui/components/layout/app_body.dart';

class InquiryAppBody extends StatelessWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text(
        'Filter Inquiry',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      leftSplit: GridView.builder(
        itemCount: 15,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            'images/som/InquiryInfoCard.png',
            height: 500,
            fit: BoxFit.fitHeight,
          );
        },
      ),
      rightSplit: GridView.builder(
        itemCount: 21,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            'images/som/InquiryInfoCard.png',
            height: 500,
            fit: BoxFit.fitHeight,
          );
        },
      ),
    );
  }
}
