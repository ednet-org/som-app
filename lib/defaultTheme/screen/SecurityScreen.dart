import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main/utils/AppWidget.dart';

import 'ChangePasswordScreen.dart';
import 'DrawerWidget.dart';

class SecurityScreen extends StatefulWidget {
  static String tag = 'SecurityScreen';

  @override
  SecurityScreenState createState() => SecurityScreenState();
}

class SecurityScreenState extends State<SecurityScreen> {
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
      appBar: appBar(context, 'Security'),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          settingItem(context, 'Change Password', onTap: () {
            ChangePasswordScreen().launch(context);
          }, leading: Icon(AntDesign.lock), detail: SizedBox()),
        ],
      ),
    );
  }
}
