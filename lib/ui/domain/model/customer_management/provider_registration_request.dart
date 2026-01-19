import 'package:mobx/mobx.dart';

import 'bank_details.dart';
import 'branch.dart';
import 'payment_interval.dart';

part 'provider_registration_request.g.dart';

// ignore: library_private_types_in_public_api
class ProviderRegistrationRequest = _ProviderRegistrationRequest
    with _$ProviderRegistrationRequest;

abstract class _ProviderRegistrationRequest with Store {
  @observable
  BankDetails? bankDetails = BankDetails();

  @action
  void setBankDetails(BankDetails value) => bankDetails = value;

  @observable
  ObservableList<Branch> branches = ObservableList<Branch>();

  @action
  void addBranch(Branch value) => branches.add(value);

  @observable
  PaymentInterval? paymentInterval = PaymentInterval.yearly;

  @action
  void setPaymentInterval(PaymentInterval value) => paymentInterval = value;

  @observable
  String? subscriptionPlanId;

  @action
  void setSubscriptionPlanId(String value) => subscriptionPlanId = value;

  @observable
  int? maxUsers;

  @observable
  String? providerType = 'haendler';

  @action
  void setMaxUsers(int? value) => maxUsers = value;

  @action
  void setProviderType(String value) => providerType = value;
}
