// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Company on _Company, Store {
  Computed<dynamic>? _$isProviderComputed;

  @override
  dynamic get isProvider =>
      (_$isProviderComputed ??= Computed<dynamic>(() => super.isProvider,
              name: '_Company.isProvider'))
          .value;
  Computed<dynamic>? _$isBuyerComputed;

  @override
  dynamic get isBuyer => (_$isBuyerComputed ??=
          Computed<dynamic>(() => super.isBuyer, name: '_Company.isBuyer'))
      .value;
  Computed<dynamic>? _$numberOfAllowedUsersComputed;

  @override
  dynamic get numberOfAllowedUsers => (_$numberOfAllowedUsersComputed ??=
          Computed<dynamic>(() => super.numberOfAllowedUsers,
              name: '_Company.numberOfAllowedUsers'))
      .value;
  Computed<dynamic>? _$canCreateMoreUsersComputed;

  @override
  dynamic get canCreateMoreUsers => (_$canCreateMoreUsersComputed ??=
          Computed<dynamic>(() => super.canCreateMoreUsers,
              name: '_Company.canCreateMoreUsers'))
      .value;

  late final _$uidNrAtom = Atom(name: '_Company.uidNr', context: context);

  @override
  String? get uidNr {
    _$uidNrAtom.reportRead();
    return super.uidNr;
  }

  @override
  set uidNr(String? value) {
    _$uidNrAtom.reportWrite(value, super.uidNr, () {
      super.uidNr = value;
    });
  }

  late final _$registrationNumberAtom =
      Atom(name: '_Company.registrationNumber', context: context);

  @override
  String? get registrationNumber {
    _$registrationNumberAtom.reportRead();
    return super.registrationNumber;
  }

  @override
  set registrationNumber(String? value) {
    _$registrationNumberAtom.reportWrite(value, super.registrationNumber, () {
      super.registrationNumber = value;
    });
  }

  late final _$companySizeAtom =
      Atom(name: '_Company.companySize', context: context);

  @override
  String? get companySize {
    _$companySizeAtom.reportRead();
    return super.companySize;
  }

  @override
  set companySize(String? value) {
    _$companySizeAtom.reportWrite(value, super.companySize, () {
      super.companySize = value;
    });
  }

  late final _$nameAtom = Atom(name: '_Company.name', context: context);

  @override
  String? get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String? value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$phoneNumberAtom =
      Atom(name: '_Company.phoneNumber', context: context);

  @override
  String? get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String? value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  late final _$emailAtom = Atom(name: '_Company.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$urlAtom = Atom(name: '_Company.url', context: context);

  @override
  String? get url {
    _$urlAtom.reportRead();
    return super.url;
  }

  @override
  set url(String? value) {
    _$urlAtom.reportWrite(value, super.url, () {
      super.url = value;
    });
  }

  late final _$addressAtom = Atom(name: '_Company.address', context: context);

  @override
  Address get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(Address value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$roleAtom = Atom(name: '_Company.role', context: context);

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

  late final _$providerDataAtom =
      Atom(name: '_Company.providerData', context: context);

  @override
  ProviderRegistrationRequest get providerData {
    _$providerDataAtom.reportRead();
    return super.providerData;
  }

  @override
  set providerData(ProviderRegistrationRequest value) {
    _$providerDataAtom.reportWrite(value, super.providerData, () {
      super.providerData = value;
    });
  }

  late final _$usersAtom = Atom(name: '_Company.users', context: context);

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

  late final _$adminAtom = Atom(name: '_Company.admin', context: context);

  @override
  RegistrationUser get admin {
    _$adminAtom.reportRead();
    return super.admin;
  }

  @override
  set admin(RegistrationUser value) {
    _$adminAtom.reportWrite(value, super.admin, () {
      super.admin = value;
    });
  }

  late final _$numberOfUsersAtom =
      Atom(name: '_Company.numberOfUsers', context: context);

  @override
  int get numberOfUsers {
    _$numberOfUsersAtom.reportRead();
    return super.numberOfUsers;
  }

  @override
  set numberOfUsers(int value) {
    _$numberOfUsersAtom.reportWrite(value, super.numberOfUsers, () {
      super.numberOfUsers = value;
    });
  }

  late final _$_CompanyActionController =
      ActionController(name: '_Company', context: context);

  @override
  void setAdmin(dynamic value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setAdmin');
    try {
      return super.setAdmin(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increaseNumberOfUsers() {
    final _$actionInfo = _$_CompanyActionController.startAction(
        name: '_Company.increaseNumberOfUsers');
    try {
      return super.increaseNumberOfUsers();
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeUser(dynamic position) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.removeUser');
    try {
      return super.removeUser(position);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRegistrationNumber(String value) {
    final _$actionInfo = _$_CompanyActionController.startAction(
        name: '_Company.setRegistrationNumber');
    try {
      return super.setRegistrationNumber(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompanySize(String value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setCompanySize');
    try {
      return super.setCompanySize(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUidNr(String value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setUidNr');
    try {
      return super.setUidNr(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setName(String value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setName');
    try {
      return super.setName(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhoneNumber(dynamic value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setPhoneNumber');
    try {
      return super.setPhoneNumber(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(dynamic value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUrl(dynamic value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setUrl');
    try {
      return super.setUrl(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(Address value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setAddress');
    try {
      return super.setAddress(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRole(dynamic selectedRole) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setRole');
    try {
      return super.setRole(selectedRole);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderData(ProviderRegistrationRequest value) {
    final _$actionInfo = _$_CompanyActionController.startAction(
        name: '_Company.setProviderData');
    try {
      return super.setProviderData(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void activateBuyer(dynamic selectBuyer) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.activateBuyer');
    try {
      return super.activateBuyer(selectBuyer);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void activateProvider(dynamic selectProvider) {
    final _$actionInfo = _$_CompanyActionController.startAction(
        name: '_Company.activateProvider');
    try {
      return super.activateProvider(selectProvider);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchRole(dynamic selectedRole) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.switchRole');
    try {
      return super.switchRole(selectedRole);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addUser(RegistrationUser value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.addUser');
    try {
      return super.addUser(value);
    } finally {
      _$_CompanyActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
uidNr: ${uidNr},
registrationNumber: ${registrationNumber},
companySize: ${companySize},
name: ${name},
phoneNumber: ${phoneNumber},
email: ${email},
url: ${url},
address: ${address},
role: ${role},
providerData: ${providerData},
users: ${users},
admin: ${admin},
numberOfUsers: ${numberOfUsers},
isProvider: ${isProvider},
isBuyer: ${isBuyer},
numberOfAllowedUsers: ${numberOfAllowedUsers},
canCreateMoreUsers: ${canCreateMoreUsers}
    ''';
  }
}
