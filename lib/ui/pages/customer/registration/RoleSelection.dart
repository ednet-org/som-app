import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/main/utils/AppConstant.dart';

class RoleSelection extends StatefulWidget {
  RoleSelection();

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  bool isProvider = false;
  bool isBuyer = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please select which type of company are you registering:',
                  style: primaryTextStyle(size: textSizeLarge.toInt()))
              .paddingOnly(left: 8, top: 50, right: 8),
          16.height,
          Container(
            child: selectionCards,
          ),
          8.height,
        ],
      ),
    );
  }

  Widget get selectionCards {
    final ButtonStyle buyerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20), primary: appCat1);
    final ButtonStyle providerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: appIconTint_mustard_yellow);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
            style: buyerStyle,
            onPressed: () {
              setState(() {
                isBuyer = !isBuyer;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Buyer ', style: boldTextStyle(size: 24)),
                  Switch(
                      value: isBuyer,
                      onChanged: (value) {
                        setState(() {
                          isBuyer = value;
                          print(isBuyer);
                        });
                      }),
                ],
              ),
            )),
        10.width,
        ElevatedButton(
            style: providerStyle,
            onPressed: () {
              setState(() {
                isProvider = !isProvider;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Provider', style: boldTextStyle(size: 24)),
                  Switch(
                      value: isProvider,
                      onChanged: (value) {
                        setState(() {
                          isProvider = value;
                          print(isProvider);
                        });
                      }),
                ],
              ),
            )),
      ],
    );
  }
}
