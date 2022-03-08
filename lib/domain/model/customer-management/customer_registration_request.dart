import 'package:mobx/mobx.dart';

import 'company.dart';

part 'customer_registration_request.g.dart';

class CustomerRegistrationRequest = _CustomerRegistrationRequest
    with _$CustomerRegistrationRequest;

abstract class _CustomerRegistrationRequest with Store {
  @observable
  Company company = Company();

  @action
  void setCompany(Company value) => company = value;
}
