// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegistrationUser on _RegistrationUser, Store {
  Computed<dynamic>? _$hasAcceptedTermsAndPoliciesComputed;

  @override
  dynamic get hasAcceptedTermsAndPolicies =>
      (_$hasAcceptedTermsAndPoliciesComputed ??= Computed<dynamic>(
              () => super.hasAcceptedTermsAndPolicies,
              name: '_RegistrationUser.hasAcceptedTermsAndPolicies'))
          .value;

  late final _$firstNameAtom =
      Atom(name: '_RegistrationUser.firstName', context: context);

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

  late final _$lastNameAtom =
      Atom(name: '_RegistrationUser.lastName', context: context);

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

  late final _$emailAtom =
      Atom(name: '_RegistrationUser.email', context: context);

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

  late final _$titleAtom =
      Atom(name: '_RegistrationUser.title', context: context);

  @override
  String? get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String? value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$phoneAtom =
      Atom(name: '_RegistrationUser.phone', context: context);

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

  late final _$salutationAtom =
      Atom(name: '_RegistrationUser.salutation', context: context);

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

  late final _$termsAtom =
      Atom(name: '_RegistrationUser.terms', context: context);

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

  late final _$policiesAtom =
      Atom(name: '_RegistrationUser.policies', context: context);

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

  late final _$roleAtom =
      Atom(name: '_RegistrationUser.role', context: context);

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

  late final _$_RegistrationUserActionController =
      ActionController(name: '_RegistrationUser', context: context);

  @override
  void setSalutation(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setSalutation');
    try {
      return super.setSalutation(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolicies(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setPolicies');
    try {
      return super.setPolicies(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTerms(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setTerms');
    try {
      return super.setTerms(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFirstName(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setFirstName');
    try {
      return super.setFirstName(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastName(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setLastName');
    try {
      return super.setLastName(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitle(String value) {
    final _$actionInfo = _$_RegistrationUserActionController.startAction(
        name: '_RegistrationUser.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$_RegistrationUserActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
firstName: ${firstName},
lastName: ${lastName},
email: ${email},
title: ${title},
phone: ${phone},
salutation: ${salutation},
terms: ${terms},
policies: ${policies},
role: ${role},
hasAcceptedTermsAndPolicies: ${hasAcceptedTermsAndPolicies}
    ''';
  }
}
