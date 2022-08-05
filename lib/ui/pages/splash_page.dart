import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/store/application.dart';
import 'package:som/ui/pages/customer_login_page.dart';
import 'package:som/ui/utils/AppConstant.dart';

import 'dashboard_page.dart';

class SplashPage extends StatefulWidget {
  static String tag = '/SplashScreen';
  Application appStore;

  SplashPage(this.appStore);

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

    await Future.delayed(Duration(seconds: 3));

    if (!widget.appStore.isAuthenticated) {
      return CustomerLoginPage().launch(context);
    }
    return DashboardPage().launch(context);
  }

  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => !widget.appStore.isAuthenticated
          ? Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              body: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/som/logo.png',
                  height: 300,
                  fit: BoxFit.fitHeight,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            )
          : DashboardPage(),
    );
  }
}
