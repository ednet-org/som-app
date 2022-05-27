// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegistrationUser on _RegistrationUser, Store {
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

  late final _$_RegistrationUserActionController =
      ActionController(name: '_RegistrationUser', context: context);

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
  String toString() {
    return '''
email: ${email},
salutation: ${salutation}
    ''';
  }
}
