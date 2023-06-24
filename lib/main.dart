//region imports
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/infrastructure/repository/api/lib/api_subscription_repository.dart';
import 'package:som/domain/infrastructure/repository/api/utils/interceptors/dio_cors_interceptor.dart';
import 'package:som/ui/pages/not_found_page.dart';
import 'package:som/ui/routes/routes.dart';

import 'ui/domain/application/application.dart';
import 'ui/domain/application/som_localizations.dart';
import 'ui/domain/model/model.dart';
import 'ui/domain/model/user_account_confirmation/user_account_confirmation.dart';

// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

/// Environment
const env = String.fromEnvironment('env', defaultValue: 'dev');

void main() async {
  initDomainModel();
  // nb_utils - Must be initialize before using shared preference
  await initialize();

  print("Environment: $env");

  // final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  // final sharedPrefs = await prefsFuture;
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

const seedColor = Color(0x0044546a);

class MyApp extends StatelessWidget {
  final beamerKey = BeamerProvidedKey();

  final routerDelegate = BeamerDelegate(
      initialPath: '/splash',
      notFoundPage: const BeamPage(
        key: ValueKey('not found page'),
        title: 'Not Found',
        child: NotFoundPage(),
      ),
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

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      appStore.boxConstraints = constraints;
      return MultiProvider(
        providers: getProviders,
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
            supportedLocales: const [
              Locale('en'),
              Locale('de'),
              Locale('sr'),
            ],
            title: 'SOM${!isMobile ? ' ${platformName()}' : ''}',
            themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: seedColor,
                brightness: Brightness.light),
            darkTheme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: seedColor,
                brightness: Brightness.dark),
            builder: scrollBehaviour(),
            routerDelegate: routerDelegate,
          ),
        ),
      );
    });
  }

  get getProviders {
    return [
      Provider<AuthForgotPasswordPageState>(
          create: (_) =>
              AuthForgotPasswordPageState(api_instance.getAuthenticationApi())),
      Provider<BeamerProvidedKey>(create: (_) => beamerKey),
      Provider<Application>(create: (_) => appStore),
      Provider<ApiSubscriptionRepository>(
        create: (_) =>
            ApiSubscriptionRepository(api_instance.getSubscriptionsApi()),
      ),
      ProxyProvider<ApiSubscriptionRepository, Som>(
          update: (_, apiSubscriptionRepository, __) =>
              Som(apiSubscriptionRepository)),
      // Som(apiSubscriptionRepository)..populateAvailableSubscriptions()),
      ProxyProvider<Som, RegistrationRequest>(
          update: (_, som, __) => RegistrationRequest(som,
              api_instance.getCompaniesApi(), appStore, sharedPreferences)),
      Provider<EmailLoginStore>(
          create: (_) =>
              EmailLoginStore(api_instance.getAuthenticationApi(), appStore)),
      ProxyProvider<EmailLoginStore, UserAccountConfirmation>(
          update: (_, emailLoginStore, __) => UserAccountConfirmation(
              api_instance.getAuthenticationApi(), appStore, emailLoginStore)),
    ];
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
  // darkTheme = await EdsAppTheme.eds["dark"];
  // lightTheme = await EdsAppTheme.eds["light"];
}

//endregion
void initDomainModel() async {
  // var repository = som.Repository();
  // som.SomDomain somDomain = repository.getDomainModels("Som") as som.SomDomain;
  // assert(somDomain != null);
  // som.ManagerModel managerModel =
  //     somDomain.getModelEntries("Manager") as som.ManagerModel;
  // assert(managerModel != null);
  // var companies = managerModel.companies;
  //
  // print(companies.length);
  //
  // // Load the data from the JSON file if it exists
  // final dbFile = File('db.json');
  // if (await dbFile.exists()) {
  //   final dbData = await dbFile.readAsString();
  //   managerModel.fromJson(dbData);
  // }
  //
  // // Perform some operations on the domain models
  // // For example:
  // // final oid = Oid.ts(1678097187526);
  // final companyConcept = managerModel.companies.concept;
  // final newCompany = som.Company(companyConcept);
  // newCompany.name = "NewCompany";
  // managerModel.companies.add(newCompany);
  //
  // final jsonString = json.encode(managerModel.toJsonMap());
  // // Save the updated data to the JSON file
  // if (await dbFile.exists()) {
  //   await dbFile.writeAsString(jsonString);
  // } else {
  //   await dbFile.create().then((_) => dbFile.writeAsString(jsonString));
  // }
}
