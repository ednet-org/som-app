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
import 'package:provider/single_child_widget.dart';
import 'package:som/domain/infrastructure/repository/api/lib/api_subscription_repository.dart';
import 'package:som/ui/pages/not_found_page.dart';
import 'package:som/ui/routes/routes.dart';
import 'package:som/ui/domain/infrastructure/supabase_realtime.dart';

import 'ui/domain/application/application.dart';
import 'ui/domain/application/som_localizations.dart';
import 'ui/domain/infrastructure/api/auth_token_interceptor.dart';
import 'ui/domain/model/model.dart';
import 'ui/domain/model/user_account_confirmation/user_account_confirmation.dart';
import 'ui/theme/som_theme_futuristic.dart';

// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8081',
);

const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: '',
);

const supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: '',
);
const supabaseSchema = String.fromEnvironment(
  'SUPABASE_SCHEMA',
  defaultValue: 'som',
);

final apiInstance = Openapi(
  dio: Dio(BaseOptions(baseUrl: apiBaseUrl))
    // ..interceptors.add(PrettyDioLogger())
    ..interceptors.add(
      CurlLoggerDioInterceptor(printOnSuccess: true, convertFormData: false),
    ),
  serializers: standardSerializers,
);

//endregion

late final Application appStore;
ThemeData? darkTheme;
ThemeData? lightTheme;

/// Environment
const env = String.fromEnvironment('env', defaultValue: 'dev');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseRealtime.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    schema: supabaseSchema,
  );
  initDomainModel();
  // nb_utils - Must be initialize before using shared preference
  await initialize();

  if (kDebugMode) {
    debugPrint('Environment: $env');
  }

  // final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  // final sharedPrefs = await prefsFuture;
  appStore = Application();
  await appStore.loadPreferences();

  // dio perform awful if not spawn to own worker
  apiInstance.dio.transformer = BackgroundTransformer()
    ..jsonDecodeCallback = parseJson;
  apiInstance.dio.interceptors.add(AuthTokenInterceptor(appStore));

  await initTheming();

  //region Entry Point
  // Enable clean URLs without # for web
  Beamer.setPathUrlStrategy();
  runApp(MyApp());
  //endregion
}

// Fixed: Alpha was 0x00 (transparent), now 0xFF (opaque)

class MyApp extends StatelessWidget {
  final beamerKey = BeamerProvidedKey();

  final routerDelegate = BeamerDelegate(
    initialPath: '/inquiries',
    notFoundPage: const BeamPage(
      key: ValueKey('not found page'),
      title: 'Not Found',
      child: NotFoundPage(),
    ),
    transitionDelegate: const NoAnimationTransitionDelegate(),
    guards: [
      // Redirect to login if not authenticated for protected routes
      BeamGuard(
        pathPatterns: [
          '/',
          '/inquiries',
          '/inquiries/*',
          '/offers',
          '/offers/*',
          '/ads',
          '/ads/*',
          '/branches',
          '/branches/*',
          '/consultants',
          '/providers',
          '/providers/*',
          '/companies',
          '/companies/*',
          '/subscriptions',
          '/subscriptions/*',
          '/roles',
          '/audit',
          '/statistics',
          '/user',
        ],
        check: (context, location) => appStore.isAuthenticated,
        beamToNamed: (origin, target) => '/auth/login',
      ),
      // Redirect away from login if already authenticated
      BeamGuard(
        pathPatterns: ['/auth/login', '/splash'],
        check: (context, location) => !appStore.isAuthenticated,
        beamToNamed: (origin, target) => '/inquiries',
      ),
    ],
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        SplashPageBeamLocation(),
        AuthLoginPageLocation(),
        AuthConfirmEmailPageLocation(),
        AuthForgotPasswordPageLocation(),
        CustomerRegisterPageLocation(),
        CustomerRegisterSuccessPageLocation(),
        SmartOfferManagementPageLocation(),
      ],
    ).call,
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        appStore.boxConstraints = constraints;
        return MultiProvider(
          providers: getProviders,
          child: Observer(
            builder: (_) => MaterialApp.router(
              routeInformationParser: BeamerParser(),
              // android back button behavior
              backButtonDispatcher: BeamerBackButtonDispatcher(
                delegate: routerDelegate,
              ),
              localizationsDelegates: const [
                SomLocalizations.delegate,
                ...GlobalMaterialLocalizations.delegates,
                GlobalWidgetsLocalizations.delegate,
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
              themeMode: appStore.themeMode,
              theme: somFuturisticTheme(
                brightness: Brightness.light,
                visualDensity: appStore.visualDensity,
              ),
              darkTheme: somFuturisticTheme(
                brightness: Brightness.dark,
                visualDensity: appStore.visualDensity,
              ),
              builder: scrollBehaviour(),
              routerDelegate: routerDelegate,
            ),
          ),
        );
      },
    );
  }

  List<SingleChildWidget> get getProviders {
    return [
      Provider<Openapi>(create: (_) => apiInstance),
      Provider<AuthForgotPasswordPageState>(
        create: (_) => AuthForgotPasswordPageState(apiInstance.getAuthApi()),
      ),
      Provider<BeamerProvidedKey>(create: (_) => beamerKey),
      Provider<Application>(create: (_) => appStore),
      Provider<ApiSubscriptionRepository>(
        create: (_) =>
            ApiSubscriptionRepository(apiInstance.getSubscriptionsApi()),
      ),
      ProxyProvider2<ApiSubscriptionRepository, Openapi, Som>(
        update: (_, apiSubscriptionRepository, api, _) =>
            Som(apiSubscriptionRepository, api.getBranchesApi()),
      ),
      // Som(apiSubscriptionRepository)..populateAvailableSubscriptions()),
      ProxyProvider<Som, RegistrationRequest>(
        update: (_, som, previous) {
          if (previous == null) {
            return RegistrationRequest(
              som,
              apiInstance.getCompaniesApi(),
              appStore,
              sharedPreferences,
            );
          }
          previous.som = som;
          previous.api = apiInstance.getCompaniesApi();
          previous.appStore = appStore;
          return previous;
        },
      ),
      Provider<EmailLoginStore>(
        create: (_) => EmailLoginStore(
          apiInstance.getAuthApi(),
          apiInstance.getUsersApi(),
          appStore,
        ),
      ),
      ProxyProvider<EmailLoginStore, UserAccountConfirmation>(
        update: (_, emailLoginStore, _) => UserAccountConfirmation(
          apiInstance.getAuthApi(),
          appStore,
          emailLoginStore,
        ),
      ),
    ];
  }
}

//region bootstrap

// Must be top-level function
Object? _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future<Object?> parseJson(String text) {
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
