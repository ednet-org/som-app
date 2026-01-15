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
      OffersBeamLocation(),
      AdsBeamLocation(),
      AuditBeamLocation(),
      CompanyBeamLocation(),
      CompaniesBeamLocation(),
      BranchesBeamLocation(),
      ConsultantsBeamLocation(),
      ProvidersBeamLocation(),
      RolesBeamLocation(),
      SubscriptionsBeamLocation(),
      StatisticsBeamLocation(),
      UserBeamLocation(),
    ],
  ),
);
