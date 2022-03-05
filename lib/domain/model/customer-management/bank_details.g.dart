// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BankDetails on _BankDetails, Store {
  final _$ibanAtom = Atom(name: '_BankDetails.iban');

  @override
  String? get iban {
    _$ibanAtom.reportRead();
    return super.iban;
  }

  @override
  set iban(String? value) {
    _$ibanAtom.reportWrite(value, super.iban, () {
      super.iban = value;
    });
  }

  final _$bicAtom = Atom(name: '_BankDetails.bic');

  @override
  String? get bic {
    _$bicAtom.reportRead();
    return super.bic;
  }

  @override
  set bic(String? value) {
    _$bicAtom.reportWrite(value, super.bic, () {
      super.bic = value;
    });
  }

  final _$accountOwnerAtom = Atom(name: '_BankDetails.accountOwner');

  @override
  String? get accountOwner {
    _$accountOwnerAtom.reportRead();
    return super.accountOwner;
  }

  @override
  set accountOwner(String? value) {
    _$accountOwnerAtom.reportWrite(value, super.accountOwner, () {
      super.accountOwner = value;
    });
  }

  final _$_BankDetailsActionController = ActionController(name: '_BankDetails');

  @override
  void setIban(String value) {
    final _$actionInfo = _$_BankDetailsActionController.startAction(
        name: '_BankDetails.setIban');
    try {
      return super.setIban(value);
    } finally {
      _$_BankDetailsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBic(String value) {
    final _$actionInfo =
        _$_BankDetailsActionController.startAction(name: '_BankDetails.setBic');
    try {
      return super.setBic(value);
    } finally {
      _$_BankDetailsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAccountOwner(String value) {
    final _$actionInfo = _$_BankDetailsActionController.startAction(
        name: '_BankDetails.setAccountOwner');
    try {
      return super.setAccountOwner(value);
    } finally {
      _$_BankDetailsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
iban: ${iban},
bic: ${bic},
accountOwner: ${accountOwner}
    ''';
  }
}
