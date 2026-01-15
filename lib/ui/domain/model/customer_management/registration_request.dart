import 'package:built_collection/src/list.dart' show ListBuilder;
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../application/application.dart';
import '../shared/som.dart';
import 'company.dart';
import 'roles.dart';
import 'registration_user.dart';
import 'payment-interval.dart';

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
      final selectedPlanId = company.providerData.subscriptionPlanId ??
          (som.availableSubscriptions.data != null &&
                  som.availableSubscriptions.data!.isNotEmpty
              ? som.availableSubscriptions.data!.first.id
              : null);
      final selectedBranchIds =
          som.requestedBranches.map((tag) => tag.id).toList();
      final bankDetails = BankDetailsBuilder()
        ..accountOwner = company.providerData.bankDetails!.accountOwner!
        ..bic = company.providerData.bankDetails!.bic!
        ..iban = company.providerData.bankDetails!.iban!;

      providerData = ProviderRegistrationDataBuilder()
        ..bankDetails = bankDetails
        ..paymentInterval = company.providerData.paymentInterval ==
                PaymentInterval.Monthly
            ? ProviderRegistrationDataPaymentIntervalEnum.number0
            : ProviderRegistrationDataPaymentIntervalEnum.number1
        ..subscriptionPlanId = selectedPlanId
        ..providerType = company.providerData.providerType
        ..branchIds = ListBuilder<String>(selectedBranchIds);
    }

    final size = _mapCompanySize(company.companySize);
    final companyRequest = CompanyRegistrationBuilder()
      ..type = company.role == Roles.ProviderAndBuyer
          ? CompanyRegistrationTypeEnum.number2
          : company.isProvider
              ? CompanyRegistrationTypeEnum.number1
              : CompanyRegistrationTypeEnum.number0
      ..address = addressRequest
      ..companySize = size
      ..name = company.name
      ..providerData = providerData
      ..registrationNr = company.registrationNumber
      ..websiteUrl = company.url
      ..uidNr = company.uidNr
      ..termsAccepted = company.termsAccepted
      ..privacyAccepted = company.privacyAccepted
      ..build();

    List<UserRegistrationRolesEnum> resolveRoles(RegistrationUser user) {
      switch (user.role) {
        case CompanyRole.admin:
          final roles = <UserRegistrationRolesEnum>[
            UserRegistrationRolesEnum.number4,
          ];
          if (company.isBuyer) {
            roles.add(UserRegistrationRolesEnum.number0);
          }
          if (company.isProvider) {
            roles.add(UserRegistrationRolesEnum.number1);
          }
          return roles;
        case CompanyRole.provider:
          return [UserRegistrationRolesEnum.number1];
        case CompanyRole.buyer:
        default:
          return [UserRegistrationRolesEnum.number0];
      }
    }

    ListBuilder<UserRegistration>? usersRequest = ListBuilder<UserRegistration>(
        company.users.map((element) => (UserRegistrationBuilder()
              ..email = element.email
              ..firstName = element.firstName
              ..lastName = element.lastName
              ..salutation = element.salutation
              ..telephoneNr = element.phone
              ..roles = ListBuilder<UserRegistrationRolesEnum>(
                  resolveRoles(element))
              ..title = element.title)
            .build()))
          ..update((p0) => p0.add((UserRegistrationBuilder()
                ..email = company.admin.email
                ..firstName = company.admin.firstName
                ..lastName = company.admin.lastName
                ..salutation = company.admin.salutation
                ..telephoneNr = company.admin.phone
                ..roles = ListBuilder<UserRegistrationRolesEnum>(
                    resolveRoles(company.admin))
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

CompanyRegistrationCompanySizeEnum _mapCompanySize(String? size) {
  switch (size) {
    case '0-10':
      return CompanyRegistrationCompanySizeEnum.number0;
    case '11-50':
      return CompanyRegistrationCompanySizeEnum.number1;
    case '51-100':
      return CompanyRegistrationCompanySizeEnum.number2;
    case '101-250':
      return CompanyRegistrationCompanySizeEnum.number3;
    case '251-500':
      return CompanyRegistrationCompanySizeEnum.number4;
    case '500+':
      return CompanyRegistrationCompanySizeEnum.number5;
    default:
      return CompanyRegistrationCompanySizeEnum.number0;
  }
}
