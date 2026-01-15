import 'package:beamer/beamer.dart';

import 'locations/authenticated/authenticated.dart';

//todo: implement guards
final authenticatedPagesDelegate = BeamerDelegate(
  updateParent: false,
  transitionDelegate: const NoAnimationTransitionDelegate(),
  initialPath: '/inquiries',
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      InquiryBeamLocation(),
      AdsBeamLocation(),
      CompanyBeamLocation(),
      CompaniesBeamLocation(),
      BranchesBeamLocation(),
      ConsultantsBeamLocation(),
      ProvidersBeamLocation(),
      SubscriptionsBeamLocation(),
      StatisticsBeamLocation(),
      UserBeamLocation(),
    ],
  ),
);
