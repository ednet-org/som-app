import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'defaultTheme/screen/DTDashboardScreen.dart';
import 'main/store/AppStore.dart';
import 'main/utils/AppTheme.dart';
/// This variable is used to get dynamic colors when theme mode is changed
AppStore appStore = AppStore();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DTDashboardScreen(),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
      ),
    );
  }
}
