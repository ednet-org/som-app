import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/company.dart';

part 'registration_user.g.dart';

/// Model of registering customer,
/// it can have state - be invited and prepopulated
class RegistrationUser = _RegistrationUser with _$RegistrationUser;

abstract class _RegistrationUser with Store {
  @observable
  String? uuid;

  @action
  void setUuid(String value) => uuid = value;

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
  @observable
  Company? company;

  @action
  void setCompany(Company value) => company = value;
}
