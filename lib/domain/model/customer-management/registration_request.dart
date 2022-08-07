import 'package:built_collection/src/list.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';
import 'package:som/domain/model/shared/som.dart';
import 'package:som/ui/pages/customer/registration/thank_you_page.dart';

import 'company.dart';

part 'registration_request.g.dart';

class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  Som som;
  CompaniesApi api;

  _RegistrationRequest(this.som, this.api);

  @observable
  bool isRegistering = false;

  @observable
  bool isFailedRegistration = false;

  @observable
  String errorMessage = '';

  @observable
  Company company = Company();

  @action
  void setCompany(Company value) => company = value;

  @action
  Future<void> registerCustomer(BuildContext context) async {
    isRegistering = true;
    isFailedRegistration = false;

    final addressRequest = AddressDtoBuilder()
      ..city = company.address.city
      ..country = company.address.country
      ..number = company.address.number
      ..street = company.address.street
      ..zip = company.address.zip;

    var providerData;

    if (company.isProvider) {
      final bankDetails;

      bankDetails = BankDetailsDtoBuilder()
        ..accountOwner = company.providerData.bankDetails!.accountOwner!
        ..bic = company.providerData.bankDetails!.bic!
        ..iban = company.providerData.bankDetails!.iban!;

      providerData = CreateProviderDtoBuilder()
        ..bankDetails = bankDetails
        // hardcoded
        ..paymentInterval = PaymentInterval.number0
        ..subscriptionPlanId = ""
        ..branchIds =
            ListBuilder<String>(["641d9ca8-380b-4ded-8e26-1c32065c703f"]);
    }

    final companyRequest = CreateCompanyDtoBuilder()
      // hardcoded
      ..type = company.isProvider ? CompanyType.number1 : CompanyType.number0
      ..address = addressRequest
      // hardcoded
      ..companySize = CompanySize.number4
      ..name = company.name
      ..providerData = providerData
      ..registrationNr = company.registrationNumber
      ..websiteUrl = company.url
      ..uidNr = company.uidNr;

    ListBuilder<UserDto>? usersRequest = ListBuilder<UserDto>(
        company.users.map((element) => UserDtoBuilder()
          ..email = element.email
          ..firstName = element.firstName
          ..lastName = element.lastName
          ..salutation = element.salutation
          ..telephoneNr = element.phone
          ..roles = ListBuilder<Roles>([Roles.number2])
          ..title = element.title))
      ..update((p0) => UserDtoBuilder()
        ..email = company.admin.email
        ..firstName = company.admin.firstName
        ..lastName = company.admin.lastName
        ..salutation = company.admin.salutation
        ..telephoneNr = company.admin.phone
        ..roles = ListBuilder<Roles>([Roles.number4])
        ..title = company.admin.title
        ..build());

    final registerCompanyDto = RegisterCompanyDtoBuilder()
      ..company = companyRequest
      ..users = usersRequest;

    try {
      final response = await api.companiesRegisterPost(
          registerCompanyDto: registerCompanyDto.build());

      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<ThankYouPage>(builder: (_) => ThankYouPage()),
            (route) => true);
      }
    } catch (error) {
      isFailedRegistration = true;
      errorMessage = error.toString();
    }
  }
}
