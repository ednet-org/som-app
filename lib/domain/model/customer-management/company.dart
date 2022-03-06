import 'package:mobx/mobx.dart';

import 'address.dart';

part 'company.g.dart';

class Company = _Company with _$Company;

abstract class _Company with Store {
  @observable
  String? uidNr;

  @observable
  String? registrationNumber;

  @action
  void setRegistrationNumber(String value) => registrationNumber = value;

  @observable
  String? companySize;

  @action
  void setCompanySize(String value) => companySize = value;

  @action
  void setUidNr(String value) => uidNr = value;

  @observable
  String? name;

  @action
  void setName(String value) => name = value;

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
  String? url;

  @action
  void setUrl(value) {
    url = value;
  }

  @observable
  Address? address;

  @action
  void setAddress(Address value) => address = value;
}
