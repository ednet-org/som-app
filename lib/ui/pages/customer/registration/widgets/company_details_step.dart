import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    return Observer(
      builder: (_) => Column(
        children: [
          const FormSectionHeader(label: 'General info'),
          SomTextInput(
            label: 'Company name',
            iconAsset: SomAssets.iconDashboard,
            hint: 'Enter legal entity name',
            value: request.company.name,
            errorText: request.fieldError('company.name'),
            onChanged: (value) {
              request.company.setName(value);
              request.clearFieldError('company.name');
            },
            required: true,
          ),
          SomTextInput(
            label: 'UID number',
            iconAsset: SomAssets.iconInfo,
            hint: 'Enter UID number',
            value: request.company.uidNr,
            errorText: request.fieldError('company.uidNr'),
            onChanged: (value) {
              request.company.setUidNr(value);
              request.clearFieldError('company.uidNr');
            },
            required: true,
          ),
          SomTextInput(
            label: 'Registration number',
            iconAsset: SomAssets.iconInfo,
            hint: 'describe what is registration number, where to find it?',
            value: request.company.registrationNumber,
            errorText: request.fieldError('company.registrationNumber'),
            onChanged: (value) {
              request.company.setRegistrationNumber(value);
              request.clearFieldError('company.registrationNumber');
            },
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
              if (val != null) {
                request.company.address.setCountry(val);
                request.clearFieldError('company.address.country');
              }
            },
            hint: 'Select country',
            label: 'Country',
            errorText: request.fieldError('company.address.country'),
            items: countries,
          ),
          SomTextInput(
            label: 'ZIP',
            hint: 'Enter ZIP',
            autocorrect: false,
            value: request.company.address.zip,
            errorText: request.fieldError('company.address.zip'),
            onChanged: (value) {
              request.company.address.setZip(value);
              request.clearFieldError('company.address.zip');
            },
            required: true,
          ),
          SomTextInput(
            label: 'City',
            hint: 'Enter city',
            autocorrect: false,
            value: request.company.address.city,
            errorText: request.fieldError('company.address.city'),
            onChanged: (value) {
              request.company.address.setCity(value);
              request.clearFieldError('company.address.city');
            },
            required: true,
          ),
          SomTextInput(
            label: 'Street',
            hint: 'Enter street',
            autocorrect: false,
            value: request.company.address.street,
            errorText: request.fieldError('company.address.street'),
            onChanged: (value) {
              request.company.address.setStreet(value);
              request.clearFieldError('company.address.street');
            },
            required: true,
          ),
          SomTextInput(
            label: 'Number',
            hint: 'Enter number',
            autocorrect: false,
            value: request.company.address.number,
            errorText: request.fieldError('company.address.number'),
            onChanged: (value) {
              request.company.address.setNumber(value);
              request.clearFieldError('company.address.number');
            },
            required: true,
          ),
        ],
      ),
    );
  }
}
