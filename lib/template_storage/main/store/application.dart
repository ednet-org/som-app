import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer-management/roles.dart';

part 'application.g.dart';

class Application = _Application with _$Application;

abstract class _Application with Store {
  @observable
  double applicationWidth = 600;
  @observable
  double buttonWidth = 200;

  @observable
  bool isDarkModeOn = false;

  @observable
  String selectedLanguage = 'de';

  @observable
  var selectedDrawerItem = -1;

  @action
  Future<void> toggleDarkMode({bool? value}) async {}

  @action
  void setLanguage(String aLanguage) => selectedLanguage = aLanguage;

  @action
  void setDrawerItemIndex(int aIndex) {
    selectedDrawerItem = aIndex;
  }

  @computed
  get isAuthenticated => authorization != null;

  @action
  logout() {
    authorization = null;
  }

  @action
  login(Authorization aAuthorization) {
    authorization = aAuthorization;
  }

  @observable
  Authorization? authorization;
}

class Authorization {
  Roles? companyRole;
  UserRoles? userRole;
  String? token;
  String? refreshToken;
  var user;

  Authorization({
    this.companyRole,
    this.userRole,
    this.user,
    this.token,
    this.refreshToken,
  });
}

enum UserRoles {
  Employee,
  Admin,
}
