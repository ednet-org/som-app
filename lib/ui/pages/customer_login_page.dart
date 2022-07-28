import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/integrations/utils/constants.dart';

import '../components/Login.dart';

class CustomerLoginPage extends StatefulWidget {
  static String tag = '/DTLogin';

  @override
  CustomerLoginPageState createState() => CustomerLoginPageState();
}

class CustomerLoginPageState extends State<CustomerLoginPage> {
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: spacing_large),
              Container(
                alignment: Alignment.center,
                child: Image.asset('images/som/logo.png',
                    height: 150, fit: BoxFit.fitHeight),
              ),
              Text('Smart offer management'.toUpperCase(),
                      style: Theme.of(context).textTheme.displayMedium)
                  .paddingOnly(left: 8, top: 20, right: 8, bottom: 20),
              SizedBox(
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
