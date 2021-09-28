import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:som/defaultTheme/screen/template/DTNoDataScreen.dart';

import '../../../domain/model/customer-management/roles.dart';
import '../../../main.dart';
import 'RoleSelection.dart';

var registeringCustomer = customerStore.registeringCustomer;

class Registration extends StatefulWidget {
  @override
  createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CRoleSelection(),
        Observer(builder: (_) {
          print('\n\nyou hit me !! \n\n');
          print(registeringCustomer.fullName);
          print('\n\n');
          if (registeringCustomer.role == Roles.Buyer) {
            return buyerForm();
          }

          if (registeringCustomer.role == Roles.Provider) {
            return providerForm();
          }

          if (registeringCustomer.role == Roles.ProviderAndBuyer) {
            return providerAndBuyerForm();
          }

          return DTNoDataScreen();
        }),
      ],
    );
  }

  Widget providerForm() => company(
        Text('provider'),
      );

  Widget buyerForm() => company(
        Text('buyer or not'),
      );

  Widget providerAndBuyerForm() => company(
        Text('Both roles are assumed.'),
      );

  Widget company(data) {
    return Column(
      children: [
        Text('lorem ipsum'),
        data,
      ],
    );
  }
}
