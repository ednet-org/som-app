import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/login/email_login_store.dart';
import 'package:som/routes/beamer_provided_key.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/forms/som_text_input.dart';
import 'package:som/ui/utils/AppConstant.dart';
import 'package:som/ui/utils/auto_size_text/auto_size_text.dart';

class Login extends StatefulWidget {
  static String tag = '/Loginx';

  @override
  LoginState createState() => LoginState();

  Login();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final emailLoginStore = Provider.of<EmailLoginStore>(context);
    final BeamerProvidedKey beamer = Provider.of<BeamerProvidedKey>(context);

    changeStatusColor(Theme.of(context).colorScheme.primaryContainer);
    return Container(
      margin: EdgeInsets.only(left: spacing_large, right: spacing_large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: spacing_large),
          if (emailLoginStore.showWelcomeMessage) welcomeMessage(),
          loginForm(emailLoginStore, beamer),
          SizedBox(
            height: 100,
          ),
          SizedBox(height: spacing_large),
        ],
      ),
    );
  }

  loginForm(emailLoginStore, BeamerProvidedKey beamer) {
    final token =
        'CfDJ8J2Uib2U17tAiY%2FLxD0rccZMwUrnU%2BYkeJWbIBuB7DUTAZulRirWGloNQDeGvZBMHpGW0Tdrhd0fNXN8HZmNvfihB9NrvY4w4Q70%2FJKTGrGSJsL47yyJmrTEQbNp0ytkpyQMMMu2FoOCCgYaRacHbX9pHVjWXvC4JG2mvjw%2BPUMKG%2F2ScaXwSg%2F5zbKRbnAq689zliNSIuHbcyq3vsQhYJrw%2FOgNUGAx5C1e3M94aIr37AC4VjxkqQdCr1HmLXQmIw%3D%3D';

    final email = 'slavisam@gmail.com';

    return Observer(
      builder: (_) => Container(
        width: 300,
        child: Column(
          children: [
            SomTextInput(
              label: 'User name',
              icon: Icons.email_outlined,
              hint: 'usually your email',
              value: emailLoginStore.email,
              onChanged: emailLoginStore.setEmail,
              required: true,
            ),
            SomTextInput(
              label: 'Password',
              icon: Icons.password_outlined,
              hint: 'usually your cat name',
              value: emailLoginStore.password,
              onChanged: emailLoginStore.setPassword,
              required: true,
              showPassword: emailLoginStore.showPassword,
              onToggleShowPassword: emailLoginStore.toggleShowPassword,
              isPassword: true,
              autocorrect: false,
            ),
            SizedBox(height: 50),
            emailLoginStore.isLoading
                ? CircularProgressIndicator()
                : ActionButton(
                    onPressed: () {
                      emailLoginStore.login();
                    },
                    textContent: static["button.login"],
                  ),
            emailLoginStore.isInvalidCredentials
                ? Text(
                    emailLoginStore.errorMessage,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  )
                : Container(),
            SizedBox(height: 30),
            Text(
              static["link.forgottenPassword"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 5),
            ActionButton(
              onPressed: () {
                context.beamToNamed('/customer/forgotten-password');
              },
              textContent: static["reset.password"],
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Theme.of(context).colorScheme.onSecondary,
            ),
            SizedBox(height: 30),
            Text(
              static["no.account"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 5),
            ActionButton(
              onPressed: () {
                context.beamToNamed('/customer/register');
              },
              textContent: static["signUp"],
              primary: Theme.of(context).colorScheme.tertiary,
              onPrimary: Theme.of(context).colorScheme.onTertiary,
            ),
            SizedBox(height: 50),
            ActionButton(
              onPressed: () {
                context.beamToNamed(
                    '/auth/confirmEmail?token=${token}&email=${email}');
              },
              textContent: "Verify E-mail",
              primary: Theme.of(context).colorScheme.tertiary,
              onPrimary: Theme.of(context).colorScheme.onTertiary,
            ),
          ],
        ),
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
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
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
  "email": "E-mail",
  "password": "Password",
  "button.login": "Sign In",
  "link.forgottenPassword": "Forgotten password?",
  "no.account": "Not having account? ",
  "signUp": "Register here",
  "reset.password": "Reset password",
};
