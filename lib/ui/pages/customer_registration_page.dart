import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/screen/template/DTSignInScreen.dart';
import 'package:som/ui/components/layout/MainBody.dart';
import 'package:som/ui/pages/customer/registration/RegistrationStepper.dart';

class CustomerRegistrationPage extends StatefulWidget {
  static String tag = '/CustomerRegistrationPage';

  @override
  State<CustomerRegistrationPage> createState() =>
      _CustomerRegistrationPageState();
}

class _CustomerRegistrationPageState extends State<CustomerRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBody(
        child: RegistrationStepper(),
        // child: ,
      ),
    );
  }

  previousSolution(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Already Registered?',
            style: boldTextStyle(
              color: appColorPrimary,
            )).center().onTap(() {
          DTSignInScreen().launch(context);
        }),
      ],
    );
  }
}
