//region imports
import 'dart:convert';

import 'package:beamer/beamer.dart';
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
import 'package:som/domain/core/model/user_account_confirmation/user_account_confirmation.dart';
import 'package:som/domain/infrastructure/repository/api/lib/api_subscription_repository.dart';
import 'package:som/domain/infrastructure/repository/api/utils/interceptors/dio_cors_interceptor.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/domain/model/shared/som.dart';
import 'package:som/routes/beamer_provided_key.dart';
import 'package:som/routes/locations/auth/auth_confirm_email_page_location.dart';
import 'package:som/routes/locations/auth/auth_forgot_password_page_location.dart';
import 'package:som/routes/locations/auth/auth_login_page_location.dart';
import 'package:som/routes/locations/authenticated/smart_offer_management_page_location.dart';
import 'package:som/routes/locations/guest/customer_register_page_location.dart';
import 'package:som/routes/locations/guest/customer_register_success_page_location.dart';
import 'package:som/routes/locations/splash_page_beam_location.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/utils/AppConstant.dart';

import 'template_storage/main/utils/intl/som_localizations.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

final api_instance = Openapi(
    dio: Dio(BaseOptions(
        baseUrl: "https://som-userservice-dev-dm.azurewebsites.net"))
      // ..interceptors.add(PrettyDioLogger())
      ..interceptors.add(CorsInterceptor())
      ..interceptors.add(CurlLoggerDioInterceptor(
          printOnSuccess: true, convertFormData: false)),
    serializers: standardSerializers);

//endregion

var appStore;
ThemeData? darkTheme;
ThemeData? lightTheme;
var subscriptionService;
var loginService;
var apiCompanyService;

void main() async {
  // nb_utils - Must be initialize before using shared preference
  await initialize();

  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  final sharedPrefs = await prefsFuture;
  appStore = Application();

  // dio perform awful if not spawn to own worker
  (api_instance.dio.transformer as DefaultTransformer).jsonDecodeCallback =
      parseJson;

  await initTheming();

  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();
  // we do not need # in url
  // Beamer.setPathUrlStrategy();
  runApp(MyApp());
  //endregion
}

class MyApp extends StatelessWidget {
  final beamerKey = BeamerProvidedKey();

  final routerDelegate = BeamerDelegate(
      initialPath: '/splash',
      transitionDelegate: const NoAnimationTransitionDelegate(),
      locationBuilder: BeamerLocationBuilder(beamLocations: [
        SplashPageBeamLocation(),
        AuthLoginPageLocation(),
        AuthConfirmEmailPageLocation(),
        AuthForgotPasswordPageLocation(),
        CustomerRegisterPageLocation(),
        CustomerRegisterSuccessPageLocation(),
        SmartOfferManagementPageLocation(),
      ]));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BeamerProvidedKey>(create: (_) => beamerKey),
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
        ProxyProvider<EmailLoginStore, UserAccountConfirmation>(
            update: (_, emailLoginStore, __) => UserAccountConfirmation(
                api_instance.getAuthenticationApi(),
                appStore,
                emailLoginStore)),
      ],
      child: Observer(
        builder: (_) => MaterialApp.router(
          routeInformationParser: BeamerParser(),
          // android back button behavior
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: routerDelegate),
          localizationsDelegates: const [
            SomLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) =>
              Locale(appStore.selectedLanguage),
          locale: Locale(appStore.selectedLanguage),
          supportedLocales: [Locale('en'), Locale('de'), Locale('sr')],
          title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
          themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          builder: scrollBehaviour(),
          routerDelegate: routerDelegate,
        ),
      ),
    );
  }
}

//region bootstrap

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

Future<void> initTheming() async {
  darkTheme = await EdsAppTheme.som["dark"];
  lightTheme = await EdsAppTheme.som["light"];
}

//endregion
