import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/payment-interval.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/main.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';
import 'package:som/ui/components/forms/branches.dart';
import 'package:som/ui/components/forms/countries.dart';
import 'package:som/ui/components/forms/som_drop_down.dart';
import 'package:som/ui/components/forms/som_tags.dart';
import 'package:som/ui/components/forms/som_text_input.dart';
import 'package:som/ui/pages/customer/registration/PlanModal.dart';

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
    final customerRegistration = Provider.of<RegistrationRequest>(context);

    return Container(
      child: CustomTheme(
        child: Column(
          children: [
            text('Customer registration'),
            40.height,
            Observer(builder: (_) {
              return Stepper(
                key: Key("mysuperkey-" +
                    assembleSteps(customerRegistration).length.toString()),
                steps: assembleSteps(customerRegistration),
                type: StepperType.vertical,
                currentStep: currStep,
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
                    if (currStep <
                        assembleSteps(customerRegistration).length - 1) {
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

  List<Step> assembleSteps(RegistrationRequest request) {
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
              FormSectionHeader(label: 'General info'),
              SomTextInput(
                label: 'Company name',
                icon: Icons.account_balance,
                hint: 'Enter legal entity name',
                value: request.company.name,
                onChanged: request.company.setName,
              ),
              SomTextInput(
                label: 'UID number',
                icon: Icons.add_link,
                hint: 'Enter UID number',
                value: request.company.uidNr,
                onChanged: request.company.setUidNr,
              ),
              SomTextInput(
                label: 'Registration number',
                icon: Icons.add_link,
                hint: 'describe what is registration number, where to find it?',
                value: request.company.registrationNumber,
                onChanged: request.company.setRegistrationNumber,
              ),
              FormSectionHeader(label: 'Contact details'),
              SomTextInput(
                label: 'Phone number',
                icon: Icons.phone,
                hint: 'Enter phone number',
                value: request.company.phoneNumber,
                onChanged: request.company.setPhoneNumber,
              ),
              SomTextInput(
                label: 'Web',
                icon: Icons.web,
                hint: 'Enter company web address',
                value: request.company.url,
                onChanged: request.company.setUrl,
              ),
              FormSectionHeader(label: 'Company address'),
              SomDropDown(
                value: request.company.address.country,
                onChanged: request.company.address.setCountry,
                hint: 'Select country',
                items: countries,
              ),
              SomTextInput(
                label: 'ZIP',
                hint: 'Enter ZIP',
                autocorrect: false,
                value: request.company.address.zip,
                onChanged: request.company.address.setZip,
              ),
              SomTextInput(
                label: 'City',
                hint: 'Enter city',
                autocorrect: false,
                value: request.company.address.city,
                onChanged: request.company.address.setCity,
              ),
              SomTextInput(
                label: 'Street',
                hint: 'Enter street',
                autocorrect: false,
                value: request.company.address.street,
                onChanged: request.company.address.setStreet,
              ),
              SomTextInput(
                label: 'Number',
                hint: 'Enter number',
                autocorrect: false,
                value: request.company.address.number,
                onChanged: request.company.address.setNumber,
              ),
              FormSectionHeader(label: 'Company branches'),
              SomTags(tags: branchTags.toList()),
            ],
          )),
    ];

    final providerSteps = [
      Step(
        title: Text('Subscription model', style: primaryTextStyle()),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: SubscriptionSelector(),
      ),
      Step(
          title: Text('Payment details', style: primaryTextStyle()),
          isActive: currStep == 3,
          state: StepState.indexed,
          content: Column(
            children: [
              FormSectionHeader(label: 'Bank details'),
              20.height,
              SomTextInput(
                label: 'IBAN',
                icon: Icons.account_balance,
                hint: 'Enter IBAN',
                value: request.company.providerData.bankDetails?.iban,
                onChanged: request.company.providerData.bankDetails?.setIban,
              ),
              SomTextInput(
                label: 'BIC',
                icon: Icons.add_link,
                hint: 'Enter BIC',
                value: request.company.providerData.bankDetails?.bic,
                onChanged: request.company.providerData.bankDetails?.setBic,
              ),
              SomTextInput(
                label: 'Account owner',
                icon: Icons.person,
                hint: 'Enter account owner',
                value: request.company.providerData.bankDetails?.accountOwner,
                onChanged:
                    request.company.providerData.bankDetails?.setAccountOwner,
              ),
              30.height,
              FormSectionHeader(label: 'Payment interval'),
              20.height,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: appStore.textPrimaryColor),
                    child: Radio(
                      value: PaymentInterval.Monthly,
                      groupValue: request.company.providerData.paymentInterval,
                      onChanged: (dynamic value) {
                        toast("$value Selected");

                        request.company.providerData
                            .setPaymentInterval(PaymentInterval.Monthly);
                      },
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        request.company.providerData
                            .setPaymentInterval(PaymentInterval.Monthly);
                      },
                      child: Text(PaymentInterval.Monthly.name,
                          style: primaryTextStyle())),
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: appStore.textPrimaryColor,
                    ),
                    child: Radio(
                      value: PaymentInterval.Yearly,
                      groupValue: request.company.providerData.paymentInterval,
                      onChanged: (dynamic value) {
                        toast("$value Selected");

                        request.company.providerData
                            .setPaymentInterval(PaymentInterval.Yearly);
                      },
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        request.company.providerData
                            .setPaymentInterval(PaymentInterval.Yearly);
                      },
                      child: Text(PaymentInterval.Yearly.name,
                          style: primaryTextStyle()))
                ],
              ),
              50.height,
            ],
          )),
    ];

    final commonSteps = [
      Step(
        title: Text('Users', style: primaryTextStyle()),
        isActive: currStep == 4,
        state: StepState.indexed,
        content: Column(
          children: [
            Text('Admin user'),
            Align(
              alignment: Alignment.bottomLeft,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Container(
                    width: 350,
                    child: SomTextInput(
                      label: 'Admin user email',
                      icon: Icons.email,
                      hint: 'Enter email of SOM administrator account',
                      value: request.company.admin.email,
                      onChanged: request.company.admin.setEmail,
                    ),
                  ),
                  30.width,
                  request.company.canCreateMoreUsers
                      ? Container(
                          width: 60,
                          child: ElevatedButton(
                              onPressed: () =>
                                  request.company.increaseNumberOfUsers(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('+', style: boldTextStyle(size: 24)),
                              )),
                        )
                      : const SizedBox(height: 1),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: request.company.numberOfUsers,
                itemBuilder: (BuildContext context, int index) {
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Container(
                        width: 350,
                        child: SomTextInput(
                          label: 'User ${index + 1}',
                          icon: Icons.email,
                          hint: 'Enter employee email',
                          value: request.company.users[index].email,
                          onChanged: request.company.users[index].setEmail,
                        ),
                      ),
                      30.width,
                      request.company.canCreateMoreUsers
                          ? Container(
                              width: 60,
                              child: ElevatedButton(
                                  onPressed: () =>
                                      request.company.removeUser(index),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('-',
                                        style: boldTextStyle(
                                            size: 24, color: Colors.red)),
                                  )),
                            )
                          : const SizedBox(height: 1),
                    ],
                  );
                }),
          ],
        ),
      ),
    ];

    List<Step> steps = [
      ...buyerSteps,
      ...(request.company.isProvider ? providerSteps : []),
      ...commonSteps,
    ];
    return steps;
  }
}

class SubscriptionSelector extends StatefulWidget {
  SubscriptionSelector({Key? key}) : super(key: key);

  @override
  State<SubscriptionSelector> createState() => _SubscriptionSelectorState();
}

class _SubscriptionSelectorState extends State<SubscriptionSelector> {
  List<PlanModal> periodModal = [];

  int selectIndex = 0;

  int containerIndex = 0;

  Color screenColor = Color(0xFFEBA791);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    periodModal.add(
      PlanModal(
        title: 'SOM Standard',
        subTitle: "€ 39,90 / Monat",
        optionList: [
          PlanModal(title: '1 Benutzer anlegen'),
          PlanModal(title: 'keine Werbeanzeigen bei SOM Ads'),
          PlanModal(
              title:
                  'Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser'),
        ],
        price: '€ 39,90 / Monat + Einrichtungspauschale € 49,-',
      ),
    );
    periodModal.add(PlanModal(
      title: 'SOM Premium',
      subTitle: '€ 79,90 / Monat',
      optionList: [
        PlanModal(title: 'bis zu 5 Benutzer anlegen'),
        PlanModal(
            title:
                '1 Werbeanzeige pro Monat bei SOM Ads für min zwei Wochen (Mo-So)'),
        PlanModal(title: 'Detaillierte Statistik mit Exportmöglichkeit'),
        PlanModal(
            title:
                'Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser'),
        PlanModal(title: 'die ersten zwei Monate Gratis'),
      ],
      price: '€ 79,90 / Monat, Einrichtungspauschale entfällt',
    ));
    periodModal.add(
      PlanModal(
        title: 'SOM Enterprise',
        subTitle: '€ 149,90 / Monat',
        optionList: [
          PlanModal(
              title: 'bis zu 15 Benutzer anlegen',
              subTitle: '(jeder weitere Benutzer kostet €10,-)'),
          PlanModal(
              title:
                  '1 Werbeanzeige pro Monat bei SOM Ads für min zwei Wochen (Mo-So)'),
          PlanModal(
              title: '1 Banneranzeige pro Monatbei SOM Ads für einen Tag'),
          PlanModal(title: 'Detaillierte Statistik mit Exportmöglichkeit'),
          PlanModal(
              title:
                  'Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser'),
          PlanModal(title: 'die ersten zwei Monate Gratis'),
        ],
        price: '€ 149,90 / Monat, Einrichtungspauschale entfällt',
      ),
    );
    setStatusBarColor(Color(0xFFFBC5BB));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                UL(
                  edgeInsets: EdgeInsets.symmetric(horizontal: 16),
                  symbolType: SymbolType.Custom,
                  customSymbol: Container(
                    child: Text('•', style: secondaryTextStyle(size: 20)),
                  ),
                  children: List.generate(
                      periodModal[selectIndex].optionList!.length, (i) {
                    return Text(
                        periodModal[selectIndex]
                            .optionList![i]
                            .title
                            .validate(),
                        style: primaryTextStyle(size: 18));
                  }),
                ),
                10.height,
                Divider(),
                Text(periodModal[selectIndex].price!),
                10.height,
              ],
            )),
        16.height,
        Text('Choose subscription plan',
                style: boldTextStyle(size: 24, color: screenColor))
            .paddingLeft(12.0),
        16.height,
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: periodModal.length,
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            bool value = selectIndex == index;
            return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      value ? screenColor.withOpacity(0.3) : context.cardColor,
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.check,
                            size: 14,
                          ).visible(value).center(),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            shape: BoxShape.circle,
                            border: value
                                ? Border.all(color: Colors.white)
                                : Border.all(color: Colors.blue),
                          ),
                        ),
                        12.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(periodModal[index].title.validate(),
                                style: boldTextStyle(size: 16)),
                            Text(periodModal[index].subTitle.validate(),
                                style: secondaryTextStyle()),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                )).onTap(
              () {
                selectIndex = index;

                setState(() {});
              },
              borderRadius: radius(16),
            ).paddingSymmetric(horizontal: 16, vertical: 4);
          },
        )
      ],
    ).paddingBottom(16);
  }
}

class FormSectionHeader extends StatelessWidget {
  final String label;

  const FormSectionHeader({Key? key, required this.label}) : super(key: key);

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
