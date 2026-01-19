import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/auth/auth_confirm_email_page.dart';

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
  AuthConfirmEmailPageNotifier fromRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = routeInformation.uri;
    if (uri.pathSegments.isNotEmpty) {
      _token = uri.queryParameters['token'];
      _email = uri.queryParameters['email'];
    }
    return this;
  }

  @override
  RouteInformation toRouteInformation() {
    final params = <String, String>{};
    if (_token != null) {
      params['token'] = _token!;
    }
    if (_email != null) {
      params['email'] = _email!;
    }
    final uri = Uri(
      path: '/auth/confirmEmail',
      queryParameters: params.isEmpty ? null : params,
    );
    return RouteInformation(uri: uri);
  }

  void updateWith(String? token, String? email) {
    if (token != null) {
      _token = token;
    }
    if (email != null) {
      _email = email;
    }
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
    state.updateWith(data.token, data.email);
  }

  @override
  void disposeState() {
    super.disposeState();
    state.removeListener(notifyListeners);
  }

  @override
  List<Pattern> get pathPatterns =>
      ['/auth/confirmEmail', '/auth/confirmEmail/error'];

  @override
  List<BeamPage> buildPages(
      BuildContext context, AuthConfirmEmailPageNotifier state) {
    final hasError = state.routeInformation.uri.path.contains('error');
    return [
      BeamPage(
        key: const ValueKey('confirm-email'),
        title: 'Confirm Email',
        child: AuthConfirmEmailPage(state.token, state.email),
      ),
      if (hasError)
        const BeamPage(
          key: ValueKey('confirm-email-error'),
          title: 'Confirm Email Error',
          child: Text('Error'),
        ),
    ];
  }
}
