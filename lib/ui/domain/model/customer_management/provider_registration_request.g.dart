// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_registration_request.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProviderRegistrationRequest on _ProviderRegistrationRequest, Store {
  late final _$bankDetailsAtom = Atom(
    name: '_ProviderRegistrationRequest.bankDetails',
    context: context,
  );

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

  late final _$branchesAtom = Atom(
    name: '_ProviderRegistrationRequest.branches',
    context: context,
  );

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

  late final _$paymentIntervalAtom = Atom(
    name: '_ProviderRegistrationRequest.paymentInterval',
    context: context,
  );

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

  late final _$subscriptionPlanIdAtom = Atom(
    name: '_ProviderRegistrationRequest.subscriptionPlanId',
    context: context,
  );

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

  late final _$maxUsersAtom = Atom(
    name: '_ProviderRegistrationRequest.maxUsers',
    context: context,
  );

  @override
  int? get maxUsers {
    _$maxUsersAtom.reportRead();
    return super.maxUsers;
  }

  @override
  set maxUsers(int? value) {
    _$maxUsersAtom.reportWrite(value, super.maxUsers, () {
      super.maxUsers = value;
    });
  }

  late final _$providerTypeAtom = Atom(
    name: '_ProviderRegistrationRequest.providerType',
    context: context,
  );

  @override
  String? get providerType {
    _$providerTypeAtom.reportRead();
    return super.providerType;
  }

  @override
  set providerType(String? value) {
    _$providerTypeAtom.reportWrite(value, super.providerType, () {
      super.providerType = value;
    });
  }

  late final _$_ProviderRegistrationRequestActionController = ActionController(
    name: '_ProviderRegistrationRequest',
    context: context,
  );

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
    final _$actionInfo = _$_ProviderRegistrationRequestActionController
        .startAction(
          name: '_ProviderRegistrationRequest.setSubscriptionPlanId',
        );
    try {
      return super.setSubscriptionPlanId(value);
    } finally {
      _$_ProviderRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMaxUsers(int? value) {
    final _$actionInfo = _$_ProviderRegistrationRequestActionController
        .startAction(name: '_ProviderRegistrationRequest.setMaxUsers');
    try {
      return super.setMaxUsers(value);
    } finally {
      _$_ProviderRegistrationRequestActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderType(String value) {
    final _$actionInfo = _$_ProviderRegistrationRequestActionController
        .startAction(name: '_ProviderRegistrationRequest.setProviderType');
    try {
      return super.setProviderType(value);
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
subscriptionPlanId: ${subscriptionPlanId},
maxUsers: ${maxUsers},
providerType: ${providerType}
    ''';
  }
}
