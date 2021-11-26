import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/app/DashboardScreen.dart';
import 'package:som/defaultTheme/utils/EditText.dart';
import 'package:som/integrations/utils/constants.dart';
import 'package:som/main/utils/AppWidget.dart';
import 'package:som/main/utils/auto_size_text/auto_size_text.dart';

import '../../../../main.dart';

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
    changeStatusColor(appStore.appBarColor!);
    return Container(
      color: context.scaffoldBackgroundColor,
      margin: EdgeInsets.only(left: spacing_large, right: spacing_large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: spacing_large),
          if (widget.showWelcomeMessage) welcomeMessage(),
          loginForm(),
          SizedBox(height: spacing_large),
          text(static["link.forgottenPassword"],
              textColor: Colors.amber, fontFamily: fontMedium),
          SizedBox(
            width: spacing_control,
          ),
          AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(text: static["text.notRegistered"]),
              TextSpan(text: static["link.notRegistered"])
            ]),
            maxLines: 3,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.caption?.copyWith(
                color: Colors.amber, fontSize: 15, fontFamily: fontMedium),
            // TODO impl read more able components
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
          AppButtons(
            onPressed: () {
              appStore.login();
              DashboardScreen().launch(context, isNewTask: true);
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

const static = {
  "welcome":
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
  "username": "User name",
  "password": "Password",
  "button.login": "Login",
  "link.forgottenPassword": "Forgotten password?",
  "text.notRegistered": "If you don't have account",
  "link.notRegistered": " register here please, easy and quickly, smart way :)",
};
