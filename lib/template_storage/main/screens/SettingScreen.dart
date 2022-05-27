import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:som/main.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/main/utils/AppConstant.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Settings', style: boldTextStyle(size: 22)),
          backgroundColor: appStore.appBarColor,
          leading: BackButton(
            color: appStore.textPrimaryColor,
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingItemWidget(
                    leading: Image.asset('images/app/ic_documentation.png',
                        height: 24, width: 24, color: appColorPrimary),
                    title: 'Documentation',
                    onTap: () {
                      launch(DocumentationUrl,
                          forceWebView: true, enableJavaScript: true);
                    },
                  ),
                  SettingItemWidget(
                    title: "Change Logs",
                    onTap: () async {
                      launch(ChangeLogsUrl,
                          forceWebView: true, enableJavaScript: true);
                    },
                    leading: Image.asset('images/app/ic_change_log.png',
                        height: 24, width: 24, color: appColorPrimary),
                  ),
                  SettingItemWidget(
                    title: "Share App",
                    onTap: () async {
                      PackageInfo.fromPlatform().then((value) async {
                        String package = value.packageName;
                        await Share.share(
                            'Download $mainAppName from Play Store\n\n\n$PlayStoreUrl$package');
                      });
                    },
                    leading: Image.asset('images/app/ic_share.png',
                        height: 24, width: 24, color: appColorPrimary),
                  ),
                  SettingItemWidget(
                    title: "Rate us",
                    onTap: () {
                      PackageInfo.fromPlatform().then((value) async {
                        String package = value.packageName;
                        launch('$PlayStoreUrl$package');
                      });
                    },
                    leading: Image.asset('images/app/ic_rate_app.png',
                        height: 24, width: 24, color: appColorPrimary),
                  ),
                  SettingItemWidget(
                    title: "Dark Mode",
                    onTap: () {
                      appStore.toggleDarkMode();
                    },
                    leading: Image.asset('images/app/ic_theme.png',
                        height: 24, width: 24, color: appColorPrimary),
                    trailing: Switch(
                      value: appStore.isDarkModeOn,
                      onChanged: (s) {
                        appStore.toggleDarkMode(value: s);
                      },
                    ).withHeight(24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
