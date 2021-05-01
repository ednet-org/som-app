import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'DrawerWidget.dart';

class NoInternetScreen extends StatefulWidget {
  static String tag = 'NoInternetScreen';

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'No Internet'),
      drawer: DrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/noInternet.jpg',
        'No Internet',
        'There is something wrong with the proxy server or the address is incorrect',
        showRetry: true,
        onRetry: () {
          toast('Retrying');
        },
      ),
    );
  }
}
