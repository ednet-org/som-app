import 'package:built_collection/src/list.dart' show ListBuilder;
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../../shared/som.dart';
import '../../app_config/application.dart';
import 'company.dart';

part 'registration_request.g.dart';

class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  Som som;
  CompaniesApi api;
  Application appStore;
  final sharedPrefs;

  _RegistrationRequest(this.som, this.api, this.appStore, this.sharedPrefs)
      : company = Company(appStore, sharedPrefs);

  @observable
  bool isRegistering = false;

  @observable
  bool isSuccess = false;

  @observable
  bool isFailedRegistration = false;

  @observable
  String errorMessage = '';

  @observable
  Company company;

  @action
  void setCompany(Company value) => company = value;

  @action
  Future<void> registerCustomer() async {
    isRegistering = true;
    isFailedRegistration = false;
    isSuccess = false;
    errorMessage = '';

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
        ..subscriptionPlanId = "68294d4c-dbed-11eb-82b1-028b3e4c7287"
        ..branchIds =
            ListBuilder<String>(["641d9ca8-380b-4ded-8e26-1c32065c703f"]);
    }

    final companyRequest = CreateCompanyDtoBuilder()
      // todo: hardcoded
      ..type = company.isProvider ? CompanyType.number1 : CompanyType.number0
      ..address = addressRequest
      // todo: hardcoded
      ..companySize = CompanySize.number4
      ..name = company.name
      ..providerData = providerData
      ..registrationNr = company.registrationNumber
      ..websiteUrl = company.url
      ..uidNr = company.uidNr
      ..build();

    ListBuilder<UserDto>? usersRequest =
        ListBuilder<UserDto>(company.users.map((element) => (UserDtoBuilder()
              ..email = element.email
              ..firstName = element.firstName
              ..lastName = element.lastName
              ..salutation = element.salutation
              ..telephoneNr = element.phone
              ..roles = ListBuilder<Roles>([Roles.number2])
              ..title = element.title)
            .build()))
          ..update((p0) => p0.add((UserDtoBuilder()
                ..email = company.admin.email
                ..firstName = company.admin.firstName
                ..lastName = company.admin.lastName
                ..salutation = company.admin.salutation
                ..telephoneNr = company.admin.phone
                ..roles = ListBuilder<Roles>([Roles.number4])
                ..title = company.admin.title)
              .build()));

    final registerCompanyDto = RegisterCompanyDtoBuilder()
      ..company = companyRequest
      ..users = usersRequest;

    final buildCompany = registerCompanyDto.build();

    try {
      final response =
          await api.companiesRegisterPost(registerCompanyDto: buildCompany);

      //todo: evaluate state, fix UI and check possible abstractions in behaviour - ex. error handling, success message, etc.
      if (response.statusCode == 200) {
        isSuccess = true;
        isFailedRegistration = false;
        isRegistering = false;
      }
    } catch (error) {
      isFailedRegistration = true;
      isRegistering = false;
      errorMessage = error.toString();
      print(error);
    }
  }
}
