import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/login/email_login_store.dart';
import 'package:som/routes/locations/auth/auth_forgot_password_page_location.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/forms/som_text_input.dart';
import 'package:som/ui/utils/AppConstant.dart';
import 'package:som/ui/utils/auto_size_text/auto_size_text.dart';

class Login extends StatelessWidget {
  static String tag = '/Login';

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailLoginStore = Provider.of<EmailLoginStore>(context);
    // final BeamerProvidedKey beamer = Provider.of<BeamerProvidedKey>(context);

    changeStatusColor(Theme.of(context).colorScheme.primaryContainer);
    return SizedBox(
      width: 350,
      child: Observer(
        builder: (_) {
          return Column(
            children: [
              SomTextInput(
                label: 'Username',
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
              const SizedBox(height: 50),
              emailLoginStore.isLoading
                  ? const CircularProgressIndicator()
                  : ActionButton(
                      onPressed: () {
                        emailLoginStore.login();
                      },
                      textContent: static["button.login"]!,
                    ),
              emailLoginStore.isInvalidCredentials
                  ? Text(
                      emailLoginStore.errorMessage,
                      // style: Theme.of(context)
                      //     .textTheme
                      //     .titleSmall
                      //     ?.copyWith(color: Theme.of(context).colorScheme.error),
                    )
                  : Container(),
              const SizedBox(height: 30),
              Text(
                static["link.forgottenPassword"] ?? "",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 5),
              ActionButton(
                onPressed: () {
                  context.beamTo(AuthForgotPasswordPageLocation());
                },
                textContent: static["reset.password"]!,
                // primary: Theme.of(context).colorScheme.secondary,
                // onPrimary: Theme.of(context).colorScheme.onSecondary,
              ),
              const SizedBox(height: 30),
              Text(
                static["no.account"] ?? "",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 5),
              ActionButton(
                onPressed: () {
                  context.beamToNamed('/customer/register');
                },
                textContent: static["signUp"]!,
                // primary: Theme.of(context).colorScheme.tertiary,
                // onPrimary: Theme.of(context).colorScheme.onTertiary,
              ),
              const SizedBox(height: 5),
              ActionButton(
                onPressed: () {
                  context.beamToNamed('/sdfsdf/dsfsdf');
                },
                textContent: "NotFouund",
                // primary: Theme.of(context).colorScheme.tertiary,
                // onPrimary: Theme.of(context).colorScheme.onTertiary,
              ),

              ReactionBuilder(
                child: Container(),
                builder: (context) =>
                    reaction((_) => emailLoginStore.isLoggedIn, (result) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(emailLoginStore.loggingInMessage),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'ACTION',
                      onPressed: () {},
                    ),
                  ));
                }),
              ),

              // SizedBox(height: 50),
              // ActionButton(
              //   onPressed: () {
              //     context.beamToNamed(
              //         '/auth/confirmEmail?token=${token}&email=${email}');
              //   },
              //   textContent: "Verify E-mail",
              //   primary: Theme.of(context).colorScheme.tertiary,
              //   onPrimary: Theme.of(context).colorScheme.onTertiary,
              // ),
            ],
          );
        },
      ),
    );
  }

  welcomeMessage(context) {
    return Column(
      children: [
        AutoSizeText.rich(
          style: Theme.of(context).textTheme.bodyMedium,
          // ?.copyWith(color: Theme.of(context).colorScheme.primary),
          TextSpan(text: static["welcome"]),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
          // TODO impl read more able components
        ),
        const SizedBox(height: spacing_large),
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
