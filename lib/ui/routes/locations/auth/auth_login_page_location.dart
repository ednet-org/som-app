import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/auth/auth_login_page.dart';

class AuthLoginPageLocation extends BeamLocation<BeamState> {
  static String tag = 'AuthLoginPage';

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('login page'),
        title: 'Login',
        child: AuthLoginPage(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/auth/login'];
}
