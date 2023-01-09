import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer_management/roles.dart';

part 'application.g.dart';

class Application = _Application with _$Application;

abstract class _Application with Store {
  @observable
  double applicationWidth = 600;

  @observable
  double buttonWidth = 200;

  @observable
  double textScaleFactor = 1.0;

  @action
  void setTextScaleFactor(double value) => textScaleFactor = value;

  @observable
  bool isDarkModeOn = true;

  @observable
  String selectedLanguage = 'de';

  @observable
  var selectedDrawerItem = -1;

  @action
  void toggleDarkMode() {
    isDarkModeOn = !isDarkModeOn;
  }

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
  login(Authorization aAuthorization) async {
    authorization = aAuthorization;
  }

  @observable
  Authorization? authorization;
}

class Authorization {
  Roles? companyRole;
  UserRoles? userRole;
  String token;
  String refreshToken;
  var user;

  Authorization({
    this.companyRole,
    this.userRole,
    this.user,
    required this.token,
    required this.refreshToken,
  });
}

enum UserRoles {
  Employee,
  Admin,
}
