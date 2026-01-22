import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/som_application.dart';

class SmartOfferManagementPageLocation extends BeamLocation<BeamState> {
  SmartOfferManagementPageLocation({RouteInformation? routeInformation})
      : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('smart offer management page'),
        title: 'Smart Offer Management',
        child: SomApplication(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
    '/',
    '/inquiries',
    '/inquiries/:inquiryId',
    '/offers',
    '/offers/:offerId',
    '/ads',
    '/ads/:adId',
    '/branches',
    '/branches/:branchId',
    '/consultants',
    '/providers',
    '/providers/:companyId',
    '/companies',
    '/companies/:companyId',
    '/subscriptions',
    '/subscriptions/:planId',
    '/roles',
    '/audit',
    '/statistics',
    '/user',
  ];
}
