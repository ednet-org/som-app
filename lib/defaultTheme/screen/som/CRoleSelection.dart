import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import '../../../main.dart';

class CRoleSelection extends StatefulWidget {
  @override
  CRoleSelectionState createState() => CRoleSelectionState();
}

class CRoleSelectionState extends State<CRoleSelection> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Please select role.', style: primaryTextStyle(size: 18))
            .paddingOnly(left: 8, right: 8),
        16.height,
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  selectIndex = 0;
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    gradient: selectIndex == 0
                        ? defaultThemeGradient()
                        : LinearGradient(colors: [
                            appStore.appBarColor!,
                            appStore.appBarColor!
                          ]),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.black12, width: 0.5),
                  ),
                  child: Text(
                    'Provider',
                    style: primaryTextStyle(
                        size: 14,
                        color: selectIndex == 0
                            ? white
                            : appStore.textPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  selectIndex = 1;
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    gradient: selectIndex == 1
                        ? defaultThemeGradient()
                        : LinearGradient(colors: [
                            appStore.appBarColor!,
                            appStore.appBarColor!
                          ]),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.black12, width: 0.5),
                  ),
                  child: Text(
                    'Buyer',
                    style: primaryTextStyle(
                        size: 14,
                        color: selectIndex == 1
                            ? white
                            : appStore.textPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        8.height,
      ],
    );
  }
}
