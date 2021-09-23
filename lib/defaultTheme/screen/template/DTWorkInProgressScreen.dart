import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/screen/customer/Login.dart';
import 'package:som/main/utils/AppWidget.dart';

import '../../../main.dart';

class DTWorkInProgressScreen extends StatefulWidget {
  @override
  _DTWorkInProgressScreenState createState() => _DTWorkInProgressScreenState();
}

class _DTWorkInProgressScreenState extends State<DTWorkInProgressScreen> {
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
    print(context.width());
    return Container(
      constraints: dynamicBoxConstraints(),
      height: context.height(),
      child: Stack(
        children: [
          Positioned(
            left: 1,
            top: 1,
            child: Image.asset(
              'images/defaultTheme/maintenance.png',
              width: context.width(),
              fit: BoxFit.scaleDown,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 20,
            child: Container(
              decoration: boxDecorationRoundedWithShadow(12,
                  backgroundColor:
                      appStore.isDarkModeOn ? Colors.black54 : Colors.white70),
              padding: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'This app is currently being developed but we encourage you to ',
                            style: secondaryTextStyle(size: 16)),
                        TextSpan(
                          text: 'Sign Up',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              DTSignUpScreen().launch(context);
                            },
                          style: primaryTextStyle(color: Colors.blue, size: 24),
                        ),
                        TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                            text:
                                'so that you can be notified when lunch is ready, Thank you for your interest.',
                            style: secondaryTextStyle(size: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).center();
  }
}
