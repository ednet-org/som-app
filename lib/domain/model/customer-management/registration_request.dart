import 'package:mobx/mobx.dart';

import 'company.dart';

part 'registration_request.g.dart';

class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  @observable
  Company company = Company();

  @action
  void setCompany(Company value) => company = value;
}
