import 'package:flutter/material.dart';

import 'RoleSelection.dart';
import '../../../domain/model/customer-management/roles.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  @override
  createState() => CustomerRegistrationScreenState();
}

class CustomerRegistrationScreenState extends State<CustomerRegistrationScreen> {
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

  // candidate for state management layer
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Nesxta')
      ],
    );

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

  providerForm() {
    return Text('provider');
  }

  buyerForm() {
    return Text('buyer or not');
  }

  providerAndBuyerForm() {
    return Text('Both roles are assumed.');
  }
}
