import 'package:flutter/material.dart';

import 'RoleSelection.dart';

class CCustomerRegistration extends StatefulWidget {
  Roles selectedRole = Roles.Buyer;

  @override
  createState() => CCustomerRegistrationState();
}

enum Roles {
  Buyer,
  Provider,
}

class CCustomerRegistrationState extends State<CCustomerRegistration> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CRoleSelection(widget.selectedRole),
        CRegistrationForm(widget.selectedRole),
      ],
    );
  }
}

class CRegistrationForm extends StatefulWidget {
  Roles selectedRole = Roles.Buyer;

  CRegistrationForm(selectedRole);

  @override
  State<CRegistrationForm> createState() => CRegistrationFormState();
}

class CRegistrationFormState extends State<CRegistrationForm> {
  Widget build(BuildContext context) {
    return widget.selectedRole == Roles.Buyer ? buyerForm() : providerForm();
  }

  providerForm() {
    return Text('provider');
  }

  buyerForm() {
    return Text('buyer');
  }
}
