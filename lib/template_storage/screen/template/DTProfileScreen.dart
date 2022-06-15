import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/utils/AppConstant.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';
import 'package:som/template_storage/screen/template/DTAboutScreen.dart';
import 'package:som/template_storage/screen/template/DTPaymentScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../ui/components/MainMenu.dart';
import 'DTNotificationSettingScreen.dart';
import 'DTSecurityScreen.dart';

class DTProfileScreen extends StatefulWidget {
  static String tag = '/DTProfileScreen';

  @override
  DTProfileScreenState createState() => DTProfileScreenState();
}

class DTProfileScreenState extends State<DTProfileScreen> {
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
    Widget profileView() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(profileImage,
                      height: 70, width: 70, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("John", style: primaryTextStyle()),
                  2.height,
                  Text("John@gmail.com", style: primaryTextStyle()),
                ],
              )
            ],
          ),
          IconButton(
            icon: Icon(AntDesign.edit,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ).visible(false)
        ],
      ).paddingAll(16);
    }

    Widget options() {
      return Column(
        children: [
          settingItem(context, 'Notifications', onTap: () {
            DTNotificationSettingScreen().launch(context);
          },
              leading: Icon(MaterialIcons.notifications_none),
              detail: SizedBox()),
          settingItem(context, 'Security', onTap: () {
            DTSecurityScreen().launch(context);
          },
              leading: Icon(MaterialCommunityIcons.shield_check_outline),
              detail: SizedBox()),
          settingItem(context, 'Payments', onTap: () {
            DTPaymentScreen().launch(context);
          }, leading: Icon(MaterialIcons.credit_card), detail: SizedBox()),
          settingItem(context, 'Help', onTap: () {
            launch('https://www.google.com');
          }, leading: Icon(MaterialIcons.help_outline), detail: SizedBox()),
          settingItem(context, 'About', onTap: () {
            DTAboutScreen().launch(context);
          }, leading: Icon(MaterialIcons.info_outline), detail: SizedBox()),
          settingItem(context, 'Theme', onTap: () {
            appStore.toggleDarkMode();
            setState(() {});
          },
              leading: Icon(MaterialCommunityIcons.theme_light_dark),
              detail: SizedBox()),
          settingItem(context, 'Log Out', onTap: () {
            //
          }, detail: SizedBox(), textColor: Theme.of(context).primaryColor),
        ],
      );
    }

    return Observer(
      builder: (_) => Scaffold(
        appBar: appBar(context, 'Profile'),
        drawer: MainMenu(),
        body: ContainerX(
          mobile: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                profileView(),
                Divider(color: Theme.of(context).dividerColor, height: 8)
                    .paddingOnly(top: 4, bottom: 4),
                options(),
              ],
            ),
          ),
          web: Column(
            children: [
              profileView(),
              Divider(height: 8).paddingOnly(top: 4, bottom: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: options(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
