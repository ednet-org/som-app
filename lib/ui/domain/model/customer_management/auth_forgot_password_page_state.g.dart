// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_forgot_password_page_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthForgotPasswordPageState on _AuthForgotPasswordPageState, Store {
  late final _$emailAtom = Atom(
    name: '_AuthForgotPasswordPageState.email',
    context: context,
  );

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$urlAtom = Atom(
    name: '_AuthForgotPasswordPageState.url',
    context: context,
  );

  @override
  String get url {
    _$urlAtom.reportRead();
    return super.url;
  }

  @override
  set url(String value) {
    _$urlAtom.reportWrite(value, super.url, () {
      super.url = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AuthForgotPasswordPageState.errorMessage',
    context: context,
  );

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$isSendingEmailLinkAtom = Atom(
    name: '_AuthForgotPasswordPageState.isSendingEmailLink',
    context: context,
  );

  @override
  bool get isSendingEmailLink {
    _$isSendingEmailLinkAtom.reportRead();
    return super.isSendingEmailLink;
  }

  @override
  set isSendingEmailLink(bool value) {
    _$isSendingEmailLinkAtom.reportWrite(value, super.isSendingEmailLink, () {
      super.isSendingEmailLink = value;
    });
  }

  late final _$isLinkSentAtom = Atom(
    name: '_AuthForgotPasswordPageState.isLinkSent',
    context: context,
  );

  @override
  bool get isLinkSent {
    _$isLinkSentAtom.reportRead();
    return super.isLinkSent;
  }

  @override
  set isLinkSent(bool value) {
    _$isLinkSentAtom.reportWrite(value, super.isLinkSent, () {
      super.isLinkSent = value;
    });
  }

  late final _$sendResetLinkAsyncAction = AsyncAction(
    '_AuthForgotPasswordPageState.sendResetLink',
    context: context,
  );

  @override
  Future<void> sendResetLink() {
    return _$sendResetLinkAsyncAction.run(() => super.sendResetLink());
  }

  late final _$_AuthForgotPasswordPageStateActionController = ActionController(
    name: '_AuthForgotPasswordPageState',
    context: context,
  );

  @override
  void setEmail(String email) {
    final _$actionInfo = _$_AuthForgotPasswordPageStateActionController
        .startAction(name: '_AuthForgotPasswordPageState.setEmail');
    try {
      return super.setEmail(email);
    } finally {
      _$_AuthForgotPasswordPageStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
url: ${url},
errorMessage: ${errorMessage},
isSendingEmailLink: ${isSendingEmailLink},
isLinkSent: ${isLinkSent}
    ''';
  }
}
