import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/app/DashboardScreen.dart';
import 'package:som/main/screens/ProKitLauncher.dart';
import 'package:som/main/utils/AppConstant.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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
    DashboardScreen().launch(context, isNewTask: true);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D2939),
      body: Container(
        alignment: Alignment.center,
        child: Image.asset('images/som/logo.png', height: 300, fit: BoxFit.fitHeight),
      ),
    );
  }
}
