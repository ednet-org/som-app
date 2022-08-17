import 'package:beamer/beamer.dart';

import 'locations/authenticated/authenticated.dart';

final authenticatedPagesDelegate = BeamerDelegate(
  updateParent: false,
  transitionDelegate: const NoAnimationTransitionDelegate(),
  initialPath: '/inquiries',
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      InquiryBeamLocation(),
      AdsBeamLocation(),
      CompanyBeamLocation(),
      StatisticsBeamLocation(),
      UserBeamLocation(),
    ],
  ),
);
