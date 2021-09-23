import 'package:flutter/material.dart';

import '../../../domain/model/customer-management/roles.dart';
import 'RoleSelection.dart';

class Registration extends StatefulWidget {
  @override
  createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
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
        RoleSelection(selectRole, selectedRole),
        RegistrationForm(selectedRole),
      ],
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final Roles selectedRole;

  RegistrationForm(this.selectedRole);

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
