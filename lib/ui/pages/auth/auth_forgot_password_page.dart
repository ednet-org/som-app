import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../domain/model/model.dart';

class AuthForgotPasswordPage extends StatelessWidget {
  const AuthForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authForgotPasswordState =
        Provider.of<AuthForgotPasswordPageState>(context);
    return Scaffold(
      body: Observer(
        builder: (_) => Center(
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FunnyLogo(),
                const SizedBox(
                  height: 50,
                ),
                authForgotPasswordState.isSendingEmailLink
                    ? Column(
                        children: const [
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
                            Text(
                              'Forgotten Password?',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              'Please enter your e-mail to receive instructions to reset password.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SomTextInput(
                              label: 'Email',
                              value: authForgotPasswordState.email,
                              required: true,
                              iconAsset: SomAssets.iconUser,
                              onChanged: (value) =>
                                  authForgotPasswordState.setEmail(value),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ActionButton(
                              primary: Theme.of(context).colorScheme.secondary,
                              onPrimary:
                                  Theme.of(context).colorScheme.onSecondary,
                              textContent: 'Send reset link',
                              onPressed: () {
                                authForgotPasswordState.sendResetLink();
                              },
                            ),
                          ])
                        : Container(),
                const SizedBox(
                  height: 50,
                ),
                authForgotPasswordState.isLinkSent
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Link is sent',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer),
                              ),
                              const SizedBox(width: 10),
                              SomSvgIcon(
                                SomAssets.offerStatusAccepted,
                                size: 50,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          if (authForgotPasswordState.url.isNotEmpty)
                            ActionButton(
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
                authForgotPasswordState.errorMessage.isNotEmpty
                    ? Text(
                        authForgotPasswordState.errorMessage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            // color: Theme.of(context)
                            //     .colorScheme
                            //     .onErrorContainer,
                            ),
                      )
                    : Container(),
                ActionButton(
                  width: 300.0,
                  // onPrimary: Theme.of(context).colorScheme.error,
                  // primary: Theme.of(context).colorScheme.errorContainer,
                  textContent: "Home",
                  onPressed: () => context.beamToNamed('/'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
