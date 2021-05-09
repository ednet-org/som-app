import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'DTDrawerWidget.dart';

class DTNoInternetScreen extends StatefulWidget {
  static String tag = '/DTNoInternetScreen';

  @override
  DTNoInternetScreenState createState() => DTNoInternetScreenState();
}

class DTNoInternetScreenState extends State<DTNoInternetScreen> {
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
      drawer: DTDrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/noInternet.jpg',
        'Not implemented',
        'This is embarrassing, you keep clicking around and I have nothing to show ',
        showRetry: true,
        onRetry: () {
          toast('Retrying');
        },
      ),
    );
  }
}
