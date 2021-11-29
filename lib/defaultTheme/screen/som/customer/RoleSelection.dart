import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main/utils/AppColors.dart';
import 'package:som/main/utils/AppConstant.dart';

class RoleSelection extends StatelessWidget {
  RoleSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Please select role.',
                style: primaryTextStyle(size: textSizeXLarge.toInt()))
            .paddingOnly(left: 8, top: 20, right: 8),
        16.height,
        Container(
          child: selectionCards,
        ),
        8.height,
      ],
    );
  }

  Widget get selectionCards {
    final ButtonStyle buyerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20), primary: appCat1);
    final ButtonStyle providerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: appIconTint_mustard_yellow);
    final ButtonStyle bothStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: appDark_parrot_green);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: buyerStyle,
            onPressed: () {
              print('Buyer');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Buyer', style: boldTextStyle(size: 24)),
            )),
        10.width,
        ElevatedButton(
            style: providerStyle,
            onPressed: () {
              print('Provider');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Provider', style: boldTextStyle(size: 24)),
            )),
        10.width,
        ElevatedButton(
            style: bothStyle,
            onPressed: () {
              print('Both');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Both', style: boldTextStyle(size: 24)),
            )),
      ],
    ).paddingTop(500);
  }
}
