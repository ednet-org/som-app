// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegistrationRequest on _RegistrationRequest, Store {
  late final _$isRegisteringAtom = Atom(
    name: '_RegistrationRequest.isRegistering',
    context: context,
  );

  @override
  bool get isRegistering {
    _$isRegisteringAtom.reportRead();
    return super.isRegistering;
  }

  @override
  set isRegistering(bool value) {
    _$isRegisteringAtom.reportWrite(value, super.isRegistering, () {
      super.isRegistering = value;
    });
  }

  late final _$isSuccessAtom = Atom(
    name: '_RegistrationRequest.isSuccess',
    context: context,
  );

  @override
  bool get isSuccess {
    _$isSuccessAtom.reportRead();
    return super.isSuccess;
  }

  @override
  set isSuccess(bool value) {
    _$isSuccessAtom.reportWrite(value, super.isSuccess, () {
      super.isSuccess = value;
    });
  }

  late final _$isFailedRegistrationAtom = Atom(
    name: '_RegistrationRequest.isFailedRegistration',
    context: context,
  );

  @override
  bool get isFailedRegistration {
    _$isFailedRegistrationAtom.reportRead();
    return super.isFailedRegistration;
  }

  @override
  set isFailedRegistration(bool value) {
    _$isFailedRegistrationAtom.reportWrite(
      value,
      super.isFailedRegistration,
      () {
        super.isFailedRegistration = value;
      },
    );
  }

  late final _$errorMessageAtom = Atom(
    name: '_RegistrationRequest.errorMessage',
    context: context,
  );

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$companyAtom = Atom(
    name: '_RegistrationRequest.company',
    context: context,
  );

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

  late final _$registerCustomerAsyncAction = AsyncAction(
    '_RegistrationRequest.registerCustomer',
    context: context,
  );

  @override
  Future<void> registerCustomer() {
    return _$registerCustomerAsyncAction.run(() => super.registerCustomer());
  }

  late final _$_RegistrationRequestActionController = ActionController(
    name: '_RegistrationRequest',
    context: context,
  );

  @override
  void setCompany(Company value) {
    final _$actionInfo = _$_RegistrationRequestActionController.startAction(
      name: '_RegistrationRequest.setCompany',
    );
    try {
      return super.setCompany(value);
    } finally {
      _$_RegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isRegistering: ${isRegistering},
isSuccess: ${isSuccess},
isFailedRegistration: ${isFailedRegistration},
errorMessage: ${errorMessage},
company: ${company}
    ''';
  }
}
