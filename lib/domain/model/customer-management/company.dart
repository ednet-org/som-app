import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/provider_registration_request.dart';
import 'package:som/domain/model/customer-management/registration_user.dart';
import 'package:som/domain/model/customer-management/roles.dart';

import 'address.dart';

part 'company.g.dart';

class Company = _Company with _$Company;

abstract class _Company with Store {
  /// State
  @observable
  String? uidNr;

  @observable
  String? registrationNumber;

  @observable
  String? companySize;

  @observable
  String? name;

  @observable
  String? phoneNumber;

  @observable
  String? email;

  @observable
  String? url;

  @observable
  Address address = Address();

  @observable
  Roles role = Roles.Buyer;

  @observable
  ProviderRegistrationRequest providerData = ProviderRegistrationRequest();

  @observable
  ObservableList<RegistrationUser> users = ObservableList<RegistrationUser>();

  @observable
  RegistrationUser admin = RegistrationUser();

  @action
  void setAdmin(value) => admin = value;

  @computed
  get isProvider => role == Roles.Provider || role == Roles.ProviderAndBuyer;

  @computed
  get isBuyer => role == Roles.Buyer || role == Roles.ProviderAndBuyer;

  @computed
  get numberOfAllowedUsers {
    if (isBuyer) {
      return 50;
    }

    switch (providerData.subscriptionPlanId) {
      case "1":
        return 1;
      case "2":
        return 5;
      case "3":
        return 15;
      default:
        return 5;
    }
  }

  @observable
  int numberOfUsers = 0;

  @action
  void increaseNumberOfUsers() {
    numberOfUsers++;
    users.add(RegistrationUser());
  }

  @action
  void removeUser(position) {
    users.removeAt(position);
    numberOfUsers--;
  }

  @computed
  get canCreateMoreUsers => users.length < numberOfAllowedUsers;

  /// Mutations
  @action
  void setRegistrationNumber(String value) => registrationNumber = value;

  @action
  void setCompanySize(String value) => companySize = value;

  @action
  void setUidNr(String value) => uidNr = value;

  @action
  void setName(String value) => name = value;

  @action
  void setPhoneNumber(value) {
    phoneNumber = value;
  }

  @action
  void setEmail(value) {
    email = value;
  }

  @action
  void setUrl(value) {
    url = value;
  }

  @action
  void setAddress(Address value) => address = value;

  @action
  void setRole(selectedRole) {
    role = selectedRole;
  }

  @action
  void setProviderData(ProviderRegistrationRequest value) =>
      providerData = value;

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

  @action
  void addUser(RegistrationUser value) => users.add(value);
}
