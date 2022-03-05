import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/roles.dart';

part 'user_registration_request.g.dart';

class UserRegistrationRequest = _UserRegistrationRequest
    with _$UserRegistrationRequest;

abstract class _UserRegistrationRequest with Store {
  @observable
  String uuid = DateTime.now().toString();

  @observable
  String? firstName;

  @observable
  String? lastName;

  @computed
  String get fullName => '$firstName, $lastName';

  @observable
  Roles role = Roles.Buyer;

  @action
  void selectRole(selectedRole) {
    role = selectedRole;
  }

  @action
  void setBuyer(selectBuyer) {
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
  void setProvider(selectProvider) {
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

  @computed
  get isProvider => role == Roles.Provider || role == Roles.ProviderAndBuyer;

  @computed
  get isBuyer => role == Roles.Buyer || role == Roles.ProviderAndBuyer;

  /// Company
  @observable
  String? companyName;

  @action
  void setCompanyName(value) {
    companyName = value;
  }

  @observable
  String? uidNumber;

  @action
  void setUidNumber(value) {
    uidNumber = value;
  }

  @observable
  String? registrationNumber;

  @action
  void setRegistrationNumber(value) {
    registrationNumber = value;
  }

  @observable
  String? phoneNumber;

  @action
  void setPhoneNumber(value) {
    phoneNumber = value;
  }

  @observable
  String? email;

  @action
  void setEmail(value) {
    email = value;
  }

  @observable
  String? companyUrl;

  @action
  void setCompanyUrl(value) {
    companyUrl = value;
  }

  @observable
  String? country;

  @action
  void setCountry(value) {
    country = value;
  }

  @observable
  String? zip;

  @action
  void setZip(value) {
    zip = value;
  }

  @observable
  String? city;

  @action
  void setCity(value) {
    city = value;
  }

  @observable
  String? street;

  @action
  void setStreet(value) {
    street = value;
  }

  @observable
  String? streetNumber;

  @action
  void setStreetNumber(value) {
    streetNumber = value;
  }

  @observable
  String? salutation;

  @action
  void setSalutation(String value) => salutation = value;
}
