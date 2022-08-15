import 'package:beamer/beamer.dart';

import 'locations/authenticated/authenticated.dart';

final authenticatedPagesDelegate = BeamerDelegate(
  updateParent: false,
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      AdsBeamLocation(),
      CompanyBeamLocation(),
      InquiryBeamLocation(),
      StatisticsBeamLocation(),
      UserBeamLocation(),
    ],
  ),
);
