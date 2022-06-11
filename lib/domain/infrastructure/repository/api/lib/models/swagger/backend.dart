// To parse this JSON data, do
//
//     final backend = backendFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

part 'backend.freezed.dart';
part 'backend.g.dart';

@freezed
class Backend with _$Backend {
  const factory Backend({
    required String openapi,
    required Info info,
    required Paths paths,
    required Components components,
  }) = _Backend;

  factory Backend.fromJson(Map<String, dynamic> json) =>
      _$BackendFromJson(json);
}

@freezed
class Components with _$Components {
  const factory Components({
    required Schemas schemas,
  }) = _Components;

  factory Components.fromJson(Map<String, dynamic> json) =>
      _$ComponentsFromJson(json);
}

@freezed
class Schemas with _$Schemas {
  const factory Schemas({
    required AddressDto addressDto,
    required AuthenticateDto authenticateDto,
    required BankDetailsDto bankDetailsDto,
    required CompanySize companySize,
    required CompanySize companyType,
    required CreateCompanyDto createCompanyDto,
    required CreateProviderDto createProviderDto,
    required ForgotPasswordDto forgotPasswordDto,
    required CompanySize paymentInterval,
    required RegisterCompanyDto registerCompanyDto,
    required ResetPasswordDto resetPasswordDto,
    required CompanySize roles,
    required UserDto userDto,
  }) = _Schemas;

  factory Schemas.fromJson(Map<String, dynamic> json) =>
      _$SchemasFromJson(json);
}

@freezed
class AddressDto with _$AddressDto {
  const factory AddressDto({
    required String type,
    required AddressDtoProperties properties,
    required bool additionalProperties,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}

@freezed
class AddressDtoProperties with _$AddressDtoProperties {
  const factory AddressDtoProperties({
    required City country,
    required City city,
    required City street,
    required City number,
    required City zip,
  }) = _AddressDtoProperties;

  factory AddressDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoPropertiesFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    required Type type,
    required bool nullable,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

enum Type { STRING }

final typeValues = EnumValues({"string": Type.STRING});

@freezed
class AuthenticateDto with _$AuthenticateDto {
  const factory AuthenticateDto({
    required String type,
    required AuthenticateDtoProperties properties,
    required bool additionalProperties,
  }) = _AuthenticateDto;

  factory AuthenticateDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateDtoFromJson(json);
}

@freezed
class AuthenticateDtoProperties with _$AuthenticateDtoProperties {
  const factory AuthenticateDtoProperties({
    required City email,
    required City password,
  }) = _AuthenticateDtoProperties;

  factory AuthenticateDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateDtoPropertiesFromJson(json);
}

@freezed
class BankDetailsDto with _$BankDetailsDto {
  const factory BankDetailsDto({
    required String type,
    required BankDetailsDtoProperties properties,
    required bool additionalProperties,
  }) = _BankDetailsDto;

  factory BankDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsDtoFromJson(json);
}

@freezed
class BankDetailsDtoProperties with _$BankDetailsDtoProperties {
  const factory BankDetailsDtoProperties({
    required City iban,
    required City bic,
    required City accountOwner,
  }) = _BankDetailsDtoProperties;

  factory BankDetailsDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsDtoPropertiesFromJson(json);
}

@freezed
class CompanySize with _$CompanySize {
  const factory CompanySize({
    required List<int> companySizeEnum,
    required String type,
    required String format,
  }) = _CompanySize;

  factory CompanySize.fromJson(Map<String, dynamic> json) =>
      _$CompanySizeFromJson(json);
}

@freezed
class CreateCompanyDto with _$CreateCompanyDto {
  const factory CreateCompanyDto({
    required String type,
    required CreateCompanyDtoProperties properties,
    required bool additionalProperties,
  }) = _CreateCompanyDto;

  factory CreateCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCompanyDtoFromJson(json);
}

@freezed
class CreateCompanyDtoProperties with _$CreateCompanyDtoProperties {
  const factory CreateCompanyDtoProperties({
    required City name,
    required Address address,
    required City uidNr,
    required City registrationNr,
    required Address companySize,
    required Address type,
    required City websiteUrl,
    required Address providerData,
  }) = _CreateCompanyDtoProperties;

  factory CreateCompanyDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$CreateCompanyDtoPropertiesFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    required String ref,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
class CreateProviderDto with _$CreateProviderDto {
  const factory CreateProviderDto({
    required String type,
    required CreateProviderDtoProperties properties,
    required bool additionalProperties,
  }) = _CreateProviderDto;

  factory CreateProviderDto.fromJson(Map<String, dynamic> json) =>
      _$CreateProviderDtoFromJson(json);
}

@freezed
class CreateProviderDtoProperties with _$CreateProviderDtoProperties {
  const factory CreateProviderDtoProperties({
    required Address bankDetails,
    required BranchIds branchIds,
    required Address paymentInterval,
    required SubscriptionPlanId subscriptionPlanId,
  }) = _CreateProviderDtoProperties;

  factory CreateProviderDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$CreateProviderDtoPropertiesFromJson(json);
}

@freezed
class BranchIds with _$BranchIds {
  const factory BranchIds({
    required String type,
    required SubscriptionPlanId items,
    required bool nullable,
  }) = _BranchIds;

  factory BranchIds.fromJson(Map<String, dynamic> json) =>
      _$BranchIdsFromJson(json);
}

@freezed
class SubscriptionPlanId with _$SubscriptionPlanId {
  const factory SubscriptionPlanId({
    required Type type,
    required String format,
  }) = _SubscriptionPlanId;

  factory SubscriptionPlanId.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanIdFromJson(json);
}

@freezed
class ForgotPasswordDto with _$ForgotPasswordDto {
  const factory ForgotPasswordDto({
    required String type,
    required ForgotPasswordDtoProperties properties,
    required bool additionalProperties,
  }) = _ForgotPasswordDto;

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDtoFromJson(json);
}

@freezed
class ForgotPasswordDtoProperties with _$ForgotPasswordDtoProperties {
  const factory ForgotPasswordDtoProperties({
    required City email,
  }) = _ForgotPasswordDtoProperties;

  factory ForgotPasswordDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDtoPropertiesFromJson(json);
}

@freezed
class RegisterCompanyDto with _$RegisterCompanyDto {
  const factory RegisterCompanyDto({
    required String type,
    required RegisterCompanyDtoProperties properties,
    required bool additionalProperties,
  }) = _RegisterCompanyDto;

  factory RegisterCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterCompanyDtoFromJson(json);
}

@freezed
class RegisterCompanyDtoProperties with _$RegisterCompanyDtoProperties {
  const factory RegisterCompanyDtoProperties({
    required Address company,
    required Users users,
  }) = _RegisterCompanyDtoProperties;

  factory RegisterCompanyDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$RegisterCompanyDtoPropertiesFromJson(json);
}

@freezed
class Users with _$Users {
  const factory Users({
    required String type,
    required Address items,
    required bool nullable,
  }) = _Users;

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);
}

@freezed
class ResetPasswordDto with _$ResetPasswordDto {
  const factory ResetPasswordDto({
    required List<String> required,
    required String type,
    required ResetPasswordDtoProperties properties,
    required bool additionalProperties,
  }) = _ResetPasswordDto;

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDtoFromJson(json);
}

@freezed
class ResetPasswordDtoProperties with _$ResetPasswordDtoProperties {
  const factory ResetPasswordDtoProperties({
    required Password password,
    required ConfirmPassword confirmPassword,
    required City email,
    required City token,
  }) = _ResetPasswordDtoProperties;

  factory ResetPasswordDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDtoPropertiesFromJson(json);
}

@freezed
class ConfirmPassword with _$ConfirmPassword {
  const factory ConfirmPassword({
    required int maxLength,
    required Type type,
    required bool nullable,
  }) = _ConfirmPassword;

  factory ConfirmPassword.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPasswordFromJson(json);
}

@freezed
class Password with _$Password {
  const factory Password({
    required int maxLength,
    required Type type,
    required String format,
  }) = _Password;

  factory Password.fromJson(Map<String, dynamic> json) =>
      _$PasswordFromJson(json);
}

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String type,
    required UserDtoProperties properties,
    required bool additionalProperties,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

@freezed
class UserDtoProperties with _$UserDtoProperties {
  const factory UserDtoProperties({
    required City email,
    required City firstName,
    required City lastName,
    required City salutation,
    required Users roles,
    required City telephoneNr,
    required City title,
    required CompanyId companyId,
    required SubscriptionPlanId id,
  }) = _UserDtoProperties;

  factory UserDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$UserDtoPropertiesFromJson(json);
}

@freezed
class CompanyId with _$CompanyId {
  const factory CompanyId({
    required Type type,
    required String format,
    required bool nullable,
  }) = _CompanyId;

  factory CompanyId.fromJson(Map<String, dynamic> json) =>
      _$CompanyIdFromJson(json);
}

@freezed
class Info with _$Info {
  const factory Info({
    required String title,
    required String version,
  }) = _Info;

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
}

@freezed
class Paths with _$Paths {
  const factory Paths({
    required CompaniesCompanyIdRegisterUser authForgotPassword,
    required AuthConfirmEmail authConfirmEmail,
    required CompaniesCompanyIdRegisterUser authResetPassword,
    required CompaniesCompanyIdRegisterUser authLogin,
    required CompaniesRegister companiesRegister,
    required CompaniesCompanyIdUsers companiesCompanyIdUsers,
    required CompaniesCompanyIdUsersUserId companiesCompanyIdUsersUserId,
    required CompaniesCompanyIdRegisterUser companiesCompanyIdRegisterUser,
    required CompaniesCompanyIdUsersUserIdUpdate
        companiesCompanyIdUsersUserIdUpdate,
    required Companies companies,
    required CompaniesCompanyId companiesCompanyId,
    required Companies subscriptions,
    required CompaniesCompanyId usersLoadUserWithCompany,
  }) = _Paths;

  factory Paths.fromJson(Map<String, dynamic> json) => _$PathsFromJson(json);
}

@freezed
class AuthConfirmEmail with _$AuthConfirmEmail {
  const factory AuthConfirmEmail({
    required AuthConfirmEmailGet authConfirmEmailGet,
  }) = _AuthConfirmEmail;

  factory AuthConfirmEmail.fromJson(Map<String, dynamic> json) =>
      _$AuthConfirmEmailFromJson(json);
}

@freezed
class AuthConfirmEmailGet with _$AuthConfirmEmailGet {
  const factory AuthConfirmEmailGet({
    required List<String> tags,
    required List<PostParameter> parameters,
    required Responses responses,
  }) = _AuthConfirmEmailGet;

  factory AuthConfirmEmailGet.fromJson(Map<String, dynamic> json) =>
      _$AuthConfirmEmailGetFromJson(json);
}

@freezed
class PostParameter with _$PostParameter {
  const factory PostParameter({
    required String name,
    required String parameterIn,
    required bool required,
    required Schema schema,
  }) = _PostParameter;

  factory PostParameter.fromJson(Map<String, dynamic> json) =>
      _$PostParameterFromJson(json);
}

@freezed
class Schema with _$Schema {
  const factory Schema({
    required Type type,
  }) = _Schema;

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
}

@freezed
class Responses with _$Responses {
  const factory Responses({
    required The200 the200,
  }) = _Responses;

  factory Responses.fromJson(Map<String, dynamic> json) =>
      _$ResponsesFromJson(json);
}

@freezed
class The200 with _$The200 {
  const factory The200({
    required Description description,
  }) = _The200;

  factory The200.fromJson(Map<String, dynamic> json) => _$The200FromJson(json);
}

enum Description { SUCCESS }

final descriptionValues = EnumValues({"Success": Description.SUCCESS});

@freezed
class CompaniesCompanyIdRegisterUser with _$CompaniesCompanyIdRegisterUser {
  const factory CompaniesCompanyIdRegisterUser({
    required GetClass post,
  }) = _CompaniesCompanyIdRegisterUser;

  factory CompaniesCompanyIdRegisterUser.fromJson(Map<String, dynamic> json) =>
      _$CompaniesCompanyIdRegisterUserFromJson(json);
}

@freezed
class GetClass with _$GetClass {
  const factory GetClass({
    required List<String> tags,
    required List<PostParameter> parameters,
    required GetRequestBody requestBody,
    required Responses responses,
  }) = _GetClass;

  factory GetClass.fromJson(Map<String, dynamic> json) =>
      _$GetClassFromJson(json);
}

@freezed
class GetRequestBody with _$GetRequestBody {
  const factory GetRequestBody({
    required Content content,
  }) = _GetRequestBody;

  factory GetRequestBody.fromJson(Map<String, dynamic> json) =>
      _$GetRequestBodyFromJson(json);
}

@freezed
class Content with _$Content {
  const factory Content({
    required Json contentApplicationJson,
    required Json textJson,
    required Json applicationJson,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@freezed
class Json with _$Json {
  const factory Json({
    required Address schema,
  }) = _Json;

  factory Json.fromJson(Map<String, dynamic> json) => _$JsonFromJson(json);
}

@freezed
class Companies with _$Companies {
  const factory Companies({
    required CompaniesGet companiesGet,
  }) = _Companies;

  factory Companies.fromJson(Map<String, dynamic> json) =>
      _$CompaniesFromJson(json);
}

@freezed
class CompaniesGet with _$CompaniesGet {
  const factory CompaniesGet({
    required List<String> tags,
    required Responses responses,
  }) = _CompaniesGet;

  factory CompaniesGet.fromJson(Map<String, dynamic> json) =>
      _$CompaniesGetFromJson(json);
}

@freezed
class CompaniesCompanyId with _$CompaniesCompanyId {
  const factory CompaniesCompanyId({
    required CompaniesCompanyIdGet companiesCompanyIdGet,
  }) = _CompaniesCompanyId;

  factory CompaniesCompanyId.fromJson(Map<String, dynamic> json) =>
      _$CompaniesCompanyIdFromJson(json);
}

@freezed
class CompaniesCompanyIdGet with _$CompaniesCompanyIdGet {
  const factory CompaniesCompanyIdGet({
    required List<String> tags,
    required List<DeleteParameter> parameters,
    required Responses responses,
  }) = _CompaniesCompanyIdGet;

  factory CompaniesCompanyIdGet.fromJson(Map<String, dynamic> json) =>
      _$CompaniesCompanyIdGetFromJson(json);
}

@freezed
class DeleteParameter with _$DeleteParameter {
  const factory DeleteParameter({
    required String name,
    required String parameterIn,
    required bool required,
    required SubscriptionPlanId schema,
  }) = _DeleteParameter;

  factory DeleteParameter.fromJson(Map<String, dynamic> json) =>
      _$DeleteParameterFromJson(json);
}

@freezed
class CompaniesCompanyIdUsers with _$CompaniesCompanyIdUsers {
  const factory CompaniesCompanyIdUsers({
    required GetClass companiesCompanyIdUsersGet,
  }) = _CompaniesCompanyIdUsers;

  factory CompaniesCompanyIdUsers.fromJson(Map<String, dynamic> json) =>
      _$CompaniesCompanyIdUsersFromJson(json);
}

@freezed
class CompaniesCompanyIdUsersUserId with _$CompaniesCompanyIdUsersUserId {
  const factory CompaniesCompanyIdUsersUserId({
    required Delete companiesCompanyIdUsersUserIdGet,
    required Delete delete,
  }) = _CompaniesCompanyIdUsersUserId;

  factory CompaniesCompanyIdUsersUserId.fromJson(Map<String, dynamic> json) =>
      _$CompaniesCompanyIdUsersUserIdFromJson(json);
}

@freezed
class Delete with _$Delete {
  const factory Delete({
    required List<String> tags,
    required List<DeleteParameter> parameters,
    required Responses responses,
    required GetRequestBody requestBody,
  }) = _Delete;

  factory Delete.fromJson(Map<String, dynamic> json) => _$DeleteFromJson(json);
}

@freezed
class CompaniesCompanyIdUsersUserIdUpdate
    with _$CompaniesCompanyIdUsersUserIdUpdate {
  const factory CompaniesCompanyIdUsersUserIdUpdate({
    required Delete put,
  }) = _CompaniesCompanyIdUsersUserIdUpdate;

  factory CompaniesCompanyIdUsersUserIdUpdate.fromJson(
          Map<String, dynamic> json) =>
      _$CompaniesCompanyIdUsersUserIdUpdateFromJson(json);
}

@freezed
class CompaniesRegister with _$CompaniesRegister {
  const factory CompaniesRegister({
    required CompaniesRegisterPost post,
  }) = _CompaniesRegister;

  factory CompaniesRegister.fromJson(Map<String, dynamic> json) =>
      _$CompaniesRegisterFromJson(json);
}

@freezed
class CompaniesRegisterPost with _$CompaniesRegisterPost {
  const factory CompaniesRegisterPost({
    required List<String> tags,
    required PurpleRequestBody requestBody,
    required Responses responses,
  }) = _CompaniesRegisterPost;

  factory CompaniesRegisterPost.fromJson(Map<String, dynamic> json) =>
      _$CompaniesRegisterPostFromJson(json);
}

@freezed
class PurpleRequestBody with _$PurpleRequestBody {
  const factory PurpleRequestBody({
    required Content content,
    required bool required,
  }) = _PurpleRequestBody;

  factory PurpleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$PurpleRequestBodyFromJson(json);
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
