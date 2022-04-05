import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/MainBody.dart';
import 'package:som/ui/pages/customer/registration/RegistrationStepper.dart';

class CustomerRegistrationPage extends StatefulWidget {
  static String tag = '/CustomerRegistrationPage';

  const CustomerRegistrationPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegistrationPage> createState() =>
      _CustomerRegistrationPageState();
}

class _CustomerRegistrationPageState extends State<CustomerRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBody(
        child: Column(
          children: [
            RegistrationStepper(),
          ],
        ),
        // child: ,
      ),
    );
  }
}
