// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Address on _Address, Store {
  final _$countryAtom = Atom(name: '_Address.country');

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

  final _$cityAtom = Atom(name: '_Address.city');

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

  final _$streetAtom = Atom(name: '_Address.street');

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

  final _$numberAtom = Atom(name: '_Address.number');

  @override
  String? get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(String? value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  final _$zipAtom = Atom(name: '_Address.zip');

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

  final _$_AddressActionController = ActionController(name: '_Address');

  @override
  void setCountry(String value) {
    final _$actionInfo =
        _$_AddressActionController.startAction(name: '_Address.setCountry');
    try {
      return super.setCountry(value);
    } finally {
      _$_AddressActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCity(String value) {
    final _$actionInfo =
        _$_AddressActionController.startAction(name: '_Address.setCity');
    try {
      return super.setCity(value);
    } finally {
      _$_AddressActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStreet(String value) {
    final _$actionInfo =
        _$_AddressActionController.startAction(name: '_Address.setStreet');
    try {
      return super.setStreet(value);
    } finally {
      _$_AddressActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNumber(String value) {
    final _$actionInfo =
        _$_AddressActionController.startAction(name: '_Address.setNumber');
    try {
      return super.setNumber(value);
    } finally {
      _$_AddressActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZip(String value) {
    final _$actionInfo =
        _$_AddressActionController.startAction(name: '_Address.setZip');
    try {
      return super.setZip(value);
    } finally {
      _$_AddressActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
country: ${country},
city: ${city},
street: ${street},
number: ${number},
zip: ${zip}
    ''';
  }
}
