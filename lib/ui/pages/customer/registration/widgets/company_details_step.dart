import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../../../domain/model/model.dart';
import '../form_section_header.dart';

const List<String> _companySizeOptions = [
  '0-10',
  '11-50',
  '51-100',
  '101-250',
  '251-500',
  '500+',
];

/// Step widget for company details in registration flow.
class CompanyDetailsStep extends StatelessWidget {
  const CompanyDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<RegistrationRequest>(context);
    return Column(
      children: [
        const FormSectionHeader(label: 'General info'),
        SomTextInput(
          label: 'Company name',
          iconAsset: SomAssets.iconDashboard,
          hint: 'Enter legal entity name',
          value: request.company.name,
          onChanged: request.company.setName,
          required: true,
        ),
        SomTextInput(
          label: 'UID number',
          iconAsset: SomAssets.iconInfo,
          hint: 'Enter UID number',
          value: request.company.uidNr,
          onChanged: request.company.setUidNr,
          required: true,
        ),
        SomTextInput(
          label: 'Registration number',
          iconAsset: SomAssets.iconInfo,
          hint: 'describe what is registration number, where to find it?',
          value: request.company.registrationNumber,
          onChanged: request.company.setRegistrationNumber,
          required: true,
        ),
        SomDropDown<String>(
          value: request.company.companySize,
          onChanged: (val) {
            if (val != null) request.company.setCompanySize(val);
          },
          hint: 'Select company size',
          label: 'Number of employees',
          items: _companySizeOptions,
        ),
        const FormSectionHeader(label: 'Contact details'),
        SomTextInput(
          label: 'Phone number',
          iconAsset: SomAssets.iconNotification,
          hint: 'Enter phone number',
          value: request.company.phoneNumber,
          onChanged: request.company.setPhoneNumber,
        ),
        SomTextInput(
          label: 'Web',
          iconAsset: SomAssets.iconSearch,
          hint: 'Enter company web address',
          value: request.company.url,
          onChanged: request.company.setUrl,
        ),
        const FormSectionHeader(label: 'Company address'),
        SomDropDown<String>(
          value: request.company.address.country,
          onChanged: (val) {
            if (val != null) request.company.address.setCountry(val);
          },
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
    );
  }
}
