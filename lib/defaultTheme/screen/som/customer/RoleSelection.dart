import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/som/customer/Registration.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import '../../../../main.dart';

class CRoleSelection extends StatefulWidget {
  Roles selectedRole = Roles.Buyer;

  CRoleSelection(Roles selectedRole);

  @override
  CRoleSelectionState createState() => CRoleSelectionState();
}

class CRoleSelectionState extends State<CRoleSelection> {
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
                  setState(() {

                    widget.selectedRole = Roles.Provider;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    gradient: widget.selectedRole == Roles.Provider
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
                        color: widget.selectedRole == Roles.Provider
                            ? white
                            : appStore.textPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedRole = Roles.Buyer;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    gradient: widget.selectedRole == Roles.Buyer
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
                        color: widget.selectedRole == Roles.Buyer
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
