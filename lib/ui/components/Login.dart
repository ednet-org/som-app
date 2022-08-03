import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/utils/EditText.dart';
import 'package:som/ui/pages/customer_registration_page.dart';
import 'package:som/ui/pages/dashboard_page.dart';
import 'package:som/ui/utils/AppConstant.dart';
import 'package:som/ui/utils/auto_size_text/auto_size_text.dart';

import '../../../main.dart';

class Login extends StatefulWidget {
  static String tag = '/Loginx';
  bool showWelcomeMessage;

  @override
  LoginState createState() => LoginState();

  Login({this.showWelcomeMessage = false});
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(Theme.of(context).colorScheme.primary);
    return Container(
      margin: EdgeInsets.only(left: spacing_large, right: spacing_large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: spacing_large),
          if (widget.showWelcomeMessage) welcomeMessage(),
          loginForm(),
          SizedBox(
            height: 100,
          ),
          SizedBox(height: spacing_large),
        ],
      ),
    );
  }

  loginForm() {
    return Container(
      width: 300,
      child: Column(
        children: [
          EditText(
            text: static["username"],
            isPassword: false,
          ),
          SizedBox(height: spacing_standard_new),
          EditText(
            text: static["password"],
            isSecure: true,
          ),
          SizedBox(height: spacing_xlarge),
          ActionButton(
            onPressed: () {
              appStore.login();
              DashboardPage().launch(context, isNewTask: true);
            },
            textContent: static["button.login"],
          ),
          SizedBox(height: 8),
          Text(
            static["link.forgottenPassword"] ?? "",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
          ),
          SizedBox(height: 60),
          ActionButton(
            onPressed: () {
              CustomerRegistrationPage().launch(context);
            },
            textContent: static["signUp"],
            primary: Theme.of(context).colorScheme.secondary,
            onPrimary: Theme.of(context).colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }

  welcomeMessage() {
    return Column(
      children: [
        AutoSizeText.rich(
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          TextSpan(text: static["welcome"]),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
          // TODO impl read more able components
        ),
        SizedBox(height: spacing_large),
      ],
    );
  }
}

void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}

const static = {
  "welcome": "Existing user:",
  "username": "E-mail",
  "password": "Password",
  "button.login": "Sign In",
  "link.forgottenPassword": "Forgotten password?",
  "signUp": " Not having account ? Sign Up here",
};
