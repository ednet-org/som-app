import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/roles.dart';

part 'customer-store.g.dart';

class CustomerStore = CustomerStoreBase with _$CustomerStore;

abstract class CustomerStoreBase with Store {
  @observable
  String uuid = DateTime.now().toString();

  @observable
  String? firstName = "Pera Kojot";

  @observable
  String? lastName = "Genije";

  @computed
  String get fullName => '$firstName, $lastName';

  @observable
  String? email;

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
}
