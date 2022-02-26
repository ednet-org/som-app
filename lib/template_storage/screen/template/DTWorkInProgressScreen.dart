import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../ui/pages/customer_registration_page.dart';

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
    return Container(
      alignment: Alignment.center,
      // constraints: dynamicBoxConstraints(),
      // width: context.width() * 0.5,
      // height: context.height(),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 800),
              // decoration: BoxDecoration(
              //     border: Border.all(
              //   color: Col222222222222222ors.lightGreenAccent,
              // )),
              child: Image.asset(
                'images/template_storage/maintenance.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            // bottom: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.005,
            child: Container(
              decoration: boxDecorationRoundedWithShadow(12,
                  backgroundColor:
                      appStore.isDarkModeOn ? Colors.black54 : Colors.white70),
              padding: EdgeInsets.all(30),
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
                              CustomerRegistrationPage().launch(context);
                            },
                          style: primaryTextStyle(color: Colors.blue, size: 24),
                        ),
                        TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                            text: 'so that you can be notified on time.',
                            style: secondaryTextStyle(size: 16)),
                        TextSpan(
                          text: '\n\nThank you for your interest.',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              CustomerRegistrationPage().launch(context);
                            },
                        ),
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
