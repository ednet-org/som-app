import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/application/customer-store.dart';
import 'package:som/main.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

import 'RoleSelection.dart';

class RegistrationStepper extends StatefulWidget {
  @override
  _RegistrationStepperState createState() => _RegistrationStepperState();
}

class _RegistrationStepperState extends State<RegistrationStepper> {
  int currStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerStore = Provider.of<CustomerStore>(context);

    return Container(
      child: CustomTheme(
        child: Column(
          children: [
            text('Customer registration'),
            40.height,
            Observer(builder: (_) {
              return Stepper(
                key: Key("mysuperkey-" +
                    assembleSteps(customerStore).length.toString()),
                steps: assembleSteps(customerStore),
                type: StepperType.vertical,
                currentStep: this.currStep,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      100.height,
                      TextButton(
                        onPressed: details.onStepContinue,
                        child: Text('CONTINUE',
                            style: secondaryTextStyle(color: actionColor)),
                      ),
                      50.width,
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: Text('CANCEL', style: secondaryTextStyle()),
                      ),
                    ],
                  );
                },
                onStepContinue: () {
                  setState(() {
                    if (currStep < assembleSteps(customerStore).length - 1) {
                      currStep = currStep + 1;
                    } else {
                      //currStep = 0;
                      finish(context);
                    }
                  });
                },
                onStepCancel: () {
                  finish(context);
                  setState(() {
                    if (currStep > 0) {
                      currStep = currStep - 1;
                    } else {
                      currStep = 0;
                    }
                  });
                },
                onStepTapped: (step) {
                  setState(() {
                    currStep = step;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Step> assembleSteps(CustomerStore customerStore) {
    final buyerSteps = [
      Step(
        title: Text('Role selection', style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: RoleSelection(),
      ),
      Step(
          title: Text('Company details', style: primaryTextStyle()),
          isActive: currStep == 1,
          state: StepState.indexed,
          content: Column(
            children: [
              Separator(label: 'General info'),
              FormField(
                label: 'Company name',
                icon: Icons.account_balance,
                hint: 'Enter legal entity name',
              ),
              FormField(
                label: 'UID number',
                icon: Icons.add_link,
                hint: 'Enter UID number',
              ),
              FormField(
                label: 'Registration number',
                icon: Icons.add_link,
                hint: 'describe what is registration number, where to find it?',
              ),
              Separator(label: 'Contact details'),
              FormField(
                label: 'Phone number',
                icon: Icons.phone,
                hint: 'Enter phone number',
              ),
              FormField(
                label: 'Email',
                icon: Icons.email,
                hint: 'Which email we want here?',
              ),
              FormField(
                label: 'Web',
                icon: Icons.web,
                hint: 'Enter company web address',
              ),
              Separator(label: 'Company address'),
              FormField(
                label: 'Country',
                hint: 'Enter country',
                icon: Icons.edit_location,
                autocorrect: false,
              ),
              FormField(
                label: 'ZIP',
                hint: 'Enter ZIP',
                autocorrect: false,
              ),
              FormField(
                label: 'City',
                hint: 'Enter city',
                autocorrect: false,
              ),
              FormField(
                label: 'Street',
                hint: 'Enter street',
                autocorrect: false,
              ),
              FormField(
                label: 'Number',
                hint: 'Enter number',
                autocorrect: false,
              ),
            ],
          )),
    ];

    final providerSteps = [
      Step(
        title: Text('Subscription model', style: primaryTextStyle()),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: Text("Add your image", style: primaryTextStyle()),
      ),
      Step(
          title: Text('Payment details', style: primaryTextStyle()),
          isActive: currStep == 3,
          state: StepState.indexed,
          content: Column(
            children: [
              FormField(
                label: 'IBAN',
                icon: Icons.account_balance,
                hint: 'Enter IBAN',
              ),
              FormField(
                label: 'BIC',
                icon: Icons.add_link,
                hint: 'Enter BIC',
              ),
              FormField(
                label: 'Account owner',
                icon: Icons.person,
                hint: 'Enter account owner',
              )
            ],
          )),
    ];

    final commonSteps = [
      Step(
        title: Text('Users', style: primaryTextStyle()),
        isActive: currStep == 4,
        state: StepState.indexed,
        content: Column(
          children: const [
            Text('Admin user'),
            FormField(
              label: 'Admin user email',
              icon: Icons.email,
              hint: 'Enter email of SOM administrator account',
            ),
            FormField(
              label: 'Password for SOM administrator account',
              icon: Icons.lock,
              hint: 'Enter password',
              obscureText: true,
            ),
          ],
        ),
      ),
    ];

    List<Step> steps = [
      ...buyerSteps,
      ...(customerStore.isProvider ? providerSteps : []),
      ...commonSteps,
    ];
    return steps;
  }
}

class FormField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? hint;
  final bool obscureText;
  final int maxLines;
  final bool autocorrect;
  final TextInputType? keyboardType;

  const FormField({
    Key? key,
    this.label,
    this.icon,
    this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: primaryTextStyle(),
      obscureText: obscureText,
      autocorrect: autocorrect,
      decoration: InputDecoration(
        labelText: label,
        hintStyle: secondaryTextStyle(),
        labelStyle: secondaryTextStyle(),
        hintText: hint,
        icon: Icon(icon, color: appStore.iconColor),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  final String label;

  const Separator({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        40.height,
        Text(label, style: secondaryTextStyle()),
      ],
    );
  }
}
