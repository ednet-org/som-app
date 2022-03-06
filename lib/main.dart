//region imports
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/address.dart';
import 'package:som/domain/model/customer-management/bank_details.dart';
import 'package:som/domain/model/customer-management/company.dart';
import 'package:som/domain/model/customer-management/customer_registration_request.dart';
import 'package:som/domain/model/customer-management/provider_registration_request.dart';
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
var address = Address();
var company = Company()..setAddress(address);

var bankDetails = BankDetails();
var provider = ProviderRegistrationRequest()..setBankDetails(bankDetails);

var customerRegistrationRequest = CustomerRegistrationRequest()
  ..setCompany(company)
  ..setProviderData(provider);

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
        Provider<AppStore>(create: (_) => appStore),
        Provider<Company>(create: (_) => company),
        Provider<Address>(create: (_) => address),
        Provider<CustomerRegistrationRequest>(
            create: (_) => customerRegistrationRequest),
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
