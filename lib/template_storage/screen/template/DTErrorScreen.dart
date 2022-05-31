import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/ui/components/utils/DTWidgets.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

import '../../../ui/components/MainMenu.dart';

class DTErrorScreen extends StatefulWidget {
  static String tag = '/DTErrorScreen';

  @override
  DTErrorScreenState createState() => DTErrorScreenState();
}

class DTErrorScreenState extends State<DTErrorScreen> {
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
      appBar: appBar(context, 'Error'),
      drawer: MainMenu(),
      body: errorWidget(
        context,
        'images/template_storage/error.png',
        'Error!',
        'Something went wrong. Please try again later',
        showRetry: true,
        onRetry: () {
          toast('Retrying');
        },
      ),
    );
  }
}
