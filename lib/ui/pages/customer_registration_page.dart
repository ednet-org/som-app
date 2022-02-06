import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/screen/template/DTSignInScreen.dart';
import 'package:som/ui/components/layout/MainBody.dart';
import 'package:som/ui/pages/customer/registration/Registration.dart';

class CustomerRegistrationPage extends StatefulWidget {
  static String tag = '/CustomerRegistrationPage';

  @override
  State<CustomerRegistrationPage> createState() =>
      _CustomerRegistrationPageState();
}

class _CustomerRegistrationPageState extends State<CustomerRegistrationPage> {
  int currStep = 1;

  @override
  Widget build(BuildContext context) {
    List<Step> mSteps = [
      Step(
          title: Text("Kole selection"),
          content: Text("ROLE",
              style: secondaryTextStyle(color: appStore.textSecondaryColor)),
          isActive: currStep == 0,
          state: StepState.complete),
      Step(
          title: Text("Company details"),
          content: Text("COMPANY",
              style: secondaryTextStyle(color: appStore.textSecondaryColor)),
          isActive: currStep == 1,
          state: StepState.disabled),
      Step(
          title: Text("Subscription model"),
          content: Text("SUBSCRIPTION",
              style: secondaryTextStyle(color: appStore.textSecondaryColor)),
          isActive: currStep == 2,
          state: StepState.disabled),
      Step(
          title: Text("Bank details"),
          content: Text("BANK",
              style: secondaryTextStyle(color: appStore.textSecondaryColor)),
          isActive: currStep == 3,
          state: StepState.disabled),
      Step(
          title: Text("USER"),
          content: Text("USER",
              style: secondaryTextStyle(color: appStore.textSecondaryColor)),
          isActive: currStep == 4,
          state: StepState.disabled),
    ];

    return Scaffold(
      body: MainBody(
        child: Stepper(
          steps: mSteps,
          type: StepperType.horizontal,
          currentStep: this.currStep,
          controlsBuilder: (BuildContext context,
              {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  onPressed: onStepContinue,
                  child: Text('CONTINUE', style: secondaryTextStyle()),
                ),
                10.width,
                TextButton(
                  onPressed: onStepCancel,
                  child: Text('CANCEL', style: secondaryTextStyle()),
                ),
              ],
            );
          },
          onStepContinue: () {
            setState(() {
              if (currStep < mSteps.length - 1) {
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
        ).center(),
      ),
    );
  }

  previousSolution(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Registration(),
        20.height,
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: appColorPrimary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: defaultBoxShadow()),
          child: Text('Register man',
              style: boldTextStyle(color: white, size: 18)),
        ).onTap(() {
          finish(context);
        }),
        20.height,
        Text('Already Registered?',
            style: boldTextStyle(
              color: appColorPrimary,
            )).center().onTap(() {
          DTSignInScreen().launch(context);
        }),
      ],
    );
  }
}
