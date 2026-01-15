import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:som/ui/pages/customer/customer_register_page.dart';

class CustomerRegisterPageLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('customer register page'),
        title: 'Register',
        child: CustomerRegisterPage(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/customer/register'];
}
