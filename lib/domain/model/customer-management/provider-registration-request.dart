import 'package:som/domain/model/customer-management/bank-details.dart';
import 'package:som/domain/model/customer-management/branch.dart';
import 'package:som/domain/model/customer-management/payment-interval.dart';

class ProviderRegistrationRequest {
  BankDetails bankDetails;
  List<Branch> branches;

  PaymentInterval paymentInterval;
  int subscriptionPlanId;

  ProviderRegistrationRequest(this.bankDetails, this.branches,
      this.paymentInterval, this.subscriptionPlanId);
}
