// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegistrationRequest on _RegistrationRequest, Store {
  late final _$companyAtom =
      Atom(name: '_RegistrationRequest.company', context: context);

  @override
  Company get company {
    _$companyAtom.reportRead();
    return super.company;
  }

  @override
  set company(Company value) {
    _$companyAtom.reportWrite(value, super.company, () {
      super.company = value;
    });
  }

  late final _$_RegistrationRequestActionController =
      ActionController(name: '_RegistrationRequest', context: context);

  @override
  void setCompany(Company value) {
    final _$actionInfo = _$_RegistrationRequestActionController.startAction(
        name: '_RegistrationRequest.setCompany');
    try {
      return super.setCompany(value);
    } finally {
      _$_RegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void registerCustomer() {
    final _$actionInfo = _$_RegistrationRequestActionController.startAction(
        name: '_RegistrationRequest.registerCustomer');
    try {
      return super.registerCustomer();
    } finally {
      _$_RegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
company: ${company}
    ''';
  }
}
