import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/auth_forgot_password_page_state.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/forms/som_text_input.dart';
import 'package:som/ui/components/funny_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authForgotPasswordState =
        Provider.of<AuthForgotPasswordPageState>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      body: Observer(
        builder: (_) => Center(
          child: Container(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FunnyLogo(
                  onPrimary: Theme.of(context).colorScheme.error,
                  primary: Theme.of(context).colorScheme.errorContainer,
                ),
                SizedBox(
                  height: 50,
                ),
                authForgotPasswordState.isSendingEmailLink
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator(
                            semanticsLabel: 'Link is sending',
                          ),
                        ],
                      )
                    : !authForgotPasswordState.isLinkSent
                        ? Column(children: [
                            Text('Forgotten Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer,
                                    )),
                            Text(
                                'Please enter your e-mail to receive instructions to reset password.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer,
                                    )),
                            SomTextInput(
                              primary: Theme.of(context).colorScheme.onError,
                              onPrimary: Theme.of(context).colorScheme.error,
                              label: 'Email',
                              value: authForgotPasswordState.email,
                              required: true,
                              icon: Icons.email_outlined,
                              onChanged: (value) =>
                                  authForgotPasswordState.setEmail(value),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ActionButton(
                              onPrimary:
                                  Theme.of(context).colorScheme.errorContainer,
                              primary: Theme.of(context).colorScheme.error,
                              textContent: 'Send reset link',
                              onPressed: () {
                                authForgotPasswordState.sendResetLink();
                              },
                            ),
                          ])
                        : Container(),
                SizedBox(
                  height: 50,
                ),
                authForgotPasswordState.isLinkSent
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text('Link is sent',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onErrorContainer)),
                              SizedBox(width: 10),
                              Icon(
                                Icons.check_circle_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 50,
                              ),
                            ],
                          ),
                          ActionButton(
                            onPrimary:
                                Theme.of(context).colorScheme.errorContainer,
                            primary: Theme.of(context).colorScheme.error,
                            textContent: 'Open link in browser',
                            onPressed: () async {
                              final uri =
                                  Uri.parse(authForgotPasswordState.url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                throw 'Could not launch ${authForgotPasswordState.url}';
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 200,
                ),
                authForgotPasswordState.errorMessage.isNotEmpty
                    ? Text(
                        authForgotPasswordState.errorMessage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
