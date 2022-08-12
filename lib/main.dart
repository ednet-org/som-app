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
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/core/model/login/email_login_store.dart';
import 'package:som/domain/infrastructure/repository/api/lib/api_subscription_repository.dart';
import 'package:som/domain/infrastructure/repository/api/utils/interceptors/dio_cors_interceptor.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/domain/model/shared/som.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/pages/customer/registration/thank_you_page.dart';
import 'package:som/ui/pages/splash_page.dart';
import 'package:som/ui/pages/verify_email.dart';
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
      ..interceptors.add(PrettyDioLogger())
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
  appStore.toggleDarkMode();
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
  final routerDelegate = BeamerDelegate(
    initialPath: "/",
    // locationBuilder: RoutesLocationBuilder(
    //   routes: {
    //     '/': (context, state, data) => SplashPage(appStore),
    //     '/register': (context, state, data) => const CustomerRegistrationPage(),
    //     '/login': (context, state, data) => Login(),
    //     '/dashboard': (context, state, data) => DashboardPage(),
    //   },
    // ),
    locationBuilder: (routeInformation, _) {
      final route = routeInformation.location;

      if (route != null && route.contains('confirmEmail')) {
        return EmailVerificationLocation(routeInformation);
      } else {
        return HomeLocation();
      }
      // switch (routeInformation.path) {
      //   case '/':
      //     return [
      //       HomeLocation(
      //           key: ValueKey('SplashPage'), child: SplashPage(appStore))
      //     ];
      //   default:
      //     return const SplashPage(appStore);
      // }
    },
  );

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
        builder: (_) => MaterialApp.router(
          routeInformationParser: BeamerParser(),
          routerDelegate: routerDelegate,
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
          // home: VerifyEmailPage(),
          themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          builder: scrollBehaviour(),
        ),
      ),
    );
  }
}

class EmailVerificationState extends ChangeNotifier
    with RouteInformationSerializable {
  EmailVerificationState([String? token, String? email])
      : _token = token,
        _email = email;

  String? _token;
  String? _email;

  set email(String? email) {
    if (email != null) {
      _email = email;
      notifyListeners();
    }
  }

  String? get email => _email;

  String? get token => _token;

  set token(String? token) {
    if (token != null) {
      _token = token;
      notifyListeners();
    }
  }

  @override
  fromRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '/');
    if (uri.pathSegments.isNotEmpty) {
      _token = uri.queryParameters['token'];
      _email = uri.queryParameters['email'];
    }
    return this;
  }

  @override
  RouteInformation toRouteInformation() {
    String uriString = 'auth/confirmEmail';
    if (_token != null) {
      uriString += '?token=$_token';
    }
    if (_email != null) {
      uriString += '&?email=$_email';
    }
    return RouteInformation(location: uriString.isEmpty ? '/' : uriString);
  }

  void updateWith(String token, String email) {
    _token = token;
    _email = email;
    notifyListeners();
  }
}

class EmailVerificationLocation extends BeamLocation<EmailVerificationState> {
  EmailVerificationLocation(RouteInformation? routeInformation)
      : super(routeInformation);

  @override
  EmailVerificationState createState(RouteInformation routeInformation) =>
      EmailVerificationState().fromRouteInformation(routeInformation);

  @override
  void initState() {
    super.initState();
    state.addListener(notifyListeners);
  }

  @override
  void updateState(RouteInformation routeInformation) {
    final emailVerificationState =
        EmailVerificationState().fromRouteInformation(routeInformation);
    state.updateWith(
        emailVerificationState.email, emailVerificationState.token);
  }

  @override
  void disposeState() {
    super.disposeState();
    state.removeListener(notifyListeners);
  }

  @override
  List<Pattern> get pathPatterns => ['/auth/confirmEmail'];

  @override
  List<BeamPage> buildPages(
      BuildContext context, EmailVerificationState state) {
    return [
      BeamPage(
        key: ValueKey('verify-email'),
        title: 'Verify Email',
        child: VerifyEmailPage(state.token, state.email),
      ),
    ];
  }
}

class HomeLocation extends BeamLocation<BeamState> {
  HomeLocation({RouteInformation? routeInformation}) : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('home'),
        title: 'Home',
        child: SplashPage(appStore),
      ),
      // if (state.uri.pathSegments.contains('books'))
      //   BeamPage(
      //     key: ValueKey('books'),
      //     title: 'Books',
      //     child: BooksScreen(),
      //   ),
      // if (state.pathParameters.containsKey('bookId'))
      //   BeamPage(
      //     key: ValueKey('book-${state.pathParameters['bookId']}'),
      //     title: books.firstWhere(
      //         (book) => book['id'] == state.pathParameters['bookId'])['title'],
      //     child: BookDetailsScreen(
      //       book: books.firstWhere(
      //           (book) => book['id'] == state.pathParameters['bookId']),
      //     ),
      //   ),
    ];
  }
}

class ThankYouPageLocation extends BeamLocation<BeamState> {
  ThankYouPageLocation({RouteInformation? routeInformation})
      : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/auth/register/success',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('thank you page'),
        title: 'Thank you',
        child: ThankYouPage(),
      ),
      // if (state.uri.pathSegments.contains('books'))
      //   BeamPage(
      //     key: ValueKey('books'),
      //     title: 'Books',
      //     child: BooksScreen(),
      //   ),
      // if (state.pathParameters.containsKey('bookId'))
      //   BeamPage(
      //     key: ValueKey('book-${state.pathParameters['bookId']}'),
      //     title: books.firstWhere(
      //         (book) => book['id'] == state.pathParameters['bookId'])['title'],
      //     child: BookDetailsScreen(
      //       book: books.firstWhere(
      //           (book) => book['id'] == state.pathParameters['bookId']),
      //     ),
      //   ),
    ];
  }
}
