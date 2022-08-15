import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

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

class AuthForgotPasswordPage extends StatelessWidget {
  const AuthForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: 350, child: Text('Forgot Password'));
  }
}
