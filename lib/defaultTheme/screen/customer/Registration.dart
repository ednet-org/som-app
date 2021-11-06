import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:som/defaultTheme/screen/template/DTNoDataScreen.dart';

import '../../../domain/model/customer-management/roles.dart';
import '../../../main.dart';
import 'RoleSelection.dart';

class Registration extends StatefulWidget {
  @override
  createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleSelection(),
        Observer(builder: (_) {
          print('\n\nyou hit me !! \n\n');
          print(customerStore.fullName);
          print('\n\n');
          if (customerStore.role == Roles.Buyer) {
            return buyerForm();
          }

          if (customerStore.role == Roles.Provider) {
            return providerForm();
          }

          if (customerStore.role == Roles.ProviderAndBuyer) {
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
