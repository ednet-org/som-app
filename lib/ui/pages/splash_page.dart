import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/shared/som.dart';
import 'package:som/routes/beamer_provided_key.dart';
import 'package:som/routes/locations/auth/auth_login_page_location.dart';
import 'package:som/routes/locations/authenticated/smart_offer_management_page_location.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/utils/AppConstant.dart';

class SplashPage extends StatefulWidget {
  static String tag = '/SplashScreen';

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    navigationPage();
  }

  void navigationPage() async {
    setValue(appOpenCount, (getIntAsync(appOpenCount)) + 1);

    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    final appStore = Provider.of<Application>(context, listen: false);
    if (!appStore.isAuthenticated) {
      context.beamTo(AuthLoginPageLocation());
    } else {
      context.beamTo(SmartOfferManagementPageLocation());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Som som = Provider.of<Som>(context);
    final appStore = Provider.of<Application>(context);
    final beamerKey = Provider.of<BeamerProvidedKey>(context);
    return Observer(
      builder: (_) => !appStore.isAuthenticated
          ? Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: som.isLoadingData
                        ? Image.asset(
                            'images/som/logo.png',
                            height: 300,
                            fit: BoxFit.fitHeight,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Icon(
                            Icons.check_circle_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 300,
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
            )
          : Beamer(
              key: beamerKey,
              routerDelegate: beamerKey.currentState!.routerDelegate,
            ),
    );
  }
}
