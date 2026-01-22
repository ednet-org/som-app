// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_confirmation.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserAccountConfirmation on _UserAccountConfirmationBase, Store {
  late final _$tokenAtom = Atom(
    name: '_UserAccountConfirmationBase.token',
    context: context,
  );

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$resetPasswordTokenAtom = Atom(
    name: '_UserAccountConfirmationBase.resetPasswordToken',
    context: context,
  );

  @override
  String get resetPasswordToken {
    _$resetPasswordTokenAtom.reportRead();
    return super.resetPasswordToken;
  }

  @override
  set resetPasswordToken(String value) {
    _$resetPasswordTokenAtom.reportWrite(value, super.resetPasswordToken, () {
      super.resetPasswordToken = value;
    });
  }

  late final _$emailAtom = Atom(
    name: '_UserAccountConfirmationBase.email',
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

  late final _$isConfirmingAtom = Atom(
    name: '_UserAccountConfirmationBase.isConfirming',
    context: context,
  );

  @override
  bool get isConfirming {
    _$isConfirmingAtom.reportRead();
    return super.isConfirming;
  }

  @override
  set isConfirming(bool value) {
    _$isConfirmingAtom.reportWrite(value, super.isConfirming, () {
      super.isConfirming = value;
    });
  }

  late final _$isLoggingInAtom = Atom(
    name: '_UserAccountConfirmationBase.isLoggingIn',
    context: context,
  );

  @override
  bool get isLoggingIn {
    _$isLoggingInAtom.reportRead();
    return super.isLoggingIn;
  }

  @override
  set isLoggingIn(bool value) {
    _$isLoggingInAtom.reportWrite(value, super.isLoggingIn, () {
      super.isLoggingIn = value;
    });
  }

  late final _$isConfirmedAtom = Atom(
    name: '_UserAccountConfirmationBase.isConfirmed',
    context: context,
  );

  @override
  bool get isConfirmed {
    _$isConfirmedAtom.reportRead();
    return super.isConfirmed;
  }

  @override
  set isConfirmed(bool value) {
    _$isConfirmedAtom.reportWrite(value, super.isConfirmed, () {
      super.isConfirmed = value;
    });
  }

  late final _$isSettingPasswordAtom = Atom(
    name: '_UserAccountConfirmationBase.isSettingPassword',
    context: context,
  );

  @override
  bool get isSettingPassword {
    _$isSettingPasswordAtom.reportRead();
    return super.isSettingPassword;
  }

  @override
  set isSettingPassword(bool value) {
    _$isSettingPasswordAtom.reportWrite(value, super.isSettingPassword, () {
      super.isSettingPassword = value;
    });
  }

  late final _$isPasswordSetAtom = Atom(
    name: '_UserAccountConfirmationBase.isPasswordSet',
    context: context,
  );

  @override
  bool get isPasswordSet {
    _$isPasswordSetAtom.reportRead();
    return super.isPasswordSet;
  }

  @override
  set isPasswordSet(bool value) {
    _$isPasswordSetAtom.reportWrite(value, super.isPasswordSet, () {
      super.isPasswordSet = value;
    });
  }

  late final _$passwordAtom = Atom(
    name: '_UserAccountConfirmationBase.password',
    context: context,
  );

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_UserAccountConfirmationBase.errorMessage',
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

  late final _$repeatedPasswordAtom = Atom(
    name: '_UserAccountConfirmationBase.repeatedPassword',
    context: context,
  );

  @override
  String get repeatedPassword {
    _$repeatedPasswordAtom.reportRead();
    return super.repeatedPassword;
  }

  @override
  set repeatedPassword(String value) {
    _$repeatedPasswordAtom.reportWrite(value, super.repeatedPassword, () {
      super.repeatedPassword = value;
    });
  }

  late final _$setUserPasswordAsyncAction = AsyncAction(
    '_UserAccountConfirmationBase.setUserPassword',
    context: context,
  );

  @override
  Future<void> setUserPassword(VoidCallback contextCallback) {
    return _$setUserPasswordAsyncAction.run(
      () => super.setUserPassword(contextCallback),
    );
  }

  late final _$confirmEmailAsyncAction = AsyncAction(
    '_UserAccountConfirmationBase.confirmEmail',
    context: context,
  );

  @override
  Future<void> confirmEmail() {
    return _$confirmEmailAsyncAction.run(() => super.confirmEmail());
  }

  late final _$_UserAccountConfirmationBaseActionController = ActionController(
    name: '_UserAccountConfirmationBase',
    context: context,
  );

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_UserAccountConfirmationBaseActionController
        .startAction(name: '_UserAccountConfirmationBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_UserAccountConfirmationBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRepeatedPassword(String value) {
    final _$actionInfo = _$_UserAccountConfirmationBaseActionController
        .startAction(name: '_UserAccountConfirmationBase.setRepeatedPassword');
    try {
      return super.setRepeatedPassword(value);
    } finally {
      _$_UserAccountConfirmationBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
token: ${token},
resetPasswordToken: ${resetPasswordToken},
email: ${email},
isConfirming: ${isConfirming},
isLoggingIn: ${isLoggingIn},
isConfirmed: ${isConfirmed},
isSettingPassword: ${isSettingPassword},
isPasswordSet: ${isPasswordSet},
password: ${password},
errorMessage: ${errorMessage},
repeatedPassword: ${repeatedPassword}
    ''';
  }
}
