import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/provider_registration_request.dart';
import 'package:som/domain/model/customer-management/registration_user.dart';
import 'package:som/domain/model/customer-management/roles.dart';

import 'company.dart';

part 'customer_registration_request.g.dart';

class CustomerRegistrationRequest = _CustomerRegistrationRequest
    with _$CustomerRegistrationRequest;

abstract class _CustomerRegistrationRequest with Store {
  @observable
  Roles role = Roles.Buyer;

  @action
  void selectRole(selectedRole) {
    role = selectedRole;
  }

  @action
  void activateBuyer(selectBuyer) {
    if (selectBuyer) {
      if (role == Roles.Provider) {
        role = Roles.ProviderAndBuyer;
      } else {
        role = Roles.Buyer;
      }
    } else {
      if (role == Roles.Buyer || role == Roles.ProviderAndBuyer) {
        role = Roles.Provider;
      }
    }
  }

  @action
  void activateProvider(selectProvider) {
    if (selectProvider) {
      if (role == Roles.Buyer) {
        role = Roles.ProviderAndBuyer;
      } else {
        role = Roles.Provider;
      }
    } else {
      if (role == Roles.Provider || role == Roles.ProviderAndBuyer) {
        role = Roles.Buyer;
      }
    }
  }

  @action
  void switchRole(selectedRole) {
    switch (selectedRole) {
      case Roles.Buyer:
        if (role == Roles.Buyer || role == Roles.ProviderAndBuyer) {
          role = Roles.Provider;
        } else {
          role = Roles.ProviderAndBuyer;
        }
        break;
      case Roles.Provider:
        if (role == Roles.Provider || role == Roles.ProviderAndBuyer) {
          role = Roles.Buyer;
        } else {
          role = Roles.ProviderAndBuyer;
        }
        break;
      default:
        throw StateError(
            'One can not set both provider and buyer at same time from UI');
    }
  }

  @observable
  Company? company;

  @action
  void setCompany(Company value) => company = value;

  @computed
  get isProvider => role == Roles.Provider || role == Roles.ProviderAndBuyer;

  @computed
  get isBuyer => role == Roles.Buyer || role == Roles.ProviderAndBuyer;

  @observable
  ObservableList<RegistrationUser> users = ObservableList<RegistrationUser>();

  @action
  void addUser(RegistrationUser value) => users.add(value);

  @observable
  ProviderRegistrationRequest? providerData;

  @action
  void setProviderData(ProviderRegistrationRequest value) =>
      providerData = value;
}
