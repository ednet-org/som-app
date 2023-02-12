import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/auth/auth_forgot_password_page.dart';

class AuthForgotPasswordPageLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('forgot password page'),
        title: 'Forgot Password',
        child: AuthForgotPasswordPage(),
      ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => [
        '/auth/forgot-password',
      ];
}
