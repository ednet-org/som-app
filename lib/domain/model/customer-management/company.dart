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
  Address? address;

  @action
  void setAddress(Address value) => address = value;

  @observable
  String? websiteUrl;

  @action
  void setWebsiteUrl(String value) => websiteUrl = value;
}
