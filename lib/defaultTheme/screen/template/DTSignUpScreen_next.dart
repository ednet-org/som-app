import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/som/customer/Registration.dart';
import 'package:som/defaultTheme/screen/template/DTSignInScreen.dart';
import 'package:som/main/utils/AppColors.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../../../main.dart';
import '../app/MainMenu.dart';

class DTSignUpScreen extends StatefulWidget {
  static String tag = '/DTSignUpScreen';

  @override
  DTSignUpScreenState createState() => DTSignUpScreenState();
}

class DTSignUpScreenState extends State<DTSignUpScreen> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context, 'Customer registration'),
      drawer: MainMenu(),
      body: Center(
        child: Container(
          width: dynamicWidth(context),
          child: Form(
            key: formKey,
            autovalidate: autoValidate,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                    /// Remove comment if you want enable validation
                    /* if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        finish(context);
                      } else {
                        autoValidate = true;
                      }
                      setState(() {});*/
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
            ),
          ).center(),
        ),
      ),
    );
  }


}

// Row(children: <Widget>[
//   Expanded(
//     child: new Container(
//         margin:
//             const EdgeInsets.only(left: 10.0, right: 20.0),
//         child: Divider(
//           color: Colors.black,
//           height: 36,
//         )),
//   ),
//   Text("Company details"),
//   Expanded(
//     child: new Container(
//         margin:
//             const EdgeInsets.only(left: 20.0, right: 10.0),
//         child: Divider(
//           color: Colors.black,
//           height: 36,
//         )),
//   ),
// ]),
//
// // Company name
// TextFormField(
//   controller: companyNameCont,
//   style: primaryTextStyle(),
//   decoration: buildInputDecoration('Company name'),
//   keyboardType: TextInputType.text,
//   validator: (s) {
//     if (s!.trim().isEmpty) return errorThisFieldRequired;
//     return null;
//   },
//   onFieldSubmitted: (s) =>
//       FocusScope.of(context).requestFocus(emailFocus),
//   textInputAction: TextInputAction.next,
// ),
// 16.height,
// // E-mail
// TextFormField(
//   controller: emailCont,
//   focusNode: emailFocus,
//   style: primaryTextStyle(),
//   decoration: buildInputDecoration('E-mail'),
//   keyboardType: TextInputType.emailAddress,
//   validator: (s) {
//     if (s!.trim().isEmpty) return errorThisFieldRequired;
//     if (!s.trim().validateEmail()) return 'Email is invalid';
//     return null;
//   },
//   onFieldSubmitted: (s) =>
//       FocusScope.of(context).requestFocus(passFocus),
//   textInputAction: TextInputAction.next,
// ),
// 16.height,
// Row(children: <Widget>[
//   Expanded(
//     child: new Container(
//         margin:
//             const EdgeInsets.only(left: 10.0, right: 20.0),
//         child: Divider(
//           color: Colors.black,
//           height: 36,
//         )),
//   ),
//   Text("Company address"),
//   Expanded(
//     child: new Container(
//         margin:
//             const EdgeInsets.only(left: 20.0, right: 10.0),
//         child: Divider(
//           color: Colors.black,
//           height: 36,
//         )),
//   ),
// ]),
// // City
// TextFormField(
//   decoration: buildInputDecoration('City'),
// ),
// 16.height,
// // Street
// TextFormField(
//   decoration: buildInputDecoration('Street'),
// ),
// 16.height,
// // Number
// TextFormField(
//   decoration: buildInputDecoration('Number'),
// ),
// 16.height,
// // Zip
// TextFormField(
//   decoration: buildInputDecoration('Zip'),
// ),
// 16.height,
// Row(children: <Widget>[
//   Expanded(
//     child: new Container(
//         margin:
//             const EdgeInsets.only(left: 10.0, right: 20.0),
//         child: Divider(
//           color: Colors.black,
//           height: 36,
//         )),
//   ),
//   Text("Users"),
//   Expanded(
//     child: new Container(
//         margin:
//             const EdgeInsets.only(left: 20.0, right: 10.0),
//         child: Divider(
//           color: Colors.black,
//           height: 36,
//         )),
//   ),
// ]),
// // Password
// TextFormField(
//   obscureText: obscureText,
//   focusNode: passFocus,
//   controller: passCont,
//   style: primaryTextStyle(),
//   decoration: buildInputDecoration('Password',
//       suffixIcon: Icon(!obscureText
//           ? Icons.visibility
//           : Icons.visibility_off)
//         ..onTap(() {
//           obscureText = !obscureText;
//           setState(() {});
//         })),
//   validator: (s) {
//     if (s!.trim().isEmpty) return errorThisFieldRequired;
//     return null;
//   },
// ),
// 16.height,
// // Password
// TextFormField(
//   obscureText: obscureText,
//   style: primaryTextStyle(),
//   decoration: buildInputDecoration('Repeat password',
//       suffixIcon: Icon(!obscureText
//           ? Icons.visibility
//           : Icons.visibility_off)
//         ..onTap(() {
//           obscureText = !obscureText;
//           setState(() {});
//         })),
//   validator: (s) {
//     if (s!.trim().isEmpty) return errorThisFieldRequired;
//     return null;
//   },
// ),
