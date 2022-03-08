// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_registration_request.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerRegistrationRequest on _CustomerRegistrationRequest, Store {
  final _$companyAtom = Atom(name: '_CustomerRegistrationRequest.company');

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

  final _$_CustomerRegistrationRequestActionController =
      ActionController(name: '_CustomerRegistrationRequest');

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
  String toString() {
    return '''
company: ${company}
    ''';
  }
}
