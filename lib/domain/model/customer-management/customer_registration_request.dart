import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/provider_registration_request.dart';
import 'package:som/domain/model/customer-management/user_registration_request.dart';

import 'company.dart';

part 'customer_registration_request.g.dart';

class CustomerRegistrationRequest = _CustomerRegistrationRequest
    with _$CustomerRegistrationRequest;

abstract class _CustomerRegistrationRequest with Store {
  @observable
  Company? company;

  @action
  void setCompany(Company value) => company = value;

  @observable
  ObservableList<UserRegistrationRequest> users =
      ObservableList<UserRegistrationRequest>();

  @action
  void addUser(UserRegistrationRequest value) => users.add(value);

  @observable
  ProviderRegistrationRequest? providerData;

  @action
  void setProviderData(ProviderRegistrationRequest value) =>
      providerData = value;
}
