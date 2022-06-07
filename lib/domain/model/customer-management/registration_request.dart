import 'package:mobx/mobx.dart';
import 'package:som/domain/model/shared/som.dart';

import 'company.dart';

part 'registration_request.g.dart';

class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  Som som;
  _RegistrationRequest(this.som);

  @observable
  Company company = Company();

  @action
  void setCompany(Company value) => company = value;
}
