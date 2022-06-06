//region imports
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/infrastructure/repository/api/lib/subscription_service.dart';
import 'package:som/domain/infrastructure/repository/api/utils/converters/json_serializable_converter.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/routes.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/template_storage/main/utils/AppTheme.dart';
import 'package:som/ui/pages/splash_page.dart';

import 'template_storage/main/utils/AppConstant.dart';
import 'template_storage/main/utils/intl/som_localizations.dart';
//endregion

/// This variable is used to get dynamic colors when theme mode is changed
var appStore = Application();

void main() async {
  final chopper = ChopperClient(
    baseUrl: "https://som-userservice.herokuapp.com",
    services: [
      // Create and pass an instance of the generated service to the client
      SubscriptionService.create()
    ],
    converter: JsonSerializableConverter(),
  );

  final subscriptionService = chopper.getService<SubscriptionService>();
  final response = await subscriptionService.getSubscriptions();
  if (response.isSuccessful) {
    // Successful request
    final body = response.body;
    print(body);
  } else {
    // Error code received from server
    final code = response.statusCode;
    final error = response.error;
    print(code);
    print(error);
  }
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
        Provider<Application>(create: (_) => appStore),
        Provider<RegistrationRequest>(create: (_) => RegistrationRequest()),
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
