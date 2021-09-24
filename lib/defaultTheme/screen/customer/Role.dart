import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/domain/application/customer-store.dart';
import 'package:som/domain/model/customer-management/roles.dart';
import 'package:som/main/utils/AppConstant.dart';

import '../../../../main.dart';

class Role extends StatelessWidget {
  final RegisteringCustomer registeringCustomer;
  final Roles role;

  const Role({required this.role, required this.registeringCustomer, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var roleTitle = role.toString().splitAfter('.');
    print('registeringCustomer.role ');
    print(registeringCustomer.role);
    return GestureDetector(
      onTap: () {
        registeringCustomer.selectRole(role);
      },
      child: Observer(
        builder: (_) => Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
          margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            gradient: registeringCustomer.role == role
                ? defaultThemeGradient()
                : LinearGradient(
                    colors: [appStore.appBarColor!, appStore.appBarColor!]),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Colors.black12, width: 0.5),
          ),
          child: Text(
            roleTitle,
            style: primaryTextStyle(
                size: textSizeMedium.toInt(),
                color: registeringCustomer.role == role
                    ? white
                    : appStore.textPrimaryColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
