import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/customer/customer_register_success_page.dart';

class CustomerRegisterSuccessPageLocation extends BeamLocation<BeamState> {
  CustomerRegisterSuccessPageLocation({RouteInformation? routeInformation})
      : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/auth/register-success',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('thank you page'),
        title: 'Thank you',
        child: CustomerRegisterSuccessPage(),
      ),
    ];
  }
}
