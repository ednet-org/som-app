import 'package:flutter/material.dart';
import 'package:som/ui/components/funny_logo.dart';
import 'package:som/ui/components/layout/MainBody.dart';
import 'package:som/ui/pages/customer/registration/RegistrationStepper.dart';

class CustomerRegisterPage extends StatefulWidget {
  static String tag = '/CustomerRegistrationPage';

  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBody(
        child: Column(
          children: const [
            FunnyLogo(),
            RegistrationStepper(),
          ],
        ),
      ),
    );
  }
}
