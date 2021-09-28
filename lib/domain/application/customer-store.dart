import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/roles.dart';

part 'customer-store.g.dart';

class CustomerStore = CustomerStoreBase with _$CustomerStore;

abstract class CustomerStoreBase with Store {
  @observable
  RegisteringCustomer registeringCustomer = RegisteringCustomer();
}

class RegisteringCustomer {
  @observable
  String uuid = DateTime.now().toString();

  @observable  String? firstName;

  @observable
  String? lastName;

  @computed
  String get fullName => '$firstName, $lastName';

  @observable
  String? email;

  @observable
  Roles role = Roles.Buyer;

  @action
  void selectRole(selectedRole) {
    print('selected Role set fired: $selectedRole');
    role = selectedRole;
  }
}
