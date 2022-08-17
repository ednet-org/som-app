import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/user_account_confirmation/user_account_confirmation.dart';
import 'package:som/routes/locations/auth/auth_login_page_location.dart';
import 'package:som/routes/locations/authenticated/smart_offer_management_page_location.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/forms/som_text_input.dart';

class AuthConfirmEmailPage extends StatefulWidget {
  static String tag = '/ConfirmEmailPage';

  final String? email;
  final String? token;

  AuthConfirmEmailPage(this.token, this.email);

  @override
  State<AuthConfirmEmailPage> createState() => _AuthConfirmEmailPageState();
}

class _AuthConfirmEmailPageState extends State<AuthConfirmEmailPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    confirmEmail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void confirmEmail() async {
    // return context.beamTo(SplashPageBeamLocation());
    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    final userAccountConfirmation =
        Provider.of<UserAccountConfirmation>(context, listen: false);

    final appStore = Provider.of<Application>(context, listen: false);

    if (appStore.isAuthenticated) {
      context.beamTo(SmartOfferManagementPageLocation());
    }

    userAccountConfirmation.token = widget.token!;
    userAccountConfirmation.email = widget.email!;
    if (userAccountConfirmation.isConfirmed ||
        userAccountConfirmation.isConfirming) {
      return;
    } else {
      userAccountConfirmation.confirmEmail();
    }
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Column(
          children: [
            Center(
              child: userAccountConfirmation.isConfirmed
                  ? buildSetPassword(context, userAccountConfirmation)
                  : userAccountConfirmation.isConfirming
                      ? CircularProgressIndicator(
                          semanticsLabel: 'Confirming E-mail',
                        )
                      : userAccountConfirmation.isLoggingIn
                          ? CircularProgressIndicator(
                              semanticsLabel: 'Logging in',
                            )
                          : Container(
                              width: 350,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20),
                                    Text('Missing data!'),
                                    SizedBox(height: 20),
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                    color: Theme.of(context).colorScheme.error,
                    width: 350,
                    child: userAccountConfirmation.errorMessage.isEmpty
                        ? Text(userAccountConfirmation.errorMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onError))
                        : Container()),
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
          SizedBox(width: 10),
          SizedBox(height: 100),
          Text('Please set your password',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          Container(
            width: 350,
            child: SomTextInput(
              onChanged: userAccountConfirmation.setPassword,
              label: 'Password',
              isPassword: true,
            ),
          ),
          Container(
            width: 350,
            child: SomTextInput(
              onChanged: userAccountConfirmation.setRepeatedPassword,
              label: 'Repeat password',
              hint: 'Please repeat your password',
              isPassword: true,
            ),
          ),
          SizedBox(height: 20),
          Container(
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
          SizedBox(height: 100),
          Container(width: 350, child: Text(userAccountConfirmation.token)),
          Container(width: 350, child: Text(userAccountConfirmation.email)),
        ],
      ),
    );
  }
}
