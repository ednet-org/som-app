// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Company on _Company, Store {
  final _$uidNrAtom = Atom(name: '_Company.uidNr');

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

  final _$registrationNumberAtom = Atom(name: '_Company.registrationNumber');

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

  final _$companySizeAtom = Atom(name: '_Company.companySize');

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

  final _$nameAtom = Atom(name: '_Company.name');

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

  final _$addressAtom = Atom(name: '_Company.address');

  @override
  Address? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(Address? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  final _$websiteUrlAtom = Atom(name: '_Company.websiteUrl');

  @override
  String? get websiteUrl {
    _$websiteUrlAtom.reportRead();
    return super.websiteUrl;
  }

  @override
  set websiteUrl(String? value) {
    _$websiteUrlAtom.reportWrite(value, super.websiteUrl, () {
      super.websiteUrl = value;
    });
  }

  final _$_CompanyActionController = ActionController(name: '_Company');

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
  void setWebsiteUrl(String value) {
    final _$actionInfo =
        _$_CompanyActionController.startAction(name: '_Company.setWebsiteUrl');
    try {
      return super.setWebsiteUrl(value);
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
address: ${address},
websiteUrl: ${websiteUrl}
    ''';
  }
}
