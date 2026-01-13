import 'package:mobx/mobx.dart';
import 'package:som/ui/domain/model/customer_management/roles.dart';

import 'address.dart';
import 'provider_registration_request.dart';
import 'registration_user.dart';

part 'company.g.dart';

class Company = _Company with _$Company;

abstract class _Company with Store {
  final appStore;
  final sharedPrefs;

  _Company(this.appStore, this.sharedPrefs);

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

  @observable
  bool termsAccepted = false;

  @observable
  bool privacyAccepted = false;

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

    if (providerData.maxUsers != null) {
      return providerData.maxUsers;
    }

    return 5;
  }

  @observable
  int numberOfUsers = 0;

  @action
  void increaseNumberOfUsers() {
    numberOfUsers++;
    users.add(RegistrationUser());

    //todo: clean after done registration
    // appStore.emailSeed++;
    // users.add(
    //     RegistrationUser(email: 'slavisam+${appStore.emailSeed}@gmail.com'));
    // sharedPrefs.setString("emailSeed", appStore.emailSeed.toString());
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

  @action
  void setTermsAccepted(bool value) => termsAccepted = value;

  @action
  void setPrivacyAccepted(bool value) => privacyAccepted = value;
}
