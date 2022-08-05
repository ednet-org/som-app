import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/domain/model/customer-management/roles.dart';
import 'package:som/ui/utils/AppConstant.dart';

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
  Future<void> toggleDarkMode({bool? value}) async {
    isDarkModeOn = value ?? !isDarkModeOn;

    if (isDarkModeOn) {
      // scaffoldBackground = appBackgroundColorDark;

      // appBarColor = cardBackgroundBlackDark;
      // backgroundColor = appColorPrimaryDarkLight;
      // backgroundSecondaryColor = m3SysDarkOnSecondary;
      // appColorPrimaryLightColor = cardBackgroundBlackDark;
      //
      // iconColor = iconColorPrimary;
      // Theme.of(context).colorScheme.secondary = iconColorSecondary;

      textPrimaryColorGlobal = whiteColor;
      textSecondaryColorGlobal = Colors.white54;
      // shadowColorGlobal = appShadowColorDark;

      setStatusBarColor(Colors.black);
    } else {
      // backgroundSecondaryColor = appSecondaryBackgroundColor;
      // appColorPrimaryLightColor = appColorPrimaryLight;
      //
      // iconColor = iconColorPrimaryDark;
      // Theme.of(context).colorScheme.secondary = iconColorSecondaryDark;
      //
      // textPrimaryColor = appTextColorPrimary;
      // textSecondaryColor = appTextColorSecondary;
      //
      // textPrimaryColorGlobal = appTextColorPrimary;
      // textSecondaryColorGlobal = appTextColorSecondary;
      // shadowColorGlobal = appShadowColor;

      setStatusBarColor(Colors.white);
    }

    setValue(isDarkModeOnPref, isDarkModeOn);
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
  login(String? email, String? password) {
    if (email == null || password == null) {
      return false;
    }
    // authorization = Authorization(
    //   email: email,
    //   password: password,
    //   roles: [Role.customer],
    // );
    return true;
  }

  @observable
  Authorization? authorization;
}

class Authorization {
  Roles companyRole;
  UserRoles userRole;
  var user;

  Authorization({
    required this.companyRole,
    required this.userRole,
    required this.user,
  });
}

enum UserRoles {
  Employee,
  Admin,
}
