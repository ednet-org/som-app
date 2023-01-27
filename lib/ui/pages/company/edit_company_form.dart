import 'package:flutter/material.dart';
import 'package:som/ui/components/forms/som_text_input.dart';

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
  String? IBAN;
  String? BIC;
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
    this.IBAN,
    this.BIC,
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
        IBAN: json['IBAN'],
        BIC: json['BIC'],
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
      'IBAN': IBAN,
      'BIC': BIC,
      'accountHolder': accountHolder,
      'paymentInterval': paymentInterval,
    };
  }

  copyWith({
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
    String? IBAN,
    String? BIC,
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
      IBAN: IBAN ?? this.IBAN,
      BIC: BIC ?? this.BIC,
      accountHolder: accountHolder ?? this.accountHolder,
      paymentInterval: paymentInterval ?? this.paymentInterval,
    );
  }
}

class EditCompanyForm extends StatefulWidget {
  final CompanyDTO company;

  const EditCompanyForm({super.key, required this.company});

  @override
  _EditCompanyFormState createState() => _EditCompanyFormState();
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
                initialValue: widget.company.IBAN,
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
                initialValue: widget.company.BIC,
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
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
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

// class CompanyEditForm extends StatefulWidget {
//   final CompanyDTO company;
//   final Function(CompanyDTO) onSave;
//
//   CompanyEditForm({Key key, @required this.company, @required this.onSave})
//       : super(key: key);
//
//   @override
//   _CompanyEditFormState createState() => _CompanyEditFormState();
// }
//
// class _CompanyEditFormState extends State<CompanyEditForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _websiteController = TextEditingController();
//   final _branchController = TextEditingController();
//   final _companySizeController = TextEditingController();
//   final _providerTypeController = TextEditingController();
//   final _postcodeController = TextEditingController();
//   final _IBANController = TextEditingController();
//   final _BICController = TextEditingController();
//   final _accountHolderController = TextEditingController();
//   final _paymentIntervalController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.company.name;
//     _addressController.text = widget.company.address;
//     _phoneNumberController.text = widget.company.phoneNumber;
//     _emailController.text = widget.company.email;
//     _websiteController.text = widget.company.website;
//     _branchController.text = widget.company.branch;
//     _companySizeController.text = widget.company.companySize;
//     _providerTypeController.text = widget.company.providerType;
//     _postcodeController.text = widget.company.postcode;
//     _IBANController.text = widget.company.IBAN;
//     _BICController.text = widget.company.BIC;
//     _accountHolderController.text = widget.company.accountHolder;
//     _paymentIntervalController.text = widget.company.paymentInterval;
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _phoneNumberController.dispose();
//     _emailController.dispose();
//     _websiteController.dispose();
//     _branchController.dispose();
//     _companySizeController.dispose();
//     _providerTypeController.dispose();
//     _postcodeController.dispose();
//     _IBANController.dispose();
//     _BICController.dispose();
//     _accountHolderController.dispose();
//     _paymentIntervalController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a name';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _addressController,
//               decoration: const InputDecoration(
//                 labelText: 'Address',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an address';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _phoneNumberController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a phone number';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an email';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _websiteController,
//               decoration: const InputDecoration(
//                 labelText: 'Website',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a website';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _branchController,
//               decoration: const InputDecoration(
//                 labelText: 'Branch',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a branch';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _companySizeController,
//               decoration: const InputDecoration(
//                 labelText: 'Company Size',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a company size';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _providerTypeController,
//               decoration: const InputDecoration(
//                 labelText: 'Provider Type',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a provider type';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _postcodeController,
//               decoration: const InputDecoration(
//                 labelText: 'Postcode',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a postcode';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _IBANController,
//               decoration: const InputDecoration(
//                 labelText: 'IBAN',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an IBAN';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _BICController,
//               decoration: const InputDecoration(
//                 labelText: 'BIC',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a BIC';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _accountHolderController,
//               decoration: const InputDecoration(
//                 labelText: 'Account Holder',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an account holder';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _paymentIntervalController,
//               decoration: const InputDecoration(
//                 labelText: 'Payment Interval',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a payment interval';
//                 }
//                 return null;
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     widget.company.name = _nameController.text;
//                     widget.company.address = _addressController.text;
//                     widget.company.phoneNumber = _phoneNumberController.text;
//                     widget.company.email = _emailController.text;
//                     widget.company.website = _websiteController.text;
//                     widget.company.branch = _branchController.text;
//                     widget.company.companySize = _companySizeController.text;
//                     widget.company.providerType = _providerTypeController.text;
//                     widget.company.postcode = _postcodeController.text;
//                     widget.company.IBAN = _IBANController.text;
//                     widget.company.BIC = _BICController.text;
//                     widget.company.accountHolder =
//                         _accountHolderController.text;
//                     widget.company.paymentInterval =
//                         _paymentIntervalController.text;
//                     widget.onSave(widget.company);
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

class CompanyFormWithSomTextInputs extends StatelessWidget {
  CompanyFormWithSomTextInputs({Key? key, required this.company})
      : super(key: key);

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
              icon: Icons.account_balance,
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
