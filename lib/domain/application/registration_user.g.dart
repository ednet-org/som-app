// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegistrationUser on RegistrationUserBase, Store {
  Computed<dynamic>? _$hasAcceptedTermsAndPoliciesComputed;

  @override
  dynamic get hasAcceptedTermsAndPolicies =>
      (_$hasAcceptedTermsAndPoliciesComputed ??= Computed<dynamic>(
              () => super.hasAcceptedTermsAndPolicies,
              name: 'RegistrationUserBase.hasAcceptedTermsAndPolicies'))
          .value;

  final _$firstNameAtom = Atom(name: 'RegistrationUserBase.firstName');

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

  final _$lastNameAtom = Atom(name: 'RegistrationUserBase.lastName');

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

  final _$emailAtom = Atom(name: 'RegistrationUserBase.email');

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

  final _$phoneAtom = Atom(name: 'RegistrationUserBase.phone');

  @override
  String? get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String? value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$salutationAtom = Atom(name: 'RegistrationUserBase.salutation');

  @override
  String? get salutation {
    _$salutationAtom.reportRead();
    return super.salutation;
  }

  @override
  set salutation(String? value) {
    _$salutationAtom.reportWrite(value, super.salutation, () {
      super.salutation = value;
    });
  }

  final _$termsAtom = Atom(name: 'RegistrationUserBase.terms');

  @override
  String? get terms {
    _$termsAtom.reportRead();
    return super.terms;
  }

  @override
  set terms(String? value) {
    _$termsAtom.reportWrite(value, super.terms, () {
      super.terms = value;
    });
  }

  final _$policiesAtom = Atom(name: 'RegistrationUserBase.policies');

  @override
  String? get policies {
    _$policiesAtom.reportRead();
    return super.policies;
  }

  @override
  set policies(String? value) {
    _$policiesAtom.reportWrite(value, super.policies, () {
      super.policies = value;
    });
  }

  final _$roleAtom = Atom(name: 'RegistrationUserBase.role');

  @override
  CompanyRole get role {
    _$roleAtom.reportRead();
    return super.role;
  }

  @override
  set role(CompanyRole value) {
    _$roleAtom.reportWrite(value, super.role, () {
      super.role = value;
    });
  }

  final _$RegistrationUserBaseActionController =
      ActionController(name: 'RegistrationUserBase');

  @override
  void setSalutation(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setSalutation');
    try {
      return super.setSalutation(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolicies(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setPolicies');
    try {
      return super.setPolicies(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTerms(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setTerms');
    try {
      return super.setTerms(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFirstName(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setFirstName');
    try {
      return super.setFirstName(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastName(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setLastName');
    try {
      return super.setLastName(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$RegistrationUserBaseActionController.startAction(
        name: 'RegistrationUserBase.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$RegistrationUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
firstName: ${firstName},
lastName: ${lastName},
email: ${email},
phone: ${phone},
salutation: ${salutation},
terms: ${terms},
policies: ${policies},
role: ${role},
hasAcceptedTermsAndPolicies: ${hasAcceptedTermsAndPolicies}
    ''';
  }
}
