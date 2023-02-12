import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/components/high/funny_logo.dart';
import 'package:som/ui/utils/auto_size_text/auto_size_text.dart';

import '../../domain/model/customer_management/registration_request.dart';

class CustomerRegisterSuccessPage extends StatelessWidget {
  const CustomerRegisterSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerRegistration = Provider.of<RegistrationRequest>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                child: const FunnyLogo(),
              ),
              Text('Smart offer management'.toUpperCase(),
                      style: Theme.of(context).textTheme.displayMedium)
                  .paddingOnly(left: 8, top: 20, right: 8, bottom: 20),
              SizedBox(
                width: 800,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      AutoSizeText.rich(
                        style: Theme.of(context).textTheme.bodyLarge,
                        TextSpan(
                            text:
                                'Dear ${customerRegistration.company.admin.firstName}, \nwe are delighted that ${customerRegistration.company.name} has placed'
                                ' its trust into our product which primary task is to '
                                'help you and your team find new and maintain existing partners.\n\n'
                                'We have sent invitations e-mail to ${customerRegistration.company.admin.email} where you can click on confirmation'
                                'link in order to activate account and set an user password.'),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
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
