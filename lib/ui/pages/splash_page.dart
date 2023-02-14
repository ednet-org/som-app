import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../domain/app_config/application.dart';
import '../domain/model/shared/som.dart';
import '../routes/routes.dart';

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
    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    final appStore = Provider.of<Application>(context, listen: false);
    if (appStore.isAuthenticated) {
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
                          )
                        : const Icon(
                            Icons.check_circle_outlined,
                            size: 300,
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.titleSmall,
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
