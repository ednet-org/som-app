// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_registration_request.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerRegistrationRequest on _CustomerRegistrationRequest, Store {
  Computed<dynamic>? _$isProviderComputed;

  @override
  dynamic get isProvider =>
      (_$isProviderComputed ??= Computed<dynamic>(() => super.isProvider,
              name: '_CustomerRegistrationRequest.isProvider'))
          .value;
  Computed<dynamic>? _$isBuyerComputed;

  @override
  dynamic get isBuyer =>
      (_$isBuyerComputed ??= Computed<dynamic>(() => super.isBuyer,
              name: '_CustomerRegistrationRequest.isBuyer'))
          .value;

  final _$roleAtom = Atom(name: '_CustomerRegistrationRequest.role');

  @override
  Roles get role {
    _$roleAtom.reportRead();
    return super.role;
  }

  @override
  set role(Roles value) {
    _$roleAtom.reportWrite(value, super.role, () {
      super.role = value;
    });
  }

  final _$companyAtom = Atom(name: '_CustomerRegistrationRequest.company');

  @override
  Company? get company {
    _$companyAtom.reportRead();
    return super.company;
  }

  @override
  set company(Company? value) {
    _$companyAtom.reportWrite(value, super.company, () {
      super.company = value;
    });
  }

  final _$usersAtom = Atom(name: '_CustomerRegistrationRequest.users');

  @override
  ObservableList<RegistrationUser> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<RegistrationUser> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$providerDataAtom =
      Atom(name: '_CustomerRegistrationRequest.providerData');

  @override
  ProviderRegistrationRequest? get providerData {
    _$providerDataAtom.reportRead();
    return super.providerData;
  }

  @override
  set providerData(ProviderRegistrationRequest? value) {
    _$providerDataAtom.reportWrite(value, super.providerData, () {
      super.providerData = value;
    });
  }

  final _$_CustomerRegistrationRequestActionController =
      ActionController(name: '_CustomerRegistrationRequest');

  @override
  void selectRole(dynamic selectedRole) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.selectRole');
    try {
      return super.selectRole(selectedRole);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void activateBuyer(dynamic selectBuyer) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.activateBuyer');
    try {
      return super.activateBuyer(selectBuyer);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void activateProvider(dynamic selectProvider) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.activateProvider');
    try {
      return super.activateProvider(selectProvider);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchRole(dynamic selectedRole) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.switchRole');
    try {
      return super.switchRole(selectedRole);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompany(Company value) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.setCompany');
    try {
      return super.setCompany(value);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addUser(RegistrationUser value) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.addUser');
    try {
      return super.addUser(value);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderData(ProviderRegistrationRequest value) {
    final _$actionInfo = _$_CustomerRegistrationRequestActionController
        .startAction(name: '_CustomerRegistrationRequest.setProviderData');
    try {
      return super.setProviderData(value);
    } finally {
      _$_CustomerRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
role: ${role},
company: ${company},
users: ${users},
providerData: ${providerData},
isProvider: ${isProvider},
isBuyer: ${isBuyer}
    ''';
  }
}
