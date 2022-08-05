// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EmailLoginStore on _EmailLoginStoreBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_EmailLoginStoreBase.isFormValid'))
          .value;

  late final _$showWelcomeMessageAtom =
      Atom(name: '_EmailLoginStoreBase.showWelcomeMessage', context: context);

  @override
  bool get showWelcomeMessage {
    _$showWelcomeMessageAtom.reportRead();
    return super.showWelcomeMessage;
  }

  @override
  set showWelcomeMessage(bool value) {
    _$showWelcomeMessageAtom.reportWrite(value, super.showWelcomeMessage, () {
      super.showWelcomeMessage = value;
    });
  }

  late final _$isInvalidCredentialsAtom =
      Atom(name: '_EmailLoginStoreBase.isInvalidCredentials', context: context);

  @override
  bool get isInvalidCredentials {
    _$isInvalidCredentialsAtom.reportRead();
    return super.isInvalidCredentials;
  }

  @override
  set isInvalidCredentials(bool value) {
    _$isInvalidCredentialsAtom.reportWrite(value, super.isInvalidCredentials,
        () {
      super.isInvalidCredentials = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_EmailLoginStoreBase.errorMessage', context: context);

  @override
  Object? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(Object? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$welcomeMessageAtom =
      Atom(name: '_EmailLoginStoreBase.welcomeMessage', context: context);

  @override
  String get welcomeMessage {
    _$welcomeMessageAtom.reportRead();
    return super.welcomeMessage;
  }

  @override
  set welcomeMessage(String value) {
    _$welcomeMessageAtom.reportWrite(value, super.welcomeMessage, () {
      super.welcomeMessage = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_EmailLoginStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_EmailLoginStoreBase.email', context: context);

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

  late final _$passwordAtom =
      Atom(name: '_EmailLoginStoreBase.password', context: context);

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

  late final _$showPasswordAtom =
      Atom(name: '_EmailLoginStoreBase.showPassword', context: context);

  @override
  bool get showPassword {
    _$showPasswordAtom.reportRead();
    return super.showPassword;
  }

  @override
  set showPassword(bool value) {
    _$showPasswordAtom.reportWrite(value, super.showPassword, () {
      super.showPassword = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_EmailLoginStoreBase.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('_EmailLoginStoreBase.login', context: context);

  @override
  Future<dynamic> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$_EmailLoginStoreBaseActionController =
      ActionController(name: '_EmailLoginStoreBase', context: context);

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_EmailLoginStoreBaseActionController.startAction(
        name: '_EmailLoginStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_EmailLoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_EmailLoginStoreBaseActionController.startAction(
        name: '_EmailLoginStoreBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_EmailLoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleShowPassword() {
    final _$actionInfo = _$_EmailLoginStoreBaseActionController.startAction(
        name: '_EmailLoginStoreBase.toggleShowPassword');
    try {
      return super.toggleShowPassword();
    } finally {
      _$_EmailLoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loggout() {
    final _$actionInfo = _$_EmailLoginStoreBaseActionController.startAction(
        name: '_EmailLoginStoreBase.loggout');
    try {
      return super.loggout();
    } finally {
      _$_EmailLoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showWelcomeMessage: ${showWelcomeMessage},
isInvalidCredentials: ${isInvalidCredentials},
errorMessage: ${errorMessage},
welcomeMessage: ${welcomeMessage},
isLoading: ${isLoading},
email: ${email},
password: ${password},
showPassword: ${showPassword},
isLoggedIn: ${isLoggedIn},
isFormValid: ${isFormValid}
    ''';
  }
}
