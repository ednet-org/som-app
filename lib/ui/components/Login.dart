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

  Login({this.showWelcomeMessage = true});
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
          SizedBox(height: 8),
          Text(
            static["link.forgottenPassword"] ?? "",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
          ),
          SizedBox(
            height: 100,
          ),
          ActionButton(
            onPressed: () {
              CustomerRegistrationPage().launch(context);
            },
            textContent: static["signUp"],
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
          )
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
  "welcome":
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
  "username": "E-mail",
  "password": "Password",
  "button.login": "Sign In",
  "link.forgottenPassword": "Forgotten password?",
  "signUp": " Not having account ? Sign Up here",
};
