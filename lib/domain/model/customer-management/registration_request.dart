import 'package:mobx/mobx.dart';
import 'package:som/domain/core/model/i_repository.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';
import 'package:som/domain/model/shared/som.dart';

import 'company.dart';

part 'registration_request.g.dart';

class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  IRepository<Subscription> apiSubscriptionRepository;
  Som som;

  // late IRepository<Subscription> subscriptionRepository;
  _RegistrationRequest(this.apiSubscriptionRepository, this.som);

  @observable
  Company company = Company();

  @action
  void setCompany(Company value) => company = value;
}
