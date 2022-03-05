import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/bank_details.dart';
import 'package:som/domain/model/customer-management/branch.dart';
import 'package:som/domain/model/customer-management/payment-interval.dart';

part 'provider_registration_request.g.dart';

class ProviderRegistrationRequest = _ProviderRegistrationRequest
    with _$ProviderRegistrationRequest;

abstract class _ProviderRegistrationRequest with Store {
  @observable
  BankDetails? bankDetails;

  @action
  void setBankDetails(BankDetails value) => bankDetails = value;

  @observable
  ObservableList<Branch> branches = ObservableList<Branch>();

  @action
  void addBranch(Branch value) => branches.add(value);

  @observable
  PaymentInterval? paymentInterval;

  @action
  void setPaymentInterval(PaymentInterval value) => paymentInterval = value;

  @observable
  String? subscriptionPlanId;

  @action
  void setSubscriptionPlanId(String value) => subscriptionPlanId = value;
}
