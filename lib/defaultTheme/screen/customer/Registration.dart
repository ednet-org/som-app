import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:som/main.dart';

import '../../../domain/model/customer-management/roles.dart';
import 'RoleSelection.dart';

var registeringCustomer = customerStore.registeringCustomer;

class CustomerRegistrationScreen extends StatefulWidget {
  @override
  createState() => CustomerRegistrationScreenState();
}

class CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CRoleSelection(),
        CRegistrationForm(),
      ],
    );
  }
}

class CRegistrationForm extends StatelessWidget {
  Widget build(BuildContext context) {
    return Observer(builder: (_) => {
    if (registeringCustomer.role == Roles.Buyer) {
        return buyerForm();
  }

    if (registeringCustomer.role == Roles.Provider) {
    return providerForm();
    }

    if (registeringCustomer.role == Roles.ProviderAndBuyer) {
    return providerAndBuyerForm();
    }

    throw Exception('NotImplemented');
    });
  }

  Widget providerForm() =>
      company(
        Text('provider'),
      );

  Widget buyerForm() =>
      company(
        Text('buyer or not'),
      );

  Widget providerAndBuyerForm() =>
      company(
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
