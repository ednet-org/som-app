import 'package:som/domain/model/customer-management/provider-registration-request.dart';
import 'package:som/domain/model/customer-management/user-registration-request.dart';

import 'company.dart';

class CustomerRegistrationRequest {
  Company company;

  CustomerRegistrationRequest(this.company, this.users, this.providerData);

  List<UserRegistrationRequest> users = [];

  void addUserRequest(UserRegistrationRequest userRequest) {
    userRequest.company = this.company;
    users.add(userRequest);
  }

  ProviderRegistrationRequest? providerData;
}
