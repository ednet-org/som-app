import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/utils/EditText.dart';
import 'package:som/integrations/utils/constants.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../../../main.dart';

class Login extends StatefulWidget {
  static String tag = '/Loginx';

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    return Container(
      height: MediaQuery.of(context).size.height,
      color: context.scaffoldBackgroundColor,
      margin: EdgeInsets.only(left: spacing_large, right: spacing_large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          text('dobro doslo',
              textColor: appStore.textPrimaryColor,
              fontFamily: fontBold,
              fontSize: textSizeXLarge),
          SizedBox(height: spacing_large),
          EditText(
            text: 'username',
            isPassword: false,
          ),
          SizedBox(height: spacing_standard_new),
          EditText(
            text: 'theme10_password',
            isSecure: true,
          ),
          SizedBox(height: spacing_xlarge),
          AppButtons(
            onPressed: () {},
            textContent: 'theme10_lbl_sign_in',
          ),
          SizedBox(height: spacing_large),
          text('theme10_lbl_forget_pswd',
              textColor: Colors.amber, fontFamily: fontMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              text('theme10_lbl_dont_have_account',
                  textColor: Colors.amber, fontFamily: fontMedium),
              SizedBox(
                width: spacing_control,
              ),
              text('theme10_lbl_sign_up', fontFamily: fontMedium),
            ],
          )
        ],
      ),
    );
  }
}

void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}

// ignore: must_be_immutable
class AppButtons extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  AppButtons({required this.textContent, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return AppButtonsState();
  }
}

class AppButtonsState extends State<AppButtons> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: Colors.white),
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
      ),
      onPressed: widget.onPressed,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blueAccent, Colors.lightBlueAccent]),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              widget.textContent,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
