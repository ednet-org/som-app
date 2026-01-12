import 'package:built_collection/src/list.dart' show ListBuilder;
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../application/application.dart';
import '../shared/som.dart';
import 'company.dart';
import 'roles.dart';

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

    if (!company.termsAccepted || !company.privacyAccepted) {
      isRegistering = false;
      isFailedRegistration = true;
      errorMessage = 'Please accept the terms and privacy policy to continue.';
      return;
    }

    final addressRequest = AddressBuilder()
      ..city = company.address.city
      ..country = company.address.country
      ..number = company.address.number
      ..street = company.address.street
      ..zip = company.address.zip;

    ProviderRegistrationDataBuilder? providerData;

    if (company.isProvider) {
      final bankDetails = BankDetailsBuilder()
        ..accountOwner = company.providerData.bankDetails!.accountOwner!
        ..bic = company.providerData.bankDetails!.bic!
        ..iban = company.providerData.bankDetails!.iban!;

      providerData = ProviderRegistrationDataBuilder()
        ..bankDetails = bankDetails
        // hardcoded
        ..paymentInterval = ProviderRegistrationDataPaymentIntervalEnum.number0
        ..subscriptionPlanId = "68294d4c-dbed-11eb-82b1-028b3e4c7287"
        ..branchIds =
            ListBuilder<String>(["641d9ca8-380b-4ded-8e26-1c32065c703f"]);
    }

    final companyRequest = CompanyRegistrationBuilder()
      ..type = company.role == Roles.ProviderAndBuyer
          ? CompanyRegistrationTypeEnum.number2
          : company.isProvider
              ? CompanyRegistrationTypeEnum.number1
              : CompanyRegistrationTypeEnum.number0
      ..address = addressRequest
      // todo: hardcoded
      ..companySize = CompanyRegistrationCompanySizeEnum.number4
      ..name = company.name
      ..providerData = providerData
      ..registrationNr = company.registrationNumber
      ..websiteUrl = company.url
      ..uidNr = company.uidNr
      ..termsAccepted = company.termsAccepted
      ..privacyAccepted = company.privacyAccepted
      ..build();

    final List<UserRegistrationRolesEnum> defaultRoles = company.role == Roles.Provider
        ? [UserRegistrationRolesEnum.number1]
        : company.role == Roles.ProviderAndBuyer
            ? [
                UserRegistrationRolesEnum.number2,
                UserRegistrationRolesEnum.number1
              ]
            : [UserRegistrationRolesEnum.number2];

    ListBuilder<UserRegistration>? usersRequest = ListBuilder<UserRegistration>(
        company.users.map((element) => (UserRegistrationBuilder()
              ..email = element.email
              ..firstName = element.firstName
              ..lastName = element.lastName
              ..salutation = element.salutation
              ..telephoneNr = element.phone
              ..roles = ListBuilder<UserRegistrationRolesEnum>(defaultRoles)
              ..title = element.title)
            .build()))
          ..update((p0) => p0.add((UserRegistrationBuilder()
                ..email = company.admin.email
                ..firstName = company.admin.firstName
                ..lastName = company.admin.lastName
                ..salutation = company.admin.salutation
                ..telephoneNr = company.admin.phone
                ..roles = ListBuilder<UserRegistrationRolesEnum>(
                    [UserRegistrationRolesEnum.number4])
                ..title = company.admin.title)
              .build()));

    final registerCompanyRequest = RegisterCompanyRequestBuilder()
      ..company = companyRequest
      ..users = usersRequest;

    final buildCompany = registerCompanyRequest.build();

    try {
      final response = await api.registerCompany(
        registerCompanyRequest: buildCompany,
      );

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
