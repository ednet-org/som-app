import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/integrations/utils/constants.dart';
import 'package:som/template_storage/main/utils/auto_size_text/auto_size_text.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/pages/customer_login_page.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: spacing_large),
              Container(
                alignment: Alignment.center,
                child: Image.asset('images/som/logo.png',
                    height: 150, fit: BoxFit.fitHeight),
              ),
              Text('Smart offer management'.toUpperCase(),
                      style: primaryTextStyle(size: textSizeLarge.toInt()))
                  .paddingOnly(left: 8, top: 20, right: 8, bottom: 20),
              Container(
                width: 800,
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      AutoSizeText.rich(
                        TextSpan(
                            text:
                                'Dear John, \nwe are delighted that Samsung GmbH has placed'
                                'its trust into our product which primary task is to '
                                'help you and your team find new and maintain existing partners.\n\n'
                                'We have sent invitations e-mail to franz.kaufer@som.at where you can click on confirmation'
                                'link in order to activate account and set an user password.'),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                      50.height,
                      ActionButton(
                          textContent: "Close",
                          onPressed: () {
                            CustomerLoginPage()
                                .launch(context, isNewTask: true);
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
