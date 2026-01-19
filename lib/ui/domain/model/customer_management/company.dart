import 'package:mobx/mobx.dart';
import 'package:som/ui/domain/application/application.dart';
import 'package:som/ui/domain/model/customer_management/roles.dart';

import 'address.dart';
import 'provider_registration_request.dart';
import 'registration_user.dart';

part 'company.g.dart';

// ignore: library_private_types_in_public_api
class Company = _Company with _$Company;

abstract class _Company with Store {
  final Application appStore;
  final Object sharedPrefs;

  _Company(this.appStore, this.sharedPrefs);

  /// State
  @observable
  String? uidNr;

  @observable
  String? registrationNumber;

  @observable
  String? companySize = '0-10';

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
  Roles role = Roles.buyer;

  @observable
  ProviderRegistrationRequest providerData = ProviderRegistrationRequest();

  @observable
  ObservableList<RegistrationUser> users = ObservableList<RegistrationUser>();

  @observable
  RegistrationUser admin = RegistrationUser()..role = CompanyRole.admin;

  @observable
  bool termsAccepted = false;

  @observable
  bool privacyAccepted = false;

  @action
  void setAdmin(RegistrationUser value) => admin = value;

  @computed
  bool get isProvider =>
      role == Roles.provider || role == Roles.providerAndBuyer;

  @computed
  bool get isBuyer => role == Roles.buyer || role == Roles.providerAndBuyer;

  @computed
  int get numberOfAllowedUsers {
    if (isBuyer) {
      return 50;
    }

    return providerData.maxUsers ?? 5;
  }

  @observable
  int numberOfUsers = 0;

  @action
  void increaseNumberOfUsers() {
    numberOfUsers++;
    final newUser = RegistrationUser();
    if (isProvider && !isBuyer) {
      newUser.role = CompanyRole.provider;
    } else {
      newUser.role = CompanyRole.buyer;
    }
    users.add(newUser);

    //todo: clean after done registration
    // appStore.emailSeed++;
    // users.add(
    //     RegistrationUser(email: 'slavisam+${appStore.emailSeed}@gmail.com'));
    // sharedPrefs.setString("emailSeed", appStore.emailSeed.toString());
  }

  @action
  void removeUser(int position) {
    users.removeAt(position);
    numberOfUsers--;
  }

  @computed
  bool get canCreateMoreUsers => users.length < numberOfAllowedUsers;

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
  void setPhoneNumber(String value) {
    phoneNumber = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setUrl(String value) {
    url = value;
  }

  @action
  void setAddress(Address value) => address = value;

  @action
  void setRole(Roles selectedRole) {
    role = selectedRole;
  }

  @action
  void setProviderData(ProviderRegistrationRequest value) =>
      providerData = value;

  @action
  void activateBuyer(bool selectBuyer) {
    if (selectBuyer) {
      if (role == Roles.provider) {
        role = Roles.providerAndBuyer;
      } else {
        role = Roles.buyer;
      }
    } else {
      if (role == Roles.buyer || role == Roles.providerAndBuyer) {
        role = Roles.provider;
      }
    }
  }

  @action
  void activateProvider(bool selectProvider) {
    if (selectProvider) {
      if (role == Roles.buyer) {
        role = Roles.providerAndBuyer;
      } else {
        role = Roles.provider;
      }
    } else {
      if (role == Roles.provider || role == Roles.providerAndBuyer) {
        role = Roles.buyer;
      }
    }
  }

  @action
  void switchRole(Roles selectedRole) {
    switch (selectedRole) {
      case Roles.buyer:
        if (role == Roles.buyer || role == Roles.providerAndBuyer) {
          role = Roles.provider;
        } else {
          role = Roles.providerAndBuyer;
        }
        break;
      case Roles.provider:
        if (role == Roles.provider || role == Roles.providerAndBuyer) {
          role = Roles.buyer;
        } else {
          role = Roles.providerAndBuyer;
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
