import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/integrations/utils/constants.dart';

import 'Login.dart';

class LoginOrRegister extends StatefulWidget {
  static String tag = '/DTLogin';

  @override
  LoginOrRegisterState createState() => LoginOrRegisterState();
}

class LoginOrRegisterState extends State<LoginOrRegister> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();
  var passCont = TextEditingController();
  var companyNameCont = TextEditingController();

  var emailFocus = FocusNode();
  var passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    print('ouuuuuuuut');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: spacing_large),
              Container(
                alignment: Alignment.center,
                child: Image.asset('images/som/logo.png',
                    height: 150, fit: BoxFit.fitHeight),
              ),
              Text('Smart offer management'.toUpperCase(),
                      style: primaryTextStyle(size: textSizeLarge.toInt()))
                  .paddingOnly(left: 8, top: 20, right: 8, bottom: 20),
              Container(
                width: 800,
                child: Column(children: [
                  Login(),
                ]),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
