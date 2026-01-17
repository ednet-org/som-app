// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Application on _Application, Store {
  Computed<bool>? _$isDarkModeOnComputed;

  @override
  bool get isDarkModeOn => (_$isDarkModeOnComputed ??= Computed<bool>(
    () => super.isDarkModeOn,
    name: '_Application.isDarkModeOn',
  )).value;
  Computed<VisualDensity>? _$visualDensityComputed;

  @override
  VisualDensity get visualDensity =>
      (_$visualDensityComputed ??= Computed<VisualDensity>(
        () => super.visualDensity,
        name: '_Application.visualDensity',
      )).value;
  Computed<dynamic>? _$isAuthenticatedComputed;

  @override
  dynamic get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<dynamic>(
        () => super.isAuthenticated,
        name: '_Application.isAuthenticated',
      )).value;
  Computed<CurrentLayoutAndUIConstraints>? _$layoutComputed;

  @override
  CurrentLayoutAndUIConstraints get layout =>
      (_$layoutComputed ??= Computed<CurrentLayoutAndUIConstraints>(
        () => super.layout,
        name: '_Application.layout',
      )).value;

  late final _$applicationWidthAtom = Atom(
    name: '_Application.applicationWidth',
    context: context,
  );

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

  late final _$buttonWidthAtom = Atom(
    name: '_Application.buttonWidth',
    context: context,
  );

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

  late final _$textScaleFactorAtom = Atom(
    name: '_Application.textScaleFactor',
    context: context,
  );

  @override
  double get textScaleFactor {
    _$textScaleFactorAtom.reportRead();
    return super.textScaleFactor;
  }

  @override
  set textScaleFactor(double value) {
    _$textScaleFactorAtom.reportWrite(value, super.textScaleFactor, () {
      super.textScaleFactor = value;
    });
  }

  late final _$themeModeAtom = Atom(
    name: '_Application.themeMode',
    context: context,
  );

  @override
  ThemeMode get themeMode {
    _$themeModeAtom.reportRead();
    return super.themeMode;
  }

  @override
  set themeMode(ThemeMode value) {
    _$themeModeAtom.reportWrite(value, super.themeMode, () {
      super.themeMode = value;
    });
  }

  late final _$densityAtom = Atom(
    name: '_Application.density',
    context: context,
  );

  @override
  UiDensity get density {
    _$densityAtom.reportRead();
    return super.density;
  }

  @override
  set density(UiDensity value) {
    _$densityAtom.reportWrite(value, super.density, () {
      super.density = value;
    });
  }

  late final _$selectedLanguageAtom = Atom(
    name: '_Application.selectedLanguage',
    context: context,
  );

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

  late final _$selectedDrawerItemAtom = Atom(
    name: '_Application.selectedDrawerItem',
    context: context,
  );

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

  late final _$authorizationAtom = Atom(
    name: '_Application.authorization',
    context: context,
  );

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

  late final _$boxConstraintsAtom = Atom(
    name: '_Application.boxConstraints',
    context: context,
  );

  @override
  BoxConstraints? get boxConstraints {
    _$boxConstraintsAtom.reportRead();
    return super.boxConstraints;
  }

  @override
  set boxConstraints(BoxConstraints? value) {
    _$boxConstraintsAtom.reportWrite(value, super.boxConstraints, () {
      super.boxConstraints = value;
    });
  }

  late final _$loadPreferencesAsyncAction = AsyncAction(
    '_Application.loadPreferences',
    context: context,
  );

  @override
  Future<void> loadPreferences() {
    return _$loadPreferencesAsyncAction.run(() => super.loadPreferences());
  }

  late final _$loginAsyncAction = AsyncAction(
    '_Application.login',
    context: context,
  );

  @override
  Future login(Authorization aAuthorization) {
    return _$loginAsyncAction.run(() => super.login(aAuthorization));
  }

  late final _$_ApplicationActionController = ActionController(
    name: '_Application',
    context: context,
  );

  @override
  void setTextScaleFactor(double value) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.setTextScaleFactor',
    );
    try {
      return super.setTextScaleFactor(value);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setThemeMode(ThemeMode mode) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.setThemeMode',
    );
    try {
      return super.setThemeMode(mode);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDensity(UiDensity value) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.setDensity',
    );
    try {
      return super.setDensity(value);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDarkMode() {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.toggleDarkMode',
    );
    try {
      return super.toggleDarkMode();
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cycleThemeMode() {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.cycleThemeMode',
    );
    try {
      return super.cycleThemeMode();
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLanguage(String aLanguage) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.setLanguage',
    );
    try {
      return super.setLanguage(aLanguage);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDrawerItemIndex(int aIndex) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.setDrawerItemIndex',
    );
    try {
      return super.setDrawerItemIndex(aIndex);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic logout() {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.logout',
    );
    try {
      return super.logout();
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setActiveRole(String role) {
    final _$actionInfo = _$_ApplicationActionController.startAction(
      name: '_Application.setActiveRole',
    );
    try {
      return super.setActiveRole(role);
    } finally {
      _$_ApplicationActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
applicationWidth: ${applicationWidth},
buttonWidth: ${buttonWidth},
textScaleFactor: ${textScaleFactor},
themeMode: ${themeMode},
density: ${density},
selectedLanguage: ${selectedLanguage},
selectedDrawerItem: ${selectedDrawerItem},
authorization: ${authorization},
boxConstraints: ${boxConstraints},
isDarkModeOn: ${isDarkModeOn},
visualDensity: ${visualDensity},
isAuthenticated: ${isAuthenticated},
layout: ${layout}
    ''';
  }
}
