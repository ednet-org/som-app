import 'package:flutter/material.dart';

import '../../../domain/model/customer-management/roles.dart';
import 'RoleSelection.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  @override
  createState() => CustomerRegistrationScreenState();
}

class CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  var selectedRole = Roles.Buyer;

  selectRole(var role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CRoleSelection(selectRole, selectedRole),
        CRegistrationForm(selectedRole),
      ],
    );
  }
}

class CRegistrationForm extends StatelessWidget {
  final Roles selectedRole;

  CRegistrationForm(this.selectedRole);

  Widget build(BuildContext context) {
    if (this.selectedRole == Roles.Buyer) {
      return buyerForm();
    }

    if (this.selectedRole == Roles.Provider) {
      return providerForm();
    }

    if (this.selectedRole == Roles.ProviderAndBuyer) {
      return providerAndBuyerForm();
    }

    throw Exception('NotImplemented');
  }

  providerForm() => company(
        Text('provider'),
      );

  buyerForm() => company(
        Text('buyer or not'),
      );

  providerAndBuyerForm() => company(
        Text('Both roles are assumed.'),
      );

  company(data) {
    return Column(
      children: [
        Text('lorem ipsum'),
        data,
      ],
    );
  }
}
