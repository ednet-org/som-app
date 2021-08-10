import 'package:flutter/material.dart';

import 'RoleSelection.dart';
import 'Roles.dart';

class CCustomerRegistration extends StatefulWidget {
  @override
  createState() => CCustomerRegistrationState();
}


class CCustomerRegistrationState extends State<CCustomerRegistration> {
  Roles selectedRole = Roles.Buyer;

  void selectRole(Roles role) {
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
    return this.selectedRole == Roles.Buyer ? buyerForm() : providerForm();
  }

  providerForm() {
    return Text('provider');
  }

  buyerForm() {
    return Text('buyer or not');
  }
}
