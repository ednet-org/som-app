//region imports
import 'package:chopper/chopper.dart';
import 'package:ednet_component_library/ednet_component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/login/email_login_store.dart';
import 'package:som/domain/infrastructure/repository/api/lib/api_subscription_repository.dart';
import 'package:som/domain/infrastructure/repository/api/lib/login_service.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/api_company_service.dart';
import 'package:som/domain/infrastructure/repository/api/lib/subscription_service.dart';
import 'package:som/domain/infrastructure/repository/api/utils/converters/json_serializable_converter.dart';
import 'package:som/domain/infrastructure/repository/api/utils/interceptors/cors_interceptor.dart';
import 'package:som/domain/infrastructure/repository/api/utils/interceptors/http_color_logging_interceptor.dart';
import 'package:som/domain/infrastructure/repository/api/utils/interceptors/token_interceptor.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/domain/model/shared/som.dart';
import 'package:som/routes.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/pages/splash_page.dart';
import 'package:som/ui/utils/AppConstant.dart';

import 'template_storage/main/utils/intl/som_localizations.dart';
//endregion

/// This variable is used to get dynamic colors when theme mode is changed
var appStore = Application();
ThemeData? darkTheme;
ThemeData? lightTheme;
var subscriptionService;
var loginService;
var apiCompanyService;

void main() async {
  final api = ChopperClient(
    baseUrl: "https://som-userservice-dev-dm.azurewebsites.net/",
    services: [
      // Create and pass an instance of the generated service to the client
      SubscriptionService.create(),
      LoginService.create(),
      ApiCompanyService.create(),
    ],
    converter: JsonSerializableConverter(),
    errorConverter: JsonConverter(),
    interceptors: [
      TokenInterceptor(),
      CORSInterceptor(),
      HttpColorLoggingInterceptor(),
    ],
  );
  subscriptionService = api.getService<SubscriptionService>();
  loginService = api.getService<LoginService>();
  apiCompanyService = api.getService<ApiCompanyService>();

  var companies = await apiCompanyService.getCompanies();

  darkTheme = await EdsAppTheme.som["dark"];
  lightTheme = await EdsAppTheme.som["light"];

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
        Provider<ApiSubscriptionRepository>(
          create: (_) => ApiSubscriptionRepository(subscriptionService),
        ),
        ProxyProvider<ApiSubscriptionRepository, Som>(
            update: (_, apiSubscriptionRepository, __) =>
                Som(apiSubscriptionRepository)
                  ..populateAvailableSubscriptions()),
        ProxyProvider<Som, RegistrationRequest>(
            update: (_, som, __) => RegistrationRequest(som)),
        Provider<EmailLoginStore>(
            create: (_) => EmailLoginStore(loginService, appStore)),
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
          home: SplashPage(appStore),
          // hardcoded dark mode
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          builder: scrollBehaviour(),
        ),
      ),
    );
  }
}
