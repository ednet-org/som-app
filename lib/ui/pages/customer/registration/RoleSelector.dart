import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/lead_customer_store.dart';
import 'package:som/domain/model/customer-management/roles.dart';
import 'package:som/template_storage/main/utils/AppConstant.dart';
import 'package:som/ui/components/utils/DTWidgets.dart';

import '../../../../../../main.dart';

class RoleSelector extends StatelessWidget {
  final Roles role;

  const RoleSelector({required this.role, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerStore = Provider.of<LeadCustomerStore>(context);

    var roleTitle = role.toString().splitAfter('.');

    return Observer(
      builder: (_) => GestureDetector(
        onTap: () {
          customerStore.selectRole(role);
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
          margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            gradient: customerStore.role == role
                ? defaultThemeGradient()
                : LinearGradient(
                    colors: [appStore.appBarColor!, appStore.appBarColor!]),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Colors.black12, width: 0.5),
          ),
          child: Text(
            roleTitle,
            style: primaryTextStyle(
                size: textSizeXXLarge.toInt(),
                color: customerStore.role == role
                    ? white
                    : appStore.textPrimaryColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
