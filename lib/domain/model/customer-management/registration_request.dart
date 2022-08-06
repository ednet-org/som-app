import 'package:built_collection/src/list.dart';
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';
import 'package:som/domain/model/shared/som.dart';

import 'company.dart';

part 'registration_request.g.dart';

class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  Som som;
  CompaniesApi api;

  _RegistrationRequest(this.som, this.api);

  @observable
  Company company = Company();

  @action
  void setCompany(Company value) => company = value;

  @action
  void registerCustomer() {
    final addressRequest = AddressDtoBuilder()
      ..city = company.address.city
      ..country = company.address.country
      ..number = company.address.number
      ..street = company.address.street
      ..zip = company.address.zip;

    final bankDetails = BankDetailsDtoBuilder()
      ..accountOwner = company.providerData.bankDetails!.accountOwner!
      ..bic = company.providerData.bankDetails!.bic!
      ..iban = company.providerData.bankDetails!.iban!;

    final providerData = CreateProviderDtoBuilder()
      ..bankDetails = bankDetails
      // hardcoded
      ..paymentInterval = PaymentInterval.number0
      ..subscriptionPlanId = "";

    final companyRequest = CreateCompanyDtoBuilder()
      // hardcoded
      ..type = company.isProvider ? CompanyType.number0 : CompanyType.number1
      ..address = addressRequest
      // hardcoded
      ..companySize = CompanySize.number4
      ..name = company.name
      ..providerData = providerData
      ..registrationNr = company.registrationNumber
      ..websiteUrl = company.url
      ..uidNr = company.uidNr
      ..build();
    ListBuilder<UserDto>? usersRequest;

    final registerCompanyDto = RegisterCompanyDtoBuilder()
      ..company = companyRequest
      ..users = usersRequest;
    final response = api.companiesRegisterPost(
        registerCompanyDto: registerCompanyDto.build());
  }
}
