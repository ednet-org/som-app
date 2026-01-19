import 'package:built_collection/built_collection.dart' show ListBuilder;
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../application/application.dart';
import '../shared/som.dart';
import 'company.dart';
import 'roles.dart';
import 'registration_user.dart';
import 'payment_interval.dart';

part 'registration_request.g.dart';

// ignore: library_private_types_in_public_api
class RegistrationRequest = _RegistrationRequest with _$RegistrationRequest;

abstract class _RegistrationRequest with Store {
  Som som;
  CompaniesApi api;
  Application appStore;
  final Object sharedPrefs;

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

  final ObservableMap<String, String> fieldErrors = ObservableMap.of({});

  @observable
  Company company;

  @action
  void setCompany(Company value) => company = value;

  String? fieldError(String key) => fieldErrors[key];

  void clearFieldError(String key) {
    runInAction(() => fieldErrors.remove(key));
  }

  void _setFieldError(String key, String message) {
    runInAction(() => fieldErrors[key] = message);
  }

  @action
  Future<void> registerCustomer() async {
    isRegistering = true;
    isFailedRegistration = false;
    isSuccess = false;
    errorMessage = '';
    runInAction(fieldErrors.clear);

    final validationIssues = _validate();
    if (validationIssues.isNotEmpty) {
      isRegistering = false;
      isFailedRegistration = true;
      errorMessage = 'Please review the highlighted fields.';
      return;
    }

    final addressRequest = AddressBuilder()
      ..city = company.address.city!.trim()
      ..country = company.address.country!.trim()
      ..number = company.address.number!.trim()
      ..street = company.address.street!.trim()
      ..zip = company.address.zip!.trim();

    ProviderRegistrationDataBuilder? providerData;

    if (company.isProvider) {
      final selectedPlanId =
          company.providerData.subscriptionPlanId ??
          (som.availableSubscriptions.data != null &&
                  som.availableSubscriptions.data!.isNotEmpty
              ? som.availableSubscriptions.data!.first.id
              : null);
      final selectedBranchIds = som.requestedBranches
          .map((tag) => tag.id)
          .toList();
      final bankDetails = BankDetailsBuilder()
        ..accountOwner = company.providerData.bankDetails!.accountOwner!.trim()
        ..bic = company.providerData.bankDetails!.bic!.trim()
        ..iban = company.providerData.bankDetails!.iban!.trim();

      providerData = ProviderRegistrationDataBuilder()
        ..bankDetails = bankDetails
        ..paymentInterval =
            company.providerData.paymentInterval == PaymentInterval.monthly
            ? ProviderRegistrationDataPaymentIntervalEnum.number0
            : ProviderRegistrationDataPaymentIntervalEnum.number1
        ..subscriptionPlanId = selectedPlanId?.trim()
        ..providerType = company.providerData.providerType?.trim()
        ..branchIds = ListBuilder<String>(selectedBranchIds);
    }

    final size = _mapCompanySize(company.companySize);
    final companyRequest = CompanyRegistrationBuilder()
      ..type = company.role == Roles.providerAndBuyer
          ? CompanyRegistrationTypeEnum.number2
          : company.isProvider
          ? CompanyRegistrationTypeEnum.number1
          : CompanyRegistrationTypeEnum.number0
      ..address = addressRequest
      ..companySize = size
      ..name = company.name!.trim()
      ..providerData = providerData
      ..registrationNr = company.registrationNumber!.trim()
      ..websiteUrl = company.url?.trim()
      ..uidNr = company.uidNr!.trim()
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
          return [UserRegistrationRolesEnum.number0];
      }
    }

    ListBuilder<UserRegistration>? usersRequest =
        ListBuilder<UserRegistration>(
          company.users.map(
            (element) =>
                (UserRegistrationBuilder()
                      ..email = element.email!.trim()
                      ..firstName = element.firstName!.trim()
                      ..lastName = element.lastName!.trim()
                      ..salutation = element.salutation!.trim()
                      ..telephoneNr = element.phone?.trim()
                      ..roles = ListBuilder<UserRegistrationRolesEnum>(
                        resolveRoles(element),
                      )
                      ..title = element.title?.trim())
                    .build(),
          ),
        )..update(
          (p0) => p0.add(
            (UserRegistrationBuilder()
                  ..email = company.admin.email!.trim()
                  ..firstName = company.admin.firstName!.trim()
                  ..lastName = company.admin.lastName!.trim()
                  ..salutation = company.admin.salutation!.trim()
                  ..telephoneNr = company.admin.phone?.trim()
                  ..roles = ListBuilder<UserRegistrationRolesEnum>(
                    resolveRoles(company.admin),
                  )
                  ..title = company.admin.title?.trim())
                .build(),
          ),
        );

    final registerCompanyRequest = RegisterCompanyRequestBuilder()
      ..company = companyRequest
      ..users = usersRequest;

    final buildCompany = registerCompanyRequest.build();

    try {
      final response = await api.registerCompany(
        registerCompanyRequest: buildCompany,
      );

      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        isSuccess = true;
        isFailedRegistration = false;
      } else {
        isFailedRegistration = true;
        errorMessage = response.statusMessage ?? 'Registration failed.';
      }
    } catch (error) {
      isFailedRegistration = true;
      final message = _parseApiError(error);
      errorMessage = fieldErrors.isNotEmpty ? '' : message;
    } finally {
      isRegistering = false;
    }
  }

  List<String> _validate() {
    final issues = <String>[];
    void requireValue(bool condition, String key, String message) {
      if (!condition) {
        issues.add(message);
        _setFieldError(key, message);
      }
    }

    requireValue(
      _hasValue(company.name),
      'company.name',
      'Company name is required.',
    );
    requireValue(
      _hasValue(company.uidNr),
      'company.uidNr',
      'UID number is required.',
    );
    requireValue(
      _hasValue(company.registrationNumber),
      'company.registrationNumber',
      'Registration number is required.',
    );
    requireValue(
      _hasValue(company.address.country),
      'company.address.country',
      'Country is required.',
    );
    requireValue(
      _hasValue(company.address.zip),
      'company.address.zip',
      'ZIP is required.',
    );
    requireValue(
      _hasValue(company.address.city),
      'company.address.city',
      'City is required.',
    );
    requireValue(
      _hasValue(company.address.street),
      'company.address.street',
      'Street is required.',
    );
    requireValue(
      _hasValue(company.address.number),
      'company.address.number',
      'Street number is required.',
    );

    requireValue(
      _hasValue(company.admin.email),
      'admin.email',
      'Admin email is required.',
    );
    requireValue(
      _hasValue(company.admin.firstName),
      'admin.firstName',
      'Admin first name is required.',
    );
    requireValue(
      _hasValue(company.admin.lastName),
      'admin.lastName',
      'Admin last name is required.',
    );
    requireValue(
      _hasValue(company.admin.salutation),
      'admin.salutation',
      'Admin salutation is required.',
    );

    for (var i = 0; i < company.users.length; i++) {
      final user = company.users[i];
      requireValue(
        _hasValue(user.email),
        'users.$i.email',
        'User ${i + 1} email is required.',
      );
      requireValue(
        _hasValue(user.firstName),
        'users.$i.firstName',
        'User ${i + 1} first name is required.',
      );
      requireValue(
        _hasValue(user.lastName),
        'users.$i.lastName',
        'User ${i + 1} last name is required.',
      );
      requireValue(
        _hasValue(user.salutation),
        'users.$i.salutation',
        'User ${i + 1} salutation is required.',
      );
    }

    if (company.isProvider) {
      requireValue(
        _hasValue(company.providerData.providerType),
        'provider.providerType',
        'Provider type is required.',
      );
      requireValue(
        som.requestedBranches.isNotEmpty,
        'provider.branchIds',
        'Select at least one branch.',
      );
      requireValue(
        _hasValue(company.providerData.subscriptionPlanId),
        'provider.subscriptionPlanId',
        'Subscription plan is required.',
      );
      final bank = company.providerData.bankDetails;
      requireValue(
        _hasValue(bank?.iban),
        'provider.bankDetails.iban',
        'IBAN is required.',
      );
      requireValue(
        _hasValue(bank?.bic),
        'provider.bankDetails.bic',
        'BIC is required.',
      );
      requireValue(
        _hasValue(bank?.accountOwner),
        'provider.bankDetails.accountOwner',
        'Account owner is required.',
      );
    }

    if (!company.termsAccepted) {
      _setFieldError('termsAccepted', 'Accept terms and conditions.');
      issues.add('Accept terms and conditions.');
    }
    if (!company.privacyAccepted) {
      _setFieldError('privacyAccepted', 'Accept privacy policy.');
      issues.add('Accept privacy policy.');
    }

    return issues;
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

  String _parseApiError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message =
            data['message'] ?? data['error'] ?? data['detail'] ?? '';
        final field = data['field']?.toString();
        if (field != null &&
            field.isNotEmpty &&
            message.toString().isNotEmpty) {
          _setFieldError(field, message.toString());
        }
        final errors = data['errors'];
        if (errors is Map) {
          errors.forEach((key, value) {
            final errorMessage = value?.toString() ?? 'Invalid value.';
            _setFieldError(key.toString(), errorMessage);
          });
        }
        if (message.toString().isNotEmpty) {
          return message.toString();
        }
      }
      if (data is String && data.trim().isNotEmpty) return data;
      return error.message ?? 'Registration failed.';
    }
    return error.toString();
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
