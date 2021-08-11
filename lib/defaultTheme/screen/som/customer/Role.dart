import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/som/customer/Roles.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppConstant.dart';
import '../../../../main.dart';

class Role extends StatelessWidget {
  final Roles selectedRole;
  final Function selectRole;
  final Roles role;

  const Role(
      {required this.role,
      required this.selectRole,
      required this.selectedRole,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var roleTitle = role.toString().splitAfter('.');

    return GestureDetector(
      onTap: () {
        selectRole(role);
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
        margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        decoration: BoxDecoration(
          gradient: selectedRole == role
              ? defaultThemeGradient()
              : LinearGradient(
                  colors: [appStore.appBarColor!, appStore.appBarColor!]),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: Text(
          roleTitle,
          style: primaryTextStyle(
              size: textSizeXLarge.toInt(),
              color: selectedRole == role ? white : appStore.textPrimaryColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
