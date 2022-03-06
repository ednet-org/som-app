//region imports
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/address.dart';
import 'package:som/domain/model/customer-management/company.dart';
import 'package:som/domain/model/customer-management/lead_customer_store.dart';
import 'package:som/routes.dart';
import 'package:som/template_storage/main/store/AppStore.dart';
import 'package:som/template_storage/main/utils/AppTheme.dart';
import 'package:som/ui/pages/splash_page.dart';

import 'template_storage/main/utils/AppConstant.dart';
import 'template_storage/main/utils/intl/som_localizations.dart';
//endregion

/// This variable is used to get dynamic colors when theme mode is changed
var appStore = AppStore();

/// domain model
var oneAddressStore = Address();
var companyStore = Company()..setAddress(oneAddressStore);

var leadCustomerStore = LeadCustomerStore()..setCompany(companyStore);

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  // nb_utils - Must be initialize before using shared preference
  await initialize();

  // Lets start with default dark mode till we solve logo transparency
  appStore.toggleDarkMode(value: true);
  // appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  if (isMobile) {
    // await Firebase.initializeApp();
    //
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runApp(MyApp());
  //endregion
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LeadCustomerStore>(create: (_) => leadCustomerStore),
        Provider<AppStore>(create: (_) => appStore),
        Provider<Company>(create: (_) => companyStore),
        Provider<Address>(create: (_) => oneAddressStore),
      ],
      child: Observer(
        builder: (_) => MaterialApp(
          localizationsDelegates: const [
            SomLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) =>
              Locale(appStore.selectedLanguage),
          locale: Locale(appStore.selectedLanguage),
          supportedLocales: [Locale('en'), Locale('de'), Locale('sr')],
          routes: routes(),
          title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
          home: SplashPage(isAuthenticated: appStore.isAuthenticated),
          theme: !appStore.isDarkModeOn
              ? AppThemeData.lightTheme
              : AppThemeData.darkTheme,
          builder: scrollBehaviour(),
        ),
      ),
    );
  }
}
