import 'package:beamer/beamer.dart';
import 'package:som/routes/locations/auth/auth_confirm_email_page_location.dart';
import 'package:som/routes/locations/auth/auth_login_page_location.dart';
import 'package:som/routes/locations/splash_page_beam_location.dart';

final rootBeamerDelegate = (beamerKey) => BeamerDelegate(
    initialPath: '/splash',
    routeListener: (routeInformation, _) =>
        print('root: ${routeInformation.location}'),
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        SplashPageBeamLocation(),
        AuthLoginPageLocation(),
        AuthConfirmEmailPageLocation(),
      ],
    ));
