import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../components/low/buttons/action_button.dart';
import '../../components/low/forms/som_text_input.dart';
import '../../domain/app_config/application.dart';
import '../../domain/user_account_confirmation/user_account_confirmation.dart';
import '../../routes/routes.dart';

class AuthConfirmEmailPage extends StatefulWidget {
  static String tag = '/ConfirmEmailPage';

  final String? email;
  final String? token;

  const AuthConfirmEmailPage(this.token, this.email, {Key? key})
      : super(key: key);

  @override
  State<AuthConfirmEmailPage> createState() => _AuthConfirmEmailPageState();
}

class _AuthConfirmEmailPageState extends State<AuthConfirmEmailPage>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    final userAccountConfirmation =
        Provider.of<UserAccountConfirmation>(context);

    final appStore = Provider.of<Application>(context);

    if (appStore.isAuthenticated) {
      context.beamTo(SmartOfferManagementPageLocation());
    }

    userAccountConfirmation.token = widget.token!;
    userAccountConfirmation.email = widget.email!;
    if (userAccountConfirmation.isConfirmed ||
        userAccountConfirmation.isConfirming) {
      super.didChangeDependencies();
      return;
    } else {
      userAccountConfirmation.confirmEmail();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userAccountConfirmation =
        Provider.of<UserAccountConfirmation>(context);
    return Observer(
      builder: (
        context,
      ) =>
          Scaffold(
        body: Column(
          children: [
            userAccountConfirmation.errorMessage.isNotEmpty
                ? Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                            padding: const EdgeInsets.all(30.0),
                            width: 350,
                            child: Text(
                              userAccountConfirmation.errorMessage,
                              style: Theme.of(context).textTheme.bodySmall,
                            )),
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: Center(
                child: userAccountConfirmation.isConfirmed
                    ? buildSetPassword(context, userAccountConfirmation)
                    : userAccountConfirmation.isConfirming
                        ? const CircularProgressIndicator(
                            semanticsLabel: 'Confirming E-mail',
                          )
                        : userAccountConfirmation.isLoggingIn
                            ? const CircularProgressIndicator(
                                semanticsLabel: 'Logging in',
                              )
                            : SizedBox(
                                width: 350,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text('Missing data!'),
                                      const SizedBox(height: 20),
                                      ActionButton(
                                        textContent: 'Back',
                                        onPressed: () => context
                                            .beamTo(AuthLoginPageLocation()),
                                      )
                                    ],
                                  ),
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSetPassword(
      BuildContext context, UserAccountConfirmation userAccountConfirmation) {
    return Observer(
      builder: (
        _,
      ) =>
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text('Your email has been verified',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(width: 10),
          const SizedBox(height: 100),
          Text('Please set your password',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          SizedBox(
            width: 350,
            child: SomTextInput(
              onChanged: userAccountConfirmation.setPassword,
              label: 'Password',
              isPassword: true,
            ),
          ),
          SizedBox(
            width: 350,
            child: SomTextInput(
              onChanged: userAccountConfirmation.setRepeatedPassword,
              label: 'Repeat password',
              hint: 'Please repeat your password',
              isPassword: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 350,
            child: ActionButton(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              textContent: 'Set password',
              onPressed: () {
                userAccountConfirmation.setUserPassword(() {
                  context.beamTo(SmartOfferManagementPageLocation());
                });
              },
            ),
          ),
          const SizedBox(height: 100),
          SizedBox(width: 350, child: Text(userAccountConfirmation.token)),
          SizedBox(width: 350, child: Text(userAccountConfirmation.email)),
        ],
      ),
    );
  }
}
