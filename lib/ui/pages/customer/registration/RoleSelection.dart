import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

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
      // width: 800,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Please select which type of company are you registering'),
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
    return ContainerX(
      mobile: mobileWidget(),
      web: webWidget(),
    );
  }

  buyerSelector() {
    final ButtonStyle buyerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 12),
        primary: appIconTintDark_purple);
    return ElevatedButton(
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
        ));
  }

  providerSelector() {
    final ButtonStyle providerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 12), primary: appColorPrimaryDark);
    return ElevatedButton(
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
        ));
  }

  mobileWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buyerSelector(),
        10.height,
        providerSelector(),
      ],
    );
  }

  webWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buyerSelector(),
        10.width,
        providerSelector(),
      ],
    );
  }
}
