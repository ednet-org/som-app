// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer-store.dart';

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
  String toString() {
    return '''
uuid: ${uuid},
firstName: ${firstName},
lastName: ${lastName},
email: ${email},
role: ${role},
fullName: ${fullName},
isProvider: ${isProvider},
isBuyer: ${isBuyer}
    ''';
  }
}
