import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/screen/template/DTNoDataScreen.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';

import '../../../../domain/model/customer-management/roles.dart';
import '../../../../main.dart';
import 'RoleSelection.dart';

class Registration extends StatefulWidget {
  @override
  createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();
  var passCont = TextEditingController();
  var companyNameCont = TextEditingController();

  var emailFocus = FocusNode();
  var passFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleSelection(),
        Observer(builder: (_) {
          print('\n\nyou hit me !! \n\n');
          print(customerStore.fullName);
          print('\n\n');
          if (customerStore.role == Roles.Buyer) {
            return buyerForm();
          }

          if (customerStore.role == Roles.Provider) {
            return providerForm();
          }

          if (customerStore.role == Roles.ProviderAndBuyer) {
            return providerAndBuyerForm();
          }

          return DTNoDataScreen();
        }),
      ],
    );
  }

  Widget providerForm() => company(
        Text('provider'),
      );

  Widget buyerForm() => company(
        Text('buyer'),
      );

  Widget providerAndBuyerForm() => company(
        Text('Both roles are assumed.'),
      );

  Widget company(data) {
    return Container(
      width: 800,
      child: Column(
        children: [
          Container(
            width: 616,
            child: Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
              Text("Company details"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
            ]),
          ),
          Row(
            children: [
              Container(
                width: 300,
                child: Column(
                  children: [
// Company name
                    TextFormField(
                      controller: companyNameCont,
                      style: primaryTextStyle(),
                      decoration: buildInputDecoration('Company name'),
                      keyboardType: TextInputType.text,
                      validator: (s) {
                        if (s!.trim().isEmpty) return errorThisFieldRequired;
                        return null;
                      },
                      onFieldSubmitted: (s) =>
                          FocusScope.of(context).requestFocus(emailFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
// E-mail
                    TextFormField(
                      controller: emailCont,
                      focusNode: emailFocus,
                      style: primaryTextStyle(),
                      decoration: buildInputDecoration('E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (s) {
                        if (s!.trim().isEmpty) return errorThisFieldRequired;
                        if (!s.trim().validateEmail())
                          return 'Email is invalid';
                        return null;
                      },
                      onFieldSubmitted: (s) =>
                          FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text("Company address"),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
// City
                    TextFormField(
                      decoration: buildInputDecoration('Country'),
                    ),
                    16.height, // City
                    TextFormField(
                      decoration: buildInputDecoration('City'),
                    ),
                    16.height,
// Street
                    TextFormField(
                      decoration: buildInputDecoration('Street'),
                    ),
                    16.height,
// Number
                    TextFormField(
                      decoration: buildInputDecoration('Number'),
                    ),
                    16.height,
// Zip
                    TextFormField(
                      decoration: buildInputDecoration('Zip'),
                    ),
                    16.height,
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
                    data,
                  ],
                ),
              ),
              20.width,
              Container(
                width: 300,
                child: Column(
                  children: [
// Company name
                    TextFormField(
                      controller: companyNameCont,
                      style: primaryTextStyle(),
                      decoration: buildInputDecoration('UID Number'),
                      keyboardType: TextInputType.text,
                      validator: (s) {
                        if (s!.trim().isEmpty) return errorThisFieldRequired;
                        return null;
                      },
                      onFieldSubmitted: (s) =>
                          FocusScope.of(context).requestFocus(emailFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
// E-mail
                    TextFormField(
                      controller: emailCont,
                      focusNode: emailFocus,
                      style: primaryTextStyle(),
                      decoration: buildInputDecoration('Registration number'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (s) {
                        if (s!.trim().isEmpty) return errorThisFieldRequired;
                        if (!s.trim().validateEmail())
                          return 'Email is invalid';
                        return null;
                      },
                      onFieldSubmitted: (s) =>
                          FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    TextFormField(
                      decoration: buildInputDecoration('Company size'),
                    ),
                    16.height, // City
                    TextFormField(
                      decoration: buildInputDecoration('Website URL'),
                    ),
                    16.height,
// Street
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text("Bank details"),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),

                    TextFormField(
                      decoration: buildInputDecoration('IBAN'),
                    ),
                    16.height,
// Number
                    TextFormField(
                      decoration: buildInputDecoration('BIC'),
                    ),
                    16.height,
// Zip
                    TextFormField(
                      decoration: buildInputDecoration('Account owner'),
                    ),
                    16.height,
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(
    String labelText, {
    Icon? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.all(16),
      labelStyle: secondaryTextStyle(),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: appColorPrimary)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: appStore.textSecondaryColor!)),
      suffix: suffixIcon,
    );
  }
}
