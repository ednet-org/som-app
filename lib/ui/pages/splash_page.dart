import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../domain/application/application.dart';
import '../domain/model/shared/som.dart';
import '../routes/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    navigationPage();
  }

  Future<void> navigationPage() async {
    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    if (!mounted) return;
    final appStore = Provider.of<Application>(context, listen: false);
    if (appStore.isAuthenticated) {
      context.beamTo(SmartOfferManagementPageLocation());
    } else {
      context.beamTo(AuthLoginPageLocation());
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
                        ? Column(
                            children: [
                              Image.asset(
                                SomAssets.logoPng,
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 20),
                              const CircularProgressIndicator(),
                            ],
                          )
                        : SomSvgIcon(
                            SomAssets.offerStatusAccepted,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "INITIALIZING SYSTEM...",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 2.0),
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
