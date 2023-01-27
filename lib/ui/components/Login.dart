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
                displayForgotPassword: true,
                forgotPasswordHandler: () {
                  context.beamTo(AuthForgotPasswordPageLocation());
                },
              ),

              const SizedBox(height: 20),
              emailLoginStore.isLoading
                  ? const CircularProgressIndicator()
                  : ActionButton(
                      onPressed: () {
                        emailLoginStore.login();
                      },
                      textContent: 'Login',
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
                'Don\'t have an account?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 5),
              ActionButton(
                onPressed: () {
                  context.beamToNamed('/customer/register');
                },
                textContent: 'Register',
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: Theme.of(context).colorScheme.onPrimary,
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
          const TextSpan(text: 'Welcome! '),
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
