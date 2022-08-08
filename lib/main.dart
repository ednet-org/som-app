//region imports
import 'dart:convert';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:ednet_component_library/ednet_component_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/login/email_login_store.dart';
import 'package:som/domain/infrastructure/repository/api/lib/api_subscription_repository.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/domain/model/shared/som.dart';
import 'package:som/routes.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/pages/splash_page.dart';
import 'package:som/ui/utils/AppConstant.dart';

import 'template_storage/main/utils/intl/som_localizations.dart';

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

final api_instance = Openapi(
    dio: Dio(BaseOptions(
        baseUrl: "https://som-userservice-dev-dm.azurewebsites.net"))
      // ..interceptors.add(PrettyDioLogger())
      ..interceptors.add(CurlLoggerDioInterceptor(
          printOnSuccess: true, convertFormData: false)),
    serializers: standardSerializers);

final token = "token_example"; // String |
final email = "email_example"; // String |

//endregion

var appStore;
ThemeData? darkTheme;
ThemeData? lightTheme;
var subscriptionService;
var loginService;
var apiCompanyService;

void main() async {
  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  final sharedPrefs = await prefsFuture;
  num emailSeed = num.parse(sharedPrefs.getString('emailSeed') ?? "1");
  appStore = Application(sharedPrefs, emailSeed);

  // dio perform awful if not spawn to own worker
  (api_instance.dio.transformer as DefaultTransformer).jsonDecodeCallback =
      parseJson;

  // final api = ChopperClient(
  //   baseUrl: "https://som-userservice-dev-dm.azurewebsites.net/",
  //   services: [
  //     // Create and pass an instance of the generated service to the client
  //     SubscriptionService.create(),
  //     LoginService.create(),
  //     ApiCompanyService.create(),
  //   ],
  //   converter: JsonSerializableConverter(),
  //   errorConverter: JsonConverter(),
  //   interceptors: [
  //     TokenInterceptor(),
  //     CORSInterceptor(),
  //     HttpColorLoggingInterceptor(),
  //   ],
  // );
  // subscriptionService = api.getService<SubscriptionService>();
  // loginService = api.getService<LoginService>();
  // apiCompanyService = api.getService<ApiCompanyService>();

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
          create: (_) =>
              ApiSubscriptionRepository(api_instance.getSubscriptionsApi()),
        ),
        ProxyProvider<ApiSubscriptionRepository, Som>(
            update: (_, apiSubscriptionRepository, __) =>
                Som(apiSubscriptionRepository)
                  ..populateAvailableSubscriptions()),
        ProxyProvider<Som, RegistrationRequest>(
            update: (_, som, __) => RegistrationRequest(som,
                api_instance.getCompaniesApi(), appStore, sharedPreferences)),
        Provider<EmailLoginStore>(
            create: (_) =>
                EmailLoginStore(api_instance.getAuthenticationApi(), appStore)),
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
          themeMode: ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          builder: scrollBehaviour(),
        ),
      ),
    );
  }
}
