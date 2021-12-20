import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/screen/template/DTSignInScreen.dart';
import 'package:som/ui/pages/customer/registration/Registration.dart';

class CustomerRegistrationPage extends StatelessWidget {
  static String tag = '/CustomerRegistrationPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Registration(),
            20.height,
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  color: appColorPrimary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: defaultBoxShadow()),
              child: Text('Register',
                  style: boldTextStyle(color: white, size: 18)),
            ).onTap(() {
              finish(context);
            }),
            20.height,
            Text('Already Registered?',
                style: boldTextStyle(
                  color: appColorPrimary,
                )).center().onTap(() {
              DTSignInScreen().launch(context);
            }),
          ],
        ),
      ).center(),
    );
  }
}
