import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/user_account_confirmation/user_account_confirmation.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/forms/som_text_input.dart';

class ConfirmEmailPage extends StatefulWidget {
  static String tag = '/ConfirmEmailPage';

  final String? email;
  final String? token;

  ConfirmEmailPage(this.token, this.email);

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    confirmEmail();
  }

  void confirmEmail() async {
    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    final userAccountConfirmation =
        Provider.of<UserAccountConfirmation>(context, listen: false);
    userAccountConfirmation.token = widget.token!;
    userAccountConfirmation.email = widget.email!;
    if (userAccountConfirmation.isConfirmed ||
        userAccountConfirmation.isConfirming) {
      return;
    } else {
      await userAccountConfirmation.confirmEmail();
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
        body: Center(
          child: userAccountConfirmation.isConfirmed
              ? Column(
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
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                    SizedBox(width: 10),
                    SizedBox(height: 100),
                    Text('Please set your password',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
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
                            userAccountConfirmation.setUserPassword();
                          }),
                    ),
                    SizedBox(height: 100),
                    Container(
                        width: 350, child: Text(userAccountConfirmation.token)),
                    Container(
                        width: 350, child: Text(userAccountConfirmation.email)),
                  ],
                )
              : userAccountConfirmation.isConfirming
                  ? CircularProgressIndicator(
                      semanticsLabel: 'Confirming E-mail',
                    )
                  : Text('Please confirm your email'),
        ),
      ),
    );
  }
}
