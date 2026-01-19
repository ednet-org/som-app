import 'package:flutter/material.dart';
import 'package:som/ui/domain/model/funny_logo.dart';
import 'package:som/ui/pages/customer/registration/registration_stepper.dart';

import '../../domain/model/layout/main_body.dart';

class CustomerRegisterPage extends StatefulWidget {
  static String tag = '/CustomerRegistrationPage';

  const CustomerRegisterPage({super.key});

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBody(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const FunnyLogo(),
            const RegistrationStepper(),
          ],
        ),
      ),
    );
  }
}
