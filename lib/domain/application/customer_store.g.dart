// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerStore on CustomerStoreBase, Store {
  Computed<String>? _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName,
              name: 'CustomerStoreBase.fullName'))
          .value;
  Computed<dynamic>? _$isProviderComputed;

  @override
  dynamic get isProvider =>
      (_$isProviderComputed ??= Computed<dynamic>(() => super.isProvider,
              name: 'CustomerStoreBase.isProvider'))
          .value;
  Computed<dynamic>? _$isBuyerComputed;

  @override
  dynamic get isBuyer =>
      (_$isBuyerComputed ??= Computed<dynamic>(() => super.isBuyer,
              name: 'CustomerStoreBase.isBuyer'))
          .value;

  final _$uuidAtom = Atom(name: 'CustomerStoreBase.uuid');

  @override
  String get uuid {
    _$uuidAtom.reportRead();
    return super.uuid;
  }

  @override
  set uuid(String value) {
    _$uuidAtom.reportWrite(value, super.uuid, () {
      super.uuid = value;
    });
  }

  final _$firstNameAtom = Atom(name: 'CustomerStoreBase.firstName');

  @override
  String? get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(String? value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  final _$lastNameAtom = Atom(name: 'CustomerStoreBase.lastName');

  @override
  String? get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(String? value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  final _$roleAtom = Atom(name: 'CustomerStoreBase.role');

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

  final _$companyNameAtom = Atom(name: 'CustomerStoreBase.companyName');

  @override
  String? get companyName {
    _$companyNameAtom.reportRead();
    return super.companyName;
  }

  @override
  set companyName(String? value) {
    _$companyNameAtom.reportWrite(value, super.companyName, () {
      super.companyName = value;
    });
  }

  final _$uidNumberAtom = Atom(name: 'CustomerStoreBase.uidNumber');

  @override
  String? get uidNumber {
    _$uidNumberAtom.reportRead();
    return super.uidNumber;
  }

  @override
  set uidNumber(String? value) {
    _$uidNumberAtom.reportWrite(value, super.uidNumber, () {
      super.uidNumber = value;
    });
  }

  final _$registrationNumberAtom =
      Atom(name: 'CustomerStoreBase.registrationNumber');

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

  final _$phoneNumberAtom = Atom(name: 'CustomerStoreBase.phoneNumber');

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

  final _$emailAtom = Atom(name: 'CustomerStoreBase.email');

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

  final _$companyUrlAtom = Atom(name: 'CustomerStoreBase.companyUrl');

  @override
  String? get companyUrl {
    _$companyUrlAtom.reportRead();
    return super.companyUrl;
  }

  @override
  set companyUrl(String? value) {
    _$companyUrlAtom.reportWrite(value, super.companyUrl, () {
      super.companyUrl = value;
    });
  }

  final _$countryAtom = Atom(name: 'CustomerStoreBase.country');

  @override
  String? get country {
    _$countryAtom.reportRead();
    return super.country;
  }

  @override
  set country(String? value) {
    _$countryAtom.reportWrite(value, super.country, () {
      super.country = value;
    });
  }

  final _$zipAtom = Atom(name: 'CustomerStoreBase.zip');

  @override
  String? get zip {
    _$zipAtom.reportRead();
    return super.zip;
  }

  @override
  set zip(String? value) {
    _$zipAtom.reportWrite(value, super.zip, () {
      super.zip = value;
    });
  }

  final _$cityAtom = Atom(name: 'CustomerStoreBase.city');

  @override
  String? get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(String? value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  final _$streetAtom = Atom(name: 'CustomerStoreBase.street');

  @override
  String? get street {
    _$streetAtom.reportRead();
    return super.street;
  }

  @override
  set street(String? value) {
    _$streetAtom.reportWrite(value, super.street, () {
      super.street = value;
    });
  }

  final _$streetNumberAtom = Atom(name: 'CustomerStoreBase.streetNumber');

  @override
  String? get streetNumber {
    _$streetNumberAtom.reportRead();
    return super.streetNumber;
  }

  @override
  set streetNumber(String? value) {
    _$streetNumberAtom.reportWrite(value, super.streetNumber, () {
      super.streetNumber = value;
    });
  }

  final _$CustomerStoreBaseActionController =
      ActionController(name: 'CustomerStoreBase');

  @override
  void selectRole(dynamic selectedRole) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.selectRole');
    try {
      return super.selectRole(selectedRole);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBuyer(dynamic selectBuyer) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setBuyer');
    try {
      return super.setBuyer(selectBuyer);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProvider(dynamic selectProvider) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setProvider');
    try {
      return super.setProvider(selectProvider);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchRole(dynamic selectedRole) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.switchRole');
    try {
      return super.switchRole(selectedRole);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompanyName(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setCompanyName');
    try {
      return super.setCompanyName(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUidNumber(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setUidNumber');
    try {
      return super.setUidNumber(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRegistrationNumber(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setRegistrationNumber');
    try {
      return super.setRegistrationNumber(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhoneNumber(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setPhoneNumber');
    try {
      return super.setPhoneNumber(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompanyUrl(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setCompanyUrl');
    try {
      return super.setCompanyUrl(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCountry(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setCountry');
    try {
      return super.setCountry(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZip(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setZip');
    try {
      return super.setZip(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCity(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setCity');
    try {
      return super.setCity(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStreet(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setStreet');
    try {
      return super.setStreet(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStreetNumber(dynamic value) {
    final _$actionInfo = _$CustomerStoreBaseActionController.startAction(
        name: 'CustomerStoreBase.setStreetNumber');
    try {
      return super.setStreetNumber(value);
    } finally {
      _$CustomerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
uuid: ${uuid},
firstName: ${firstName},
lastName: ${lastName},
role: ${role},
companyName: ${companyName},
uidNumber: ${uidNumber},
registrationNumber: ${registrationNumber},
phoneNumber: ${phoneNumber},
email: ${email},
companyUrl: ${companyUrl},
country: ${country},
zip: ${zip},
city: ${city},
street: ${street},
streetNumber: ${streetNumber},
fullName: ${fullName},
isProvider: ${isProvider},
isBuyer: ${isBuyer}
    ''';
  }
}
