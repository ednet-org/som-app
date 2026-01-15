import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/pages/customer/registration/form_section_header.dart';
import 'package:som/ui/pages/customer/registration/subscription_selector.dart';

import '../../../domain/application/application.dart';
import '../../../domain/model/model.dart';
import '../../../routes/routes.dart';
import 'role_selection.dart';

class RegistrationStepper extends StatefulWidget {
  const RegistrationStepper({Key? key}) : super(key: key);

  @override
  _RegistrationStepperState createState() => _RegistrationStepperState();
}

const List<String> _companySizeOptions = [
  '0-10',
  '11-50',
  '51-100',
  '101-250',
  '251-500',
  '500+',
];

const List<String> _providerTypeOptions = [
  'haendler',
  'hersteller',
  'dienstleister',
  'grosshaendler',
];

List<CompanyRole> _allowedUserRoles(Company company) {
  final roles = <CompanyRole>[CompanyRole.admin];
  if (company.isBuyer) {
    roles.add(CompanyRole.buyer);
  }
  if (company.isProvider) {
    roles.add(CompanyRole.provider);
  }
  return roles;
}

String _roleLabel(CompanyRole role) {
  switch (role) {
    case CompanyRole.admin:
      return 'Admin';
    case CompanyRole.provider:
      return 'Provider';
    case CompanyRole.buyer:
      return 'Buyer';
  }
}

class _RegistrationStepperState extends State<RegistrationStepper> {
  int currStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = Provider.of<RegistrationRequest>(context, listen: false);
      request.som.populateAvailableBranches();
      request.som.populateAvailableSubscriptions();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerRegistration = Provider.of<RegistrationRequest>(context);
    final appStore = Provider.of<Application>(context);
    final isLastStep =
        (customerRegistration.company.isProvider && currStep == 5) ||
            (!customerRegistration.company.isProvider && currStep == 2);
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          'Customer registration'.toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        40.height,
        Observer(builder: (_) {
          return Column(
            children: [
              Stepper(
                elevation: 40,
                key: Key(
                    "mysuperkey-${assembleSteps(customerRegistration, appStore).length}"),
                steps: assembleSteps(customerRegistration, appStore),
                type: StepperType.vertical,
                currentStep: currStep,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Column(children: [
                    isLastStep
                        ? Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  200.height,
                                  SizedBox(
                                    width: 300,
                                    child: customerRegistration.isRegistering
                                        ? const Center(
                                            child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : !customerRegistration.isSuccess
                                            ? ActionButton(
                                                onPressed: () async {
                                                  final beamer =
                                                      Beamer.of(context);

                                                  await customerRegistration
                                                      .registerCustomer();

                                                  beamer.beamTo(
                                                      CustomerRegisterSuccessPageLocation());
                                                },
                                                textContent: "Register",
                                              )
                                            : Container(),
                                  ),
                                ],
                              ),
                              customerRegistration.isSuccess
                                  ? Icon(
                                      Icons.check_circle_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 7,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              100.height,
                              TextButton(
                                onPressed: details.onStepContinue,
                                child: const Text('CONTINUE'),
                              ),
                              50.width,
                              TextButton(
                                onPressed: details.onStepCancel,
                                child: const Text('BACK'),
                              ),
                            ],
                          ),
                  ]);
                },
                onStepContinue: () {
                  setState(() {
                    if (currStep <
                        assembleSteps(customerRegistration, appStore).length -
                            1) {
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
                      context.beamTo(AuthLoginPageLocation());
                    }
                  });
                },
                onStepTapped: (step) {
                  setState(() {
                    currStep = step;
                  });
                },
              ),
              customerRegistration.isFailedRegistration
                  ? Text(
                      customerRegistration.errorMessage,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.error),
                    )
                  : Container()
            ],
          );
        }),
      ],
    );
  }

  List<Step> assembleSteps(RegistrationRequest request, Application appStore) {
    final buyerSteps = [
      Step(
        title: stepTitle('Role selection'),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: const RoleSelection(),
      ),
      Step(
          title: stepTitle('Company details'),
          isActive: currStep == 1,
          state: StepState.indexed,
          content: Column(
            children: [
              const FormSectionHeader(label: 'General info'),
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
              SomDropDown(
                value: request.company.companySize,
                onChanged: request.company.setCompanySize,
                hint: 'Select company size',
                label: 'Number of employees',
                items: _companySizeOptions,
              ),
              const FormSectionHeader(label: 'Contact details'),
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
              const FormSectionHeader(label: 'Company address'),
              SomDropDown(
                value: request.company.address.country,
                onChanged: request.company.address.setCountry,
                hint: 'Select country',
                label: 'Country',
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
        title: stepTitle('Company branches'),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SomTags(
              tags: request.som.availableBranches,
              selectedTags: request.som.requestedBranches,
              onAdd: request.som.requestBranch,
              onRemove: request.som.removeRequestedBranch,
            ),
            const SizedBox(height: 20),
            SomDropDown(
              value: request.company.providerData.providerType,
              onChanged: request.company.providerData.setProviderType,
              hint: 'Select provider type',
              label: 'Provider type',
              items: _providerTypeOptions,
            ),
          ],
        ),
      ),
      Step(
        title: stepTitle('Subscription model'),
        isActive: currStep == 3,
        state: StepState.indexed,
        content: const SubscriptionSelector(),
      ),
      Step(
          title: stepTitle('Payment details'),
          isActive: currStep == 4,
          state: StepState.indexed,
          content: Column(
            children: [
              const FormSectionHeader(label: 'Bank details'),
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
              const FormSectionHeader(label: 'Payment interval'),
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
        title: stepTitle('Users'),
        isActive: currStep == 5,
        state: StepState.indexed,
        content: Column(
          children: [
            const Text('Admin user'),
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
                      SizedBox(
                        width: 260,
                        child: SomTextInput(
                          label: 'E-mail',
                          icon: Icons.email,
                          hint: 'Enter email of SOM administrator account',
                          value: request.company.admin.email,
                          onChanged: request.company.admin.setEmail,
                        ),
                      ),
                      30.width,
                      request.company.canCreateMoreUsers
                          ? SizedBox(
                              width: 60,
                              child: ElevatedButton(
                                  onPressed: () =>
                                      request.company.increaseNumberOfUsers(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('+'),
                                  )),
                            )
                          : const SizedBox(height: 1),
                    ],
                  ),
                  SizedBox(
                    width: 350,
                    child: DropdownButtonFormField<CompanyRole>(
                      value: CompanyRole.admin,
                      items: const [
                        DropdownMenuItem(
                          value: CompanyRole.admin,
                          child: Text('Admin'),
                        ),
                      ],
                      onChanged: (_) {},
                      decoration: const InputDecoration(
                        labelText: 'Role',
                      ),
                    ),
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
                      const Divider(),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: [
                          SizedBox(
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
                              ? SizedBox(
                                  width: 60,
                                  child: ElevatedButton(
                                      onPressed: () =>
                                          request.company.removeUser(index),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('-'),
                                      )),
                                )
                              : const SizedBox(height: 1),
                        ],
                      ),
                      SizedBox(
                        width: 350,
                        child: DropdownButtonFormField<CompanyRole>(
                          value: request.company.users[index].role,
                          items: _allowedUserRoles(request.company)
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(_roleLabel(role)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              request.company.users[index].setRole(value);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Role',
                          ),
                        ),
                      ),
                      SizedBox(
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
            const Divider(),
            CheckboxListTile(
              value: request.company.termsAccepted,
              onChanged: (value) =>
                  request.company.setTermsAccepted(value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('I accept the terms and conditions'),
            ),
            CheckboxListTile(
              value: request.company.privacyAccepted,
              onChanged: (value) =>
                  request.company.setPrivacyAccepted(value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('I accept the privacy policy'),
            ),
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

  Text stepTitle(title) {
    return Text(title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ));
  }
}
