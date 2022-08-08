import 'package:mobx/mobx.dart';

part 'registration_user.g.dart';

/// Model of registering customer,
/// it can have state - be invited and prepopulated
class RegistrationUser = _RegistrationUser with _$RegistrationUser;

enum CompanyRole { admin, employee }

abstract class _RegistrationUser with Store {
  _RegistrationUser({this.email});
  @observable
  String? firstName;

  @observable
  String? lastName;

  @observable
  String? email;

  @observable
  String? title;

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

  @action
  void setTitle(String value) => title = value;

  @computed
  get hasAcceptedTermsAndPolicies => terms != null && policies != null;
}
