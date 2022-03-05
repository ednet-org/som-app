// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_registration_request.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProviderRegistrationRequest on _ProviderRegistrationRequest, Store {
  final _$bankDetailsAtom =
      Atom(name: '_ProviderRegistrationRequest.bankDetails');

  @override
  BankDetails? get bankDetails {
    _$bankDetailsAtom.reportRead();
    return super.bankDetails;
  }

  @override
  set bankDetails(BankDetails? value) {
    _$bankDetailsAtom.reportWrite(value, super.bankDetails, () {
      super.bankDetails = value;
    });
  }

  final _$branchesAtom = Atom(name: '_ProviderRegistrationRequest.branches');

  @override
  ObservableList<Branch> get branches {
    _$branchesAtom.reportRead();
    return super.branches;
  }

  @override
  set branches(ObservableList<Branch> value) {
    _$branchesAtom.reportWrite(value, super.branches, () {
      super.branches = value;
    });
  }

  final _$paymentIntervalAtom =
      Atom(name: '_ProviderRegistrationRequest.paymentInterval');

  @override
  PaymentInterval? get paymentInterval {
    _$paymentIntervalAtom.reportRead();
    return super.paymentInterval;
  }

  @override
  set paymentInterval(PaymentInterval? value) {
    _$paymentIntervalAtom.reportWrite(value, super.paymentInterval, () {
      super.paymentInterval = value;
    });
  }

  final _$subscriptionPlanIdAtom =
      Atom(name: '_ProviderRegistrationRequest.subscriptionPlanId');

  @override
  String? get subscriptionPlanId {
    _$subscriptionPlanIdAtom.reportRead();
    return super.subscriptionPlanId;
  }

  @override
  set subscriptionPlanId(String? value) {
    _$subscriptionPlanIdAtom.reportWrite(value, super.subscriptionPlanId, () {
      super.subscriptionPlanId = value;
    });
  }

  final _$_ProviderRegistrationRequestActionController =
      ActionController(name: '_ProviderRegistrationRequest');

  @override
  void setBankDetails(BankDetails value) {
    final _$actionInfo = _$_ProviderRegistrationRequestActionController
        .startAction(name: '_ProviderRegistrationRequest.setBankDetails');
    try {
      return super.setBankDetails(value);
    } finally {
      _$_ProviderRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addBranch(Branch value) {
    final _$actionInfo = _$_ProviderRegistrationRequestActionController
        .startAction(name: '_ProviderRegistrationRequest.addBranch');
    try {
      return super.addBranch(value);
    } finally {
      _$_ProviderRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPaymentInterval(PaymentInterval value) {
    final _$actionInfo = _$_ProviderRegistrationRequestActionController
        .startAction(name: '_ProviderRegistrationRequest.setPaymentInterval');
    try {
      return super.setPaymentInterval(value);
    } finally {
      _$_ProviderRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSubscriptionPlanId(String value) {
    final _$actionInfo =
        _$_ProviderRegistrationRequestActionController.startAction(
            name: '_ProviderRegistrationRequest.setSubscriptionPlanId');
    try {
      return super.setSubscriptionPlanId(value);
    } finally {
      _$_ProviderRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bankDetails: ${bankDetails},
branches: ${branches},
paymentInterval: ${paymentInterval},
subscriptionPlanId: ${subscriptionPlanId}
    ''';
  }
}
