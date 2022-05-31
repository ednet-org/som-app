import 'package:mobx/mobx.dart';

part 'registration_user.g.dart';

class RegistrationUser = RegistrationUserBase with _$RegistrationUser;

abstract class RegistrationUserBase with Store {
  @observable
  String? firstName;

  @observable
  String? lastName;

  @observable
  String? email;

  @observable
  String? phone;

  @observable
  String? salutation;

  @action
  void setSalutation(String value) => salutation = value;

  @observable
  String? terms;

  @observable
  String? policies;

  @action
  void setPolicies(String value) => policies = value;

  @action
  void setTerms(String value) => terms = value;

  @observable
  CompanyRole role = CompanyRole.employee;

  @action
  void setFirstName(String value) => firstName = value;

  @action
  void setLastName(String value) => lastName = value;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPhone(String value) => phone = value;

  @computed
  get hasAcceptedTermsAndPolicies => terms != null && policies != null;
}

enum CompanyRole { admin, employee }
