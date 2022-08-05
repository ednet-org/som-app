import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:som/domain/model/customer-management/roles.dart';

part 'application.g.dart';

class Application = _Application with _$Application;

abstract class _Application with Store {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
  login(Authorization aAuthorization) async {
    final sharedPrefs = await _prefs;

    sharedPrefs
      ..setString('token', aAuthorization.token)
      ..setString('refreshToken', aAuthorization.refreshToken);
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
