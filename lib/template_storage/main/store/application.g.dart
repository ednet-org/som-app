// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Application on _Application, Store {
  Computed<dynamic>? _$isAuthenticatedComputed;

  @override
  dynamic get isAuthenticated => (_$isAuthenticatedComputed ??=
          Computed<dynamic>(() => super.isAuthenticated,
              name: '_Application.isAuthenticated'))
      .value;

  late final _$applicationWidthAtom =
      Atom(name: '_Application.applicationWidth', context: context);

  @override
  double get applicationWidth {
    _$applicationWidthAtom.reportRead();
    return super.applicationWidth;
  }

  @override
  set applicationWidth(double value) {
    _$applicationWidthAtom.reportWrite(value, super.applicationWidth, () {
      super.applicationWidth = value;
    });
  }

  late final _$emailSeedAtom =
      Atom(name: '_Application.emailSeed', context: context);

  @override
  num get emailSeed {
    _$emailSeedAtom.reportRead();
    return super.emailSeed;
  }

  @override
  set emailSeed(num value) {
    _$emailSeedAtom.reportWrite(value, super.emailSeed, () {
      super.emailSeed = value;
    });
  }

  late final _$buttonWidthAtom =
      Atom(name: '_Application.buttonWidth', context: context);

  @override
  double get buttonWidth {
    _$buttonWidthAtom.reportRead();
    return super.buttonWidth;
  }

  @override
  set buttonWidth(double value) {
    _$buttonWidthAtom.reportWrite(value, super.buttonWidth, () {
      super.buttonWidth = value;
    });
  }

  late final _$isDarkModeOnAtom =
      Atom(name: '_Application.isDarkModeOn', context: context);

  @override
  bool get isDarkModeOn {
    _$isDarkModeOnAtom.reportRead();
    return super.isDarkModeOn;
  }

  @override
  set isDarkModeOn(bool value) {
    _$isDarkModeOnAtom.reportWrite(value, super.isDarkModeOn, () {
      super.isDarkModeOn = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_Application.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$selectedDrawerItemAtom =
      Atom(name: '_Application.selectedDrawerItem', context: context);

  @override
  int get selectedDrawerItem {
    _$selectedDrawerItemAtom.reportRead();
    return super.selectedDrawerItem;
  }

  @override
  set selectedDrawerItem(int value) {
    _$selectedDrawerItemAtom.reportWrite(value, super.selectedDrawerItem, () {
      super.selectedDrawerItem = value;
    });
  }

  late final _$authorizationAtom =
      Atom(name: '_Application.authorization', context: context);

  @override
  Authorization? get authorization {
    _$authorizationAtom.reportRead();
    return super.authorization;
  }

  @override
  set authorization(Authorization? value) {
    _$authorizationAtom.reportWrite(value, super.authorization, () {
      super.authorization = value;
    });
  }

  late final _$incEmailSeedAsyncAction =
      AsyncAction('_Application.incEmailSeed', context: context);

  @override
  Future<dynamic> incEmailSeed() {
    return _$incEmailSeedAsyncAction.run(() => super.incEmailSeed());
  }

  late final _$loginAsyncAction =
      AsyncAction('_Application.login', context: context);

  @override
  Future login(Authorization aAuthorization) {
    return _$loginAsyncAction.run(() => super.login(aAuthorization));
  }

  late final _$_ApplicationActionController =
      ActionController(name: '_Application', context: context);

  @override
  void toggleDarkMode() {
    final _$actionInfo = _$_ApplicationActionController.startAction(
        name: '_Application.toggleDarkMode');
    try {
      return super.toggleDarkMode();
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLanguage(String aLanguage) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
        name: '_Application.setLanguage');
    try {
      return super.setLanguage(aLanguage);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDrawerItemIndex(int aIndex) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
        name: '_Application.setDrawerItemIndex');
    try {
      return super.setDrawerItemIndex(aIndex);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic logout() {
    final _$actionInfo =
        _$_ApplicationActionController.startAction(name: '_Application.logout');
    try {
      return super.logout();
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
applicationWidth: ${applicationWidth},
emailSeed: ${emailSeed},
buttonWidth: ${buttonWidth},
isDarkModeOn: ${isDarkModeOn},
selectedLanguage: ${selectedLanguage},
selectedDrawerItem: ${selectedDrawerItem},
authorization: ${authorization},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
