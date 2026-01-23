import 'package:flutter/material.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/snackbars.dart';

import '../../domain/model/model.dart';

class CompanyDTO {
  String id;
  String name;
  String branch;
  String companySize;
  String providerType;
  String? postcode;
  bool claimed;
  int? numReceivedInquiries;
  int? numSentOffers;
  int? numAcceptedOffers;
  String? registrationDate;
  String? subscriptionPackageType;
  String? iban;
  String? bic;
  String? accountHolder;
  String? paymentInterval;

  CompanyDTO({
    required this.id,
    required this.name,
    required this.branch,
    required this.companySize,
    required this.providerType,
    required this.claimed,
    this.postcode,
    this.numReceivedInquiries,
    this.numSentOffers,
    this.numAcceptedOffers,
    this.registrationDate,
    this.subscriptionPackageType,
    this.iban,
    this.bic,
    this.accountHolder,
    this.paymentInterval,
  });

  factory CompanyDTO.fromJson(Map<String, dynamic> json) {
    return CompanyDTO(
        id: json['id'],
        name: json['name'],
        branch: json['branch'],
        companySize: json['companySize'],
        providerType: json['providerType'],
        postcode: json['postcode'],
        claimed: json['claimed'],
        numReceivedInquiries: json['numReceivedInquiries'],
        numSentOffers: json['numSentOffers'],
        numAcceptedOffers: json['numAcceptedOffers'],
        registrationDate: json['registrationDate'],
        subscriptionPackageType: json['subscriptionPackageType'],
        iban: json['IBAN'],
        bic: json['BIC'],
        accountHolder: json['accountHolder'],
        paymentInterval: json['paymentInterval']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch': branch,
      'companySize': companySize,
      'providerType': providerType,
      'postcode': postcode,
      'claimed': claimed,
      'numReceivedInquiries': numReceivedInquiries,
      'numSentOffers': numSentOffers,
      'numAcceptedOffers': numAcceptedOffers,
      'registrationDate': registrationDate,
      'subscriptionPackageType': subscriptionPackageType,
      'IBAN': iban,
      'BIC': bic,
      'accountHolder': accountHolder,
      'paymentInterval': paymentInterval,
    };
  }

  CompanyDTO copyWith({
    String? id,
    String? name,
    String? branch,
    String? companySize,
    String? providerType,
    String? postcode,
    bool? claimed,
    int? numReceivedInquiries,
    int? numSentOffers,
    int? numAcceptedOffers,
    String? registrationDate,
    String? subscriptionPackageType,
    String? iban,
    String? bic,
    String? accountHolder,
    String? paymentInterval,
  }) {
    return CompanyDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      branch: branch ?? this.branch,
      companySize: companySize ?? this.companySize,
      providerType: providerType ?? this.providerType,
      postcode: postcode ?? this.postcode,
      claimed: claimed ?? this.claimed,
      numReceivedInquiries: numReceivedInquiries ?? this.numReceivedInquiries,
      numSentOffers: numSentOffers ?? this.numSentOffers,
      numAcceptedOffers: numAcceptedOffers ?? this.numAcceptedOffers,
      registrationDate: registrationDate ?? this.registrationDate,
      subscriptionPackageType:
          subscriptionPackageType ?? this.subscriptionPackageType,
      iban: iban ?? this.iban,
      bic: bic ?? this.bic,
      accountHolder: accountHolder ?? this.accountHolder,
      paymentInterval: paymentInterval ?? this.paymentInterval,
    );
  }
}

class EditCompanyForm extends StatefulWidget {
  final CompanyDTO company;

  const EditCompanyForm({super.key, required this.company});

  @override
  State<EditCompanyForm> createState() => _EditCompanyFormState();
}

class _EditCompanyFormState extends State<EditCompanyForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                initialValue: widget.company.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.branch,
                decoration: const InputDecoration(
                  labelText: 'Branch',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a branch';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.companySize,
                decoration: const InputDecoration(
                  labelText: 'Company Size',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company size';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.providerType,
                decoration: const InputDecoration(
                  labelText: 'Provider Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a provider type';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.postcode,
                decoration: const InputDecoration(
                  labelText: 'Postcode',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a postcode';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.iban,
                decoration: const InputDecoration(
                  labelText: 'IBAN',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an IBAN';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.bic,
                decoration: const InputDecoration(
                  labelText: 'BIC',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a BIC';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.accountHolder,
                decoration: const InputDecoration(
                  labelText: 'Account Holder',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account holder';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.company.paymentInterval,
                decoration: const InputDecoration(
                  labelText: 'Payment Interval',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a payment interval';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      SomSnackBars.info(context, 'Processing data...');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}

class CompanyFormWithSomTextInputs extends StatelessWidget {
  CompanyFormWithSomTextInputs({super.key, required this.company});

  final CompanyDTO company;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SomTextInput(
              label: 'Company name',
              iconAsset: SomAssets.iconDashboard,
              hint: 'Enter legal entity name',
              value: company.name,
              onChanged: (value) => company.name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a company name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
