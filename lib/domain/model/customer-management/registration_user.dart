import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/company.dart';

part 'registration_user.g.dart';

/// Model of registering customer,
/// it can have state - be invited and prepopulated
class RegistrationUser = _RegistrationUser with _$RegistrationUser;

abstract class _RegistrationUser with Store {
  @observable
  String? email;

  @action
  void setEmail(String value) => salutation = value;

  @observable
  String? salutation;

  @action
  void setSalutation(String value) => salutation = value;
}
