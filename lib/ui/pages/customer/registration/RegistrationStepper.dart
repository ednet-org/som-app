import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/payment-interval.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/forms/countries.dart';
import 'package:som/ui/components/forms/som_drop_down.dart';
import 'package:som/ui/components/forms/som_tags.dart';
import 'package:som/ui/components/forms/som_text_input.dart';
import 'package:som/ui/pages/customer/registration/FormSectionHeader.dart';
import 'package:som/ui/pages/customer/registration/SubscriptionSelector.dart';

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
    final isLastStep =
        (customerRegistration.company.isProvider && currStep == 5) ||
            (!customerRegistration.company.isProvider && currStep == 2);
    return Container(
      child: Column(
        children: [
          Text(
            'Customer registration',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.7)),
          ),
          40.height,
          Observer(builder: (_) {
            return Stepper(
              elevation: 4,
              key: Key("mysuperkey-" +
                  assembleSteps(customerRegistration).length.toString()),
              steps: assembleSteps(customerRegistration),
              type: StepperType.vertical,
              currentStep: currStep,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return isLastStep
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          200.height,
                          Container(
                            width: 300,
                            child: customerRegistration.isRegistering
                                ? CircularProgressIndicator()
                                : ActionButton(
                                    onPressed: () {
                                      customerRegistration
                                          .registerCustomer(context);
                                    },
                                    textContent: "Register",
                                  ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          customerRegistration.isFailedRegistration
                              ? Text(
                                  customerRegistration.errorMessage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                )
                              : Container()
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          100.height,
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: Text('CONTINUE'),
                          ),
                          50.width,
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: Text('CANCEL'),
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
    );
  }

  List<Step> assembleSteps(RegistrationRequest request) {
    final buyerSteps = [
      Step(
        title: Text('Role selection'),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: RoleSelection(),
      ),
      Step(
          title: Text('Company details'),
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
                required: true,
              ),
              SomTextInput(
                label: 'UID number',
                icon: Icons.add_link,
                hint: 'Enter UID number',
                value: request.company.uidNr,
                onChanged: request.company.setUidNr,
                required: true,
              ),
              SomTextInput(
                label: 'Registration number',
                icon: Icons.add_link,
                hint: 'describe what is registration number, where to find it?',
                value: request.company.registrationNumber,
                onChanged: request.company.setRegistrationNumber,
                required: true,
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
                required: true,
              ),
              SomTextInput(
                label: 'City',
                hint: 'Enter city',
                autocorrect: false,
                value: request.company.address.city,
                onChanged: request.company.address.setCity,
                required: true,
              ),
              SomTextInput(
                label: 'Street',
                hint: 'Enter street',
                autocorrect: false,
                value: request.company.address.street,
                onChanged: request.company.address.setStreet,
                required: true,
              ),
              SomTextInput(
                label: 'Number',
                hint: 'Enter number',
                autocorrect: false,
                value: request.company.address.number,
                onChanged: request.company.address.setNumber,
                required: true,
              ),
            ],
          )),
    ];
    final providerSteps = [
      Step(
        title: Text('Company branches'),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: SomTags(tags: request.som.availableBranches),
      ),
      Step(
        title: Text('Subscription model'),
        isActive: currStep == 3,
        state: StepState.indexed,
        content: SubscriptionSelector(),
      ),
      Step(
          title: Text('Payment details'),
          isActive: currStep == 4,
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
                required: true,
              ),
              SomTextInput(
                label: 'BIC',
                icon: Icons.add_link,
                hint: 'Enter BIC',
                value: request.company.providerData.bankDetails?.bic,
                onChanged: request.company.providerData.bankDetails?.setBic,
                required: true,
              ),
              SomTextInput(
                label: 'Account owner',
                icon: Icons.person,
                hint: 'Enter account owner',
                value: request.company.providerData.bankDetails?.accountOwner,
                onChanged:
                    request.company.providerData.bankDetails?.setAccountOwner,
                required: true,
              ),
              30.height,
              FormSectionHeader(label: 'Payment interval'),
              20.height,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Radio(
                    value: PaymentInterval.Monthly,
                    groupValue: request.company.providerData.paymentInterval,
                    onChanged: (dynamic value) {
                      toast("$value Selected");

                      request.company.providerData
                          .setPaymentInterval(PaymentInterval.Monthly);
                    },
                  ),
                  GestureDetector(
                      onTap: () {
                        request.company.providerData
                            .setPaymentInterval(PaymentInterval.Monthly);
                      },
                      child: Text(PaymentInterval.Monthly.name)),
                  Radio(
                    value: PaymentInterval.Yearly,
                    groupValue: request.company.providerData.paymentInterval,
                    onChanged: (dynamic value) {
                      toast("$value Selected");

                      request.company.providerData
                          .setPaymentInterval(PaymentInterval.Yearly);
                    },
                  ),
                  GestureDetector(
                      onTap: () {
                        request.company.providerData
                            .setPaymentInterval(PaymentInterval.Yearly);
                      },
                      child: Text(PaymentInterval.Yearly.name))
                ],
              ),
              50.height,
            ],
          )),
    ];

    final commonSteps = [
      Step(
        title: Text('Users'),
        isActive: currStep == 5,
        state: StepState.indexed,
        content: Column(
          children: [
            Text('Admin user'),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
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
                                    child: Text('+'),
                                  )),
                            )
                          : const SizedBox(height: 1),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 350,
                    child: SomTextInput(
                      label: 'Salutation',
                      value: request.company.admin.salutation,
                      onChanged: request.company.admin.setSalutation,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 350,
                    child: SomTextInput(
                      label: 'Title',
                      value: request.company.admin.title,
                      onChanged: request.company.admin.setTitle,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 350,
                    child: SomTextInput(
                      label: 'First name',
                      value: request.company.admin.firstName,
                      onChanged: request.company.admin.setFirstName,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 350,
                    child: SomTextInput(
                      label: 'Last name',
                      value: request.company.admin.lastName,
                      onChanged: request.company.admin.setLastName,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 350,
                    child: SomTextInput(
                      label: 'Phone number',
                      value: request.company.admin.phone,
                      onChanged: request.company.admin.setPhone,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: request.company.numberOfUsers,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Wrap(
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
                                        child: Text('-'),
                                      )),
                                )
                              : const SizedBox(height: 1),
                        ],
                      ),
                      Container(
                        width: 350,
                        child: SomTextInput(
                          label: 'First name',
                          value: request.company.users[index].firstName,
                          onChanged: request.company.users[index].setFirstName,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 350,
                        child: SomTextInput(
                          label: 'Salutation',
                          value: request.company.users[index].salutation,
                          onChanged: request.company.users[index].setSalutation,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 350,
                        child: SomTextInput(
                          label: 'Title',
                          value: request.company.users[index].title,
                          onChanged: request.company.users[index].setTitle,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 350,
                        child: SomTextInput(
                          label: 'First name',
                          value: request.company.users[index].firstName,
                          onChanged: request.company.users[index].setFirstName,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 350,
                        child: SomTextInput(
                          label: 'Last name',
                          value: request.company.users[index].lastName,
                          onChanged: request.company.users[index].setLastName,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 350,
                        child: SomTextInput(
                          label: 'Phone number',
                          value: request.company.users[index].phone,
                          onChanged: request.company.users[index].setPhone,
                        ),
                      ),
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
