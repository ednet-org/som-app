import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/auth/auth_confirm-email_page.dart';

class AuthConfirmEmailPageNotifier extends ChangeNotifier
    with RouteInformationSerializable {
  AuthConfirmEmailPageNotifier([String? token, String? email])
      : _token = token,
        _email = email;

  String? _token;
  String? _email;

  set email(String? email) {
    if (email != null) {
      _email = email;
      notifyListeners();
    }
  }

  String? get email => _email;

  String? get token => _token;

  set token(String? token) {
    if (token != null) {
      _token = token;
      notifyListeners();
    }
  }

  @override
  fromRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '/');
    if (uri.pathSegments.isNotEmpty) {
      _token = uri.queryParameters['token'];
      _email = uri.queryParameters['email'];
    }
    return this;
  }

  @override
  RouteInformation toRouteInformation() {
    String uriString = 'auth/confirmEmail';
    if (_token != null) {
      uriString += '?token=$_token';
    }
    if (_email != null) {
      uriString += '&?email=$_email';
    }
    return RouteInformation(location: uriString.isEmpty ? '/' : uriString);
  }

  void updateWith(String token, String email) {
    _token = token;
    _email = email;
    notifyListeners();
  }
}

class AuthConfirmEmailPageLocation
    extends BeamLocation<AuthConfirmEmailPageNotifier> {
  @override
  AuthConfirmEmailPageNotifier createState(RouteInformation routeInformation) =>
      AuthConfirmEmailPageNotifier().fromRouteInformation(routeInformation);

  @override
  void initState() {
    super.initState();
    state.addListener(notifyListeners);
  }

  @override
  void updateState(RouteInformation routeInformation) {
    final data =
        AuthConfirmEmailPageNotifier().fromRouteInformation(routeInformation);
    state.updateWith(data.email, data.token);
  }

  @override
  void disposeState() {
    super.disposeState();
    state.removeListener(notifyListeners);
  }

  @override
  List<Pattern> get pathPatterns => ['/auth/confirmEmail'];

  @override
  List<BeamPage> buildPages(
      BuildContext context, AuthConfirmEmailPageNotifier state) {
    return [
      BeamPage(
        key: ValueKey('confirm-email'),
        title: 'Confirm Email',
        child: AuthConfirmEmailPage(state.token, state.email),
      ),
    ];
  }
}
