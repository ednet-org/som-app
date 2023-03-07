// To parse this JSON data, do
//
//     final api = apiFromJson(jsonString);

import 'dart:convert';

class Api {
  Api({
    required this.components,
    required this.info,
    required this.openapi,
    required this.paths,
  });

  Components components;
  Info info;
  String openapi;
  Paths paths;

  factory Api.fromRawJson(String str) => Api.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Api.fromJson(Map<String, dynamic> json) => Api(
        components: Components.fromJson(json["components"]),
        info: Info.fromJson(json["info"]),
        openapi: json["openapi"],
        paths: Paths.fromJson(json["paths"]),
      );

  Map<String, dynamic> toJson() => {
        "components": components.toJson(),
        "info": info.toJson(),
        "openapi": openapi,
        "paths": paths.toJson(),
      };
}

class Components {
  Components({
    required this.schemas,
  });

  Schemas schemas;

  factory Components.fromRawJson(String str) =>
      Components.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Components.fromJson(Map<String, dynamic> json) => Components(
        schemas: Schemas.fromJson(json["schemas"]),
      );

  Map<String, dynamic> toJson() => {
        "schemas": schemas.toJson(),
      };
}

class Schemas {
  Schemas({
    required this.addressDto,
    required this.authenticateDto,
    required this.bankDetailsDto,
    required this.companySize,
    required this.companyType,
    required this.createCompanyDto,
    required this.createProviderDto,
    required this.forgotPasswordDto,
    required this.paymentInterval,
    required this.registerCompanyDto,
    required this.resetPasswordDto,
    required this.roles,
    required this.userDto,
  });

  AddressDto addressDto;
  AuthenticateDto authenticateDto;
  BankDetailsDto bankDetailsDto;
  CompanySize companySize;
  CompanyType companyType;
  CreateCompanyDto createCompanyDto;
  CreateProviderDto createProviderDto;
  ForgotPasswordDto forgotPasswordDto;
  PaymentIntervalClass paymentInterval;
  RegisterCompanyDto registerCompanyDto;
  ResetPasswordDto resetPasswordDto;
  Roles roles;
  UserDto userDto;

  factory Schemas.fromRawJson(String str) => Schemas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schemas.fromJson(Map<String, dynamic> json) => Schemas(
        addressDto: AddressDto.fromJson(json["AddressDto"]),
        authenticateDto: AuthenticateDto.fromJson(json["AuthenticateDto"]),
        bankDetailsDto: BankDetailsDto.fromJson(json["BankDetailsDto"]),
        companySize: CompanySize.fromJson(json["CompanySize"]),
        companyType: CompanyType.fromJson(json["CompanyType"]),
        createCompanyDto: CreateCompanyDto.fromJson(json["CreateCompanyDto"]),
        createProviderDto:
            CreateProviderDto.fromJson(json["CreateProviderDto"]),
        forgotPasswordDto:
            ForgotPasswordDto.fromJson(json["ForgotPasswordDto"]),
        paymentInterval: PaymentIntervalClass.fromJson(json["PaymentInterval"]),
        registerCompanyDto:
            RegisterCompanyDto.fromJson(json["RegisterCompanyDto"]),
        resetPasswordDto: ResetPasswordDto.fromJson(json["ResetPasswordDto"]),
        roles: Roles.fromJson(json["Roles"]),
        userDto: UserDto.fromJson(json["UserDto"]),
      );

  Map<String, dynamic> toJson() => {
        "AddressDto": addressDto.toJson(),
        "AuthenticateDto": authenticateDto.toJson(),
        "BankDetailsDto": bankDetailsDto.toJson(),
        "CompanySize": companySize.toJson(),
        "CompanyType": companyType.toJson(),
        "CreateCompanyDto": createCompanyDto.toJson(),
        "CreateProviderDto": createProviderDto.toJson(),
        "ForgotPasswordDto": forgotPasswordDto.toJson(),
        "PaymentInterval": paymentInterval.toJson(),
        "RegisterCompanyDto": registerCompanyDto.toJson(),
        "ResetPasswordDto": resetPasswordDto.toJson(),
        "Roles": roles.toJson(),
        "UserDto": userDto.toJson(),
      };
}

class AddressDto {
  AddressDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  AddressDtoProperties properties;
  String type;

  factory AddressDto.fromRawJson(String str) =>
      AddressDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressDto.fromJson(Map<String, dynamic> json) => AddressDto(
        additionalProperties: json["additionalProperties"],
        properties: AddressDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class AddressDtoProperties {
  AddressDtoProperties({
    required this.city,
    required this.country,
    required this.number,
    required this.street,
    required this.zip,
  });

  City city;
  Country country;
  Number number;
  Street street;
  Zip zip;

  factory AddressDtoProperties.fromRawJson(String str) =>
      AddressDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressDtoProperties.fromJson(Map<String, dynamic> json) =>
      AddressDtoProperties(
        city: City.fromJson(json["city"]),
        country: Country.fromJson(json["country"]),
        number: Number.fromJson(json["number"]),
        street: Street.fromJson(json["street"]),
        zip: Zip.fromJson(json["zip"]),
      );

  Map<String, dynamic> toJson() => {
        "city": city.toJson(),
        "country": country.toJson(),
        "number": number.toJson(),
        "street": street.toJson(),
        "zip": zip.toJson(),
      };
}

class City {
  City({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) => City(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Country {
  Country({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Number {
  Number({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Number.fromRawJson(String str) => Number.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Number.fromJson(Map<String, dynamic> json) => Number(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Street {
  Street({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Street.fromRawJson(String str) => Street.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Street.fromJson(Map<String, dynamic> json) => Street(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Zip {
  Zip({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Zip.fromRawJson(String str) => Zip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Zip.fromJson(Map<String, dynamic> json) => Zip(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class AuthenticateDto {
  AuthenticateDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  AuthenticateDtoProperties properties;
  String type;

  factory AuthenticateDto.fromRawJson(String str) =>
      AuthenticateDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthenticateDto.fromJson(Map<String, dynamic> json) =>
      AuthenticateDto(
        additionalProperties: json["additionalProperties"],
        properties: AuthenticateDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class AuthenticateDtoProperties {
  AuthenticateDtoProperties({
    required this.email,
    required this.password,
  });

  PurpleEmail email;
  PurplePassword password;

  factory AuthenticateDtoProperties.fromRawJson(String str) =>
      AuthenticateDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthenticateDtoProperties.fromJson(Map<String, dynamic> json) =>
      AuthenticateDtoProperties(
        email: PurpleEmail.fromJson(json["email"]),
        password: PurplePassword.fromJson(json["password"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email.toJson(),
        "password": password.toJson(),
      };
}

class PurpleEmail {
  PurpleEmail({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory PurpleEmail.fromRawJson(String str) =>
      PurpleEmail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleEmail.fromJson(Map<String, dynamic> json) => PurpleEmail(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class PurplePassword {
  PurplePassword({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory PurplePassword.fromRawJson(String str) =>
      PurplePassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurplePassword.fromJson(Map<String, dynamic> json) => PurplePassword(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class BankDetailsDto {
  BankDetailsDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  BankDetailsDtoProperties properties;
  String type;

  factory BankDetailsDto.fromRawJson(String str) =>
      BankDetailsDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetailsDto.fromJson(Map<String, dynamic> json) => BankDetailsDto(
        additionalProperties: json["additionalProperties"],
        properties: BankDetailsDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class BankDetailsDtoProperties {
  BankDetailsDtoProperties({
    required this.accountOwner,
    required this.bic,
    required this.iban,
  });

  AccountOwner accountOwner;
  Bic bic;
  Iban iban;

  factory BankDetailsDtoProperties.fromRawJson(String str) =>
      BankDetailsDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetailsDtoProperties.fromJson(Map<String, dynamic> json) =>
      BankDetailsDtoProperties(
        accountOwner: AccountOwner.fromJson(json["accountOwner"]),
        bic: Bic.fromJson(json["bic"]),
        iban: Iban.fromJson(json["iban"]),
      );

  Map<String, dynamic> toJson() => {
        "accountOwner": accountOwner.toJson(),
        "bic": bic.toJson(),
        "iban": iban.toJson(),
      };
}

class AccountOwner {
  AccountOwner({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory AccountOwner.fromRawJson(String str) =>
      AccountOwner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountOwner.fromJson(Map<String, dynamic> json) => AccountOwner(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Bic {
  Bic({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Bic.fromRawJson(String str) => Bic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bic.fromJson(Map<String, dynamic> json) => Bic(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Iban {
  Iban({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Iban.fromRawJson(String str) => Iban.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Iban.fromJson(Map<String, dynamic> json) => Iban(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class CompanySize {
  CompanySize({
    required this.companySizeEnum,
    required this.format,
    required this.type,
  });

  List<int> companySizeEnum;
  String format;
  String type;

  factory CompanySize.fromRawJson(String str) =>
      CompanySize.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanySize.fromJson(Map<String, dynamic> json) => CompanySize(
        companySizeEnum: List<int>.from(json["enum"].map((x) => x)),
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "enum": List<dynamic>.from(companySizeEnum.map((x) => x)),
        "format": format,
        "type": type,
      };
}

class CompanyType {
  CompanyType({
    required this.companyTypeEnum,
    required this.format,
    required this.type,
  });

  List<int> companyTypeEnum;
  String format;
  String type;

  factory CompanyType.fromRawJson(String str) =>
      CompanyType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyType.fromJson(Map<String, dynamic> json) => CompanyType(
        companyTypeEnum: List<int>.from(json["enum"].map((x) => x)),
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "enum": List<dynamic>.from(companyTypeEnum.map((x) => x)),
        "format": format,
        "type": type,
      };
}

class CreateCompanyDto {
  CreateCompanyDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  CreateCompanyDtoProperties properties;
  String type;

  factory CreateCompanyDto.fromRawJson(String str) =>
      CreateCompanyDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCompanyDto.fromJson(Map<String, dynamic> json) =>
      CreateCompanyDto(
        additionalProperties: json["additionalProperties"],
        properties: CreateCompanyDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class CreateCompanyDtoProperties {
  CreateCompanyDtoProperties({
    required this.address,
    required this.companySize,
    required this.name,
    required this.providerData,
    required this.registrationNr,
    required this.type,
    required this.uidNr,
    required this.websiteUrl,
  });

  Address address;
  CompanySizeClass companySize;
  Name name;
  ProviderData providerData;
  RegistrationNr registrationNr;
  Type type;
  UidNr uidNr;
  WebsiteUrl websiteUrl;

  factory CreateCompanyDtoProperties.fromRawJson(String str) =>
      CreateCompanyDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCompanyDtoProperties.fromJson(Map<String, dynamic> json) =>
      CreateCompanyDtoProperties(
        address: Address.fromJson(json["address"]),
        companySize: CompanySizeClass.fromJson(json["companySize"]),
        name: Name.fromJson(json["name"]),
        providerData: ProviderData.fromJson(json["providerData"]),
        registrationNr: RegistrationNr.fromJson(json["registrationNr"]),
        type: Type.fromJson(json["type"]),
        uidNr: UidNr.fromJson(json["uidNr"]),
        websiteUrl: WebsiteUrl.fromJson(json["websiteUrl"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "companySize": companySize.toJson(),
        "name": name.toJson(),
        "providerData": providerData.toJson(),
        "registrationNr": registrationNr.toJson(),
        "type": type.toJson(),
        "uidNr": uidNr.toJson(),
        "websiteUrl": websiteUrl.toJson(),
      };
}

class Address {
  Address({
    required this.ref,
  });

  String ref;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class CompanySizeClass {
  CompanySizeClass({
    required this.ref,
  });

  String ref;

  factory CompanySizeClass.fromRawJson(String str) =>
      CompanySizeClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanySizeClass.fromJson(Map<String, dynamic> json) =>
      CompanySizeClass(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class Name {
  Name({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Name.fromRawJson(String str) => Name.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class ProviderData {
  ProviderData({
    required this.ref,
  });

  String ref;

  factory ProviderData.fromRawJson(String str) =>
      ProviderData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProviderData.fromJson(Map<String, dynamic> json) => ProviderData(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class RegistrationNr {
  RegistrationNr({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory RegistrationNr.fromRawJson(String str) =>
      RegistrationNr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistrationNr.fromJson(Map<String, dynamic> json) => RegistrationNr(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Type {
  Type({
    required this.ref,
  });

  String ref;

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class UidNr {
  UidNr({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory UidNr.fromRawJson(String str) => UidNr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UidNr.fromJson(Map<String, dynamic> json) => UidNr(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class WebsiteUrl {
  WebsiteUrl({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory WebsiteUrl.fromRawJson(String str) =>
      WebsiteUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebsiteUrl.fromJson(Map<String, dynamic> json) => WebsiteUrl(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class CreateProviderDto {
  CreateProviderDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  CreateProviderDtoProperties properties;
  String type;

  factory CreateProviderDto.fromRawJson(String str) =>
      CreateProviderDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateProviderDto.fromJson(Map<String, dynamic> json) =>
      CreateProviderDto(
        additionalProperties: json["additionalProperties"],
        properties: CreateProviderDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class CreateProviderDtoProperties {
  CreateProviderDtoProperties({
    required this.bankDetails,
    required this.branchIds,
    required this.paymentInterval,
    required this.subscriptionPlanId,
  });

  BankDetails bankDetails;
  BranchIds branchIds;
  PaymentInterval paymentInterval;
  SubscriptionPlanId subscriptionPlanId;

  factory CreateProviderDtoProperties.fromRawJson(String str) =>
      CreateProviderDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateProviderDtoProperties.fromJson(Map<String, dynamic> json) =>
      CreateProviderDtoProperties(
        bankDetails: BankDetails.fromJson(json["bankDetails"]),
        branchIds: BranchIds.fromJson(json["branchIds"]),
        paymentInterval: PaymentInterval.fromJson(json["paymentInterval"]),
        subscriptionPlanId:
            SubscriptionPlanId.fromJson(json["subscriptionPlanId"]),
      );

  Map<String, dynamic> toJson() => {
        "bankDetails": bankDetails.toJson(),
        "branchIds": branchIds.toJson(),
        "paymentInterval": paymentInterval.toJson(),
        "subscriptionPlanId": subscriptionPlanId.toJson(),
      };
}

class BankDetails {
  BankDetails({
    required this.ref,
  });

  String ref;

  factory BankDetails.fromRawJson(String str) =>
      BankDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class BranchIds {
  BranchIds({
    required this.items,
    required this.nullable,
    required this.type,
  });

  BranchIdsItems items;
  bool nullable;
  String type;

  factory BranchIds.fromRawJson(String str) =>
      BranchIds.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchIds.fromJson(Map<String, dynamic> json) => BranchIds(
        items: BranchIdsItems.fromJson(json["attributes"]),
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "attributes": items.toJson(),
        "nullable": nullable,
        "type": type,
      };
}

class BranchIdsItems {
  BranchIdsItems({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory BranchIdsItems.fromRawJson(String str) =>
      BranchIdsItems.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchIdsItems.fromJson(Map<String, dynamic> json) => BranchIdsItems(
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "type": type,
      };
}

class PaymentInterval {
  PaymentInterval({
    required this.ref,
  });

  String ref;

  factory PaymentInterval.fromRawJson(String str) =>
      PaymentInterval.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentInterval.fromJson(Map<String, dynamic> json) =>
      PaymentInterval(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class SubscriptionPlanId {
  SubscriptionPlanId({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory SubscriptionPlanId.fromRawJson(String str) =>
      SubscriptionPlanId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPlanId.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanId(
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "type": type,
      };
}

class ForgotPasswordDto {
  ForgotPasswordDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  ForgotPasswordDtoProperties properties;
  String type;

  factory ForgotPasswordDto.fromRawJson(String str) =>
      ForgotPasswordDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordDto(
        additionalProperties: json["additionalProperties"],
        properties: ForgotPasswordDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class ForgotPasswordDtoProperties {
  ForgotPasswordDtoProperties({
    required this.email,
  });

  FluffyEmail email;

  factory ForgotPasswordDtoProperties.fromRawJson(String str) =>
      ForgotPasswordDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordDtoProperties.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordDtoProperties(
        email: FluffyEmail.fromJson(json["email"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email.toJson(),
      };
}

class FluffyEmail {
  FluffyEmail({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory FluffyEmail.fromRawJson(String str) =>
      FluffyEmail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyEmail.fromJson(Map<String, dynamic> json) => FluffyEmail(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class PaymentIntervalClass {
  PaymentIntervalClass({
    required this.paymentIntervalEnum,
    required this.format,
    required this.type,
  });

  List<int> paymentIntervalEnum;
  String format;
  String type;

  factory PaymentIntervalClass.fromRawJson(String str) =>
      PaymentIntervalClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentIntervalClass.fromJson(Map<String, dynamic> json) =>
      PaymentIntervalClass(
        paymentIntervalEnum: List<int>.from(json["enum"].map((x) => x)),
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "enum": List<dynamic>.from(paymentIntervalEnum.map((x) => x)),
        "format": format,
        "type": type,
      };
}

class RegisterCompanyDto {
  RegisterCompanyDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  RegisterCompanyDtoProperties properties;
  String type;

  factory RegisterCompanyDto.fromRawJson(String str) =>
      RegisterCompanyDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterCompanyDto.fromJson(Map<String, dynamic> json) =>
      RegisterCompanyDto(
        additionalProperties: json["additionalProperties"],
        properties: RegisterCompanyDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class RegisterCompanyDtoProperties {
  RegisterCompanyDtoProperties({
    required this.company,
    required this.users,
  });

  Company company;
  Users users;

  factory RegisterCompanyDtoProperties.fromRawJson(String str) =>
      RegisterCompanyDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterCompanyDtoProperties.fromJson(Map<String, dynamic> json) =>
      RegisterCompanyDtoProperties(
        company: Company.fromJson(json["company"]),
        users: Users.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "company": company.toJson(),
        "users": users.toJson(),
      };
}

class Company {
  Company({
    required this.ref,
  });

  String ref;

  factory Company.fromRawJson(String str) => Company.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class Users {
  Users({
    required this.items,
    required this.nullable,
    required this.type,
  });

  UsersItems items;
  bool nullable;
  String type;

  factory Users.fromRawJson(String str) => Users.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        items: UsersItems.fromJson(json["attributes"]),
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "attributes": items.toJson(),
        "nullable": nullable,
        "type": type,
      };
}

class UsersItems {
  UsersItems({
    required this.ref,
  });

  String ref;

  factory UsersItems.fromRawJson(String str) =>
      UsersItems.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsersItems.fromJson(Map<String, dynamic> json) => UsersItems(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class ResetPasswordDto {
  ResetPasswordDto({
    required this.additionalProperties,
    required this.properties,
    required this.required,
    required this.type,
  });

  bool additionalProperties;
  ResetPasswordDtoProperties properties;
  List<String> required;
  String type;

  factory ResetPasswordDto.fromRawJson(String str) =>
      ResetPasswordDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      ResetPasswordDto(
        additionalProperties: json["additionalProperties"],
        properties: ResetPasswordDtoProperties.fromJson(json["properties"]),
        required: List<String>.from(json["required"].map((x) => x)),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "required": List<dynamic>.from(required.map((x) => x)),
        "type": type,
      };
}

class ResetPasswordDtoProperties {
  ResetPasswordDtoProperties({
    required this.confirmPassword,
    required this.email,
    required this.password,
    required this.token,
  });

  ConfirmPassword confirmPassword;
  TentacledEmail email;
  FluffyPassword password;
  Token token;

  factory ResetPasswordDtoProperties.fromRawJson(String str) =>
      ResetPasswordDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResetPasswordDtoProperties.fromJson(Map<String, dynamic> json) =>
      ResetPasswordDtoProperties(
        confirmPassword: ConfirmPassword.fromJson(json["confirmPassword"]),
        email: TentacledEmail.fromJson(json["email"]),
        password: FluffyPassword.fromJson(json["password"]),
        token: Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "confirmPassword": confirmPassword.toJson(),
        "email": email.toJson(),
        "password": password.toJson(),
        "token": token.toJson(),
      };
}

class ConfirmPassword {
  ConfirmPassword({
    required this.maxLength,
    required this.nullable,
    required this.type,
  });

  int maxLength;
  bool nullable;
  String type;

  factory ConfirmPassword.fromRawJson(String str) =>
      ConfirmPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfirmPassword.fromJson(Map<String, dynamic> json) =>
      ConfirmPassword(
        maxLength: json["maxLength"],
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "maxLength": maxLength,
        "nullable": nullable,
        "type": type,
      };
}

class TentacledEmail {
  TentacledEmail({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory TentacledEmail.fromRawJson(String str) =>
      TentacledEmail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledEmail.fromJson(Map<String, dynamic> json) => TentacledEmail(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class FluffyPassword {
  FluffyPassword({
    required this.format,
    required this.maxLength,
    required this.type,
  });

  String format;
  int maxLength;
  String type;

  factory FluffyPassword.fromRawJson(String str) =>
      FluffyPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyPassword.fromJson(Map<String, dynamic> json) => FluffyPassword(
        format: json["format"],
        maxLength: json["maxLength"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "maxLength": maxLength,
        "type": type,
      };
}

class Token {
  Token({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Token.fromRawJson(String str) => Token.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Roles {
  Roles({
    required this.rolesEnum,
    required this.format,
    required this.type,
  });

  List<int> rolesEnum;
  String format;
  String type;

  factory Roles.fromRawJson(String str) => Roles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        rolesEnum: List<int>.from(json["enum"].map((x) => x)),
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "enum": List<dynamic>.from(rolesEnum.map((x) => x)),
        "format": format,
        "type": type,
      };
}

class UserDto {
  UserDto({
    required this.additionalProperties,
    required this.properties,
    required this.type,
  });

  bool additionalProperties;
  UserDtoProperties properties;
  String type;

  factory UserDto.fromRawJson(String str) => UserDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        additionalProperties: json["additionalProperties"],
        properties: UserDtoProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProperties": additionalProperties,
        "properties": properties.toJson(),
        "type": type,
      };
}

class UserDtoProperties {
  UserDtoProperties({
    required this.companyId,
    required this.email,
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.roles,
    required this.salutation,
    required this.telephoneNr,
    required this.title,
  });

  CompanyId companyId;
  StickyEmail email;
  FirstName firstName;
  Id id;
  LastName lastName;
  RolesClass roles;
  Salutation salutation;
  TelephoneNr telephoneNr;
  Title title;

  factory UserDtoProperties.fromRawJson(String str) =>
      UserDtoProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDtoProperties.fromJson(Map<String, dynamic> json) =>
      UserDtoProperties(
        companyId: CompanyId.fromJson(json["companyId"]),
        email: StickyEmail.fromJson(json["email"]),
        firstName: FirstName.fromJson(json["firstName"]),
        id: Id.fromJson(json["id"]),
        lastName: LastName.fromJson(json["lastName"]),
        roles: RolesClass.fromJson(json["roles"]),
        salutation: Salutation.fromJson(json["salutation"]),
        telephoneNr: TelephoneNr.fromJson(json["telephoneNr"]),
        title: Title.fromJson(json["title"]),
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId.toJson(),
        "email": email.toJson(),
        "firstName": firstName.toJson(),
        "id": id.toJson(),
        "lastName": lastName.toJson(),
        "roles": roles.toJson(),
        "salutation": salutation.toJson(),
        "telephoneNr": telephoneNr.toJson(),
        "title": title.toJson(),
      };
}

class CompanyId {
  CompanyId({
    required this.format,
    required this.nullable,
    required this.type,
  });

  String format;
  bool nullable;
  String type;

  factory CompanyId.fromRawJson(String str) =>
      CompanyId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyId.fromJson(Map<String, dynamic> json) => CompanyId(
        format: json["format"],
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "nullable": nullable,
        "type": type,
      };
}

class StickyEmail {
  StickyEmail({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory StickyEmail.fromRawJson(String str) =>
      StickyEmail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyEmail.fromJson(Map<String, dynamic> json) => StickyEmail(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class FirstName {
  FirstName({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory FirstName.fromRawJson(String str) =>
      FirstName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FirstName.fromJson(Map<String, dynamic> json) => FirstName(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Id {
  Id({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory Id.fromRawJson(String str) => Id.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "type": type,
      };
}

class LastName {
  LastName({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory LastName.fromRawJson(String str) =>
      LastName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastName.fromJson(Map<String, dynamic> json) => LastName(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class RolesClass {
  RolesClass({
    required this.items,
    required this.nullable,
    required this.type,
  });

  RolesItems items;
  bool nullable;
  String type;

  factory RolesClass.fromRawJson(String str) =>
      RolesClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RolesClass.fromJson(Map<String, dynamic> json) => RolesClass(
        items: RolesItems.fromJson(json["attributes"]),
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "attributes": items.toJson(),
        "nullable": nullable,
        "type": type,
      };
}

class RolesItems {
  RolesItems({
    required this.ref,
  });

  String ref;

  factory RolesItems.fromRawJson(String str) =>
      RolesItems.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RolesItems.fromJson(Map<String, dynamic> json) => RolesItems(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class Salutation {
  Salutation({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Salutation.fromRawJson(String str) =>
      Salutation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Salutation.fromJson(Map<String, dynamic> json) => Salutation(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class TelephoneNr {
  TelephoneNr({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory TelephoneNr.fromRawJson(String str) =>
      TelephoneNr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TelephoneNr.fromJson(Map<String, dynamic> json) => TelephoneNr(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Title {
  Title({
    required this.nullable,
    required this.type,
  });

  bool nullable;
  String type;

  factory Title.fromRawJson(String str) => Title.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        nullable: json["nullable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "nullable": nullable,
        "type": type,
      };
}

class Info {
  Info({
    required this.title,
    required this.version,
  });

  String title;
  String version;

  factory Info.fromRawJson(String str) => Info.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        title: json["title"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "version": version,
      };
}

class Paths {
  Paths({
    required this.authConfirmEmail,
    required this.authForgotPassword,
    required this.authLogin,
    required this.authResetPassword,
    required this.companies,
    required this.companiesRegister,
    required this.companiesCompanyId,
    required this.companiesCompanyIdRegisterUser,
    required this.companiesCompanyIdUsers,
    required this.companiesCompanyIdUsersUserId,
    required this.companiesCompanyIdUsersUserIdUpdate,
    required this.subscriptions,
    required this.usersLoadUserWithCompany,
  });

  AuthConfirmEmail authConfirmEmail;
  AuthForgotPassword authForgotPassword;
  AuthLogin authLogin;
  AuthResetPassword authResetPassword;
  Companies companies;
  CompaniesRegister companiesRegister;
  CompaniesCompanyId companiesCompanyId;
  CompaniesCompanyIdRegisterUser companiesCompanyIdRegisterUser;
  CompaniesCompanyIdUsers companiesCompanyIdUsers;
  CompaniesCompanyIdUsersUserId companiesCompanyIdUsersUserId;
  CompaniesCompanyIdUsersUserIdUpdate companiesCompanyIdUsersUserIdUpdate;
  Subscriptions subscriptions;
  UsersLoadUserWithCompany usersLoadUserWithCompany;

  factory Paths.fromRawJson(String str) => Paths.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Paths.fromJson(Map<String, dynamic> json) => Paths(
        authConfirmEmail: AuthConfirmEmail.fromJson(json["/auth/confirmEmail"]),
        authForgotPassword:
            AuthForgotPassword.fromJson(json["/auth/forgotPassword"]),
        authLogin: AuthLogin.fromJson(json["/auth/login"]),
        authResetPassword:
            AuthResetPassword.fromJson(json["/auth/resetPassword"]),
        companies: Companies.fromJson(json["/Companies"]),
        companiesRegister:
            CompaniesRegister.fromJson(json["/Companies/register"]),
        companiesCompanyId:
            CompaniesCompanyId.fromJson(json["/Companies/{companyId}"]),
        companiesCompanyIdRegisterUser: CompaniesCompanyIdRegisterUser.fromJson(
            json["/Companies/{companyId}/registerUser"]),
        companiesCompanyIdUsers: CompaniesCompanyIdUsers.fromJson(
            json["/Companies/{companyId}/users"]),
        companiesCompanyIdUsersUserId: CompaniesCompanyIdUsersUserId.fromJson(
            json["/Companies/{companyId}/users/{userId}"]),
        companiesCompanyIdUsersUserIdUpdate:
            CompaniesCompanyIdUsersUserIdUpdate.fromJson(
                json["/Companies/{companyId}/users/{userId}/update"]),
        subscriptions: Subscriptions.fromJson(json["/Subscriptions"]),
        usersLoadUserWithCompany: UsersLoadUserWithCompany.fromJson(
            json["/Users/loadUserWithCompany"]),
      );

  Map<String, dynamic> toJson() => {
        "/auth/confirmEmail": authConfirmEmail.toJson(),
        "/auth/forgotPassword": authForgotPassword.toJson(),
        "/auth/login": authLogin.toJson(),
        "/auth/resetPassword": authResetPassword.toJson(),
        "/Companies": companies.toJson(),
        "/Companies/register": companiesRegister.toJson(),
        "/Companies/{companyId}": companiesCompanyId.toJson(),
        "/Companies/{companyId}/registerUser":
            companiesCompanyIdRegisterUser.toJson(),
        "/Companies/{companyId}/users": companiesCompanyIdUsers.toJson(),
        "/Companies/{companyId}/users/{userId}":
            companiesCompanyIdUsersUserId.toJson(),
        "/Companies/{companyId}/users/{userId}/update":
            companiesCompanyIdUsersUserIdUpdate.toJson(),
        "/Subscriptions": subscriptions.toJson(),
        "/Users/loadUserWithCompany": usersLoadUserWithCompany.toJson(),
      };
}

class AuthConfirmEmail {
  AuthConfirmEmail({
    required this.authConfirmEmailGet,
  });

  AuthConfirmEmailGet authConfirmEmailGet;

  factory AuthConfirmEmail.fromRawJson(String str) =>
      AuthConfirmEmail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthConfirmEmail.fromJson(Map<String, dynamic> json) =>
      AuthConfirmEmail(
        authConfirmEmailGet: AuthConfirmEmailGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "get": authConfirmEmailGet.toJson(),
      };
}

class AuthConfirmEmailGet {
  AuthConfirmEmailGet({
    required this.parameters,
    required this.responses,
    required this.tags,
  });

  List<IndigoParameter> parameters;
  CunningResponses responses;
  List<String> tags;

  factory AuthConfirmEmailGet.fromRawJson(String str) =>
      AuthConfirmEmailGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthConfirmEmailGet.fromJson(Map<String, dynamic> json) =>
      AuthConfirmEmailGet(
        parameters: List<IndigoParameter>.from(
            json["parameters"].map((x) => IndigoParameter.fromJson(x))),
        responses: CunningResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class IndigoParameter {
  IndigoParameter({
    required this.parameterIn,
    required this.name,
    required this.schema,
  });

  String parameterIn;
  String name;
  Schema4 schema;

  factory IndigoParameter.fromRawJson(String str) =>
      IndigoParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoParameter.fromJson(Map<String, dynamic> json) =>
      IndigoParameter(
        parameterIn: json["in"],
        name: json["name"],
        schema: Schema4.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "schema": schema.toJson(),
      };
}

class Schema4 {
  Schema4({
    required this.type,
  });

  String type;

  factory Schema4.fromRawJson(String str) => Schema4.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema4.fromJson(Map<String, dynamic> json) => Schema4(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class CunningResponses {
  CunningResponses({
    required this.the200,
  });

  Frisky200 the200;

  factory CunningResponses.fromRawJson(String str) =>
      CunningResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CunningResponses.fromJson(Map<String, dynamic> json) =>
      CunningResponses(
        the200: Frisky200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Frisky200 {
  Frisky200({
    required this.description,
  });

  String description;

  factory Frisky200.fromRawJson(String str) =>
      Frisky200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Frisky200.fromJson(Map<String, dynamic> json) => Frisky200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class AuthForgotPassword {
  AuthForgotPassword({
    required this.post,
  });

  AuthForgotPasswordPost post;

  factory AuthForgotPassword.fromRawJson(String str) =>
      AuthForgotPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthForgotPassword.fromJson(Map<String, dynamic> json) =>
      AuthForgotPassword(
        post: AuthForgotPasswordPost.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
      };
}

class AuthForgotPasswordPost {
  AuthForgotPasswordPost({
    required this.requestBody,
    required this.responses,
    required this.tags,
  });

  TentacledRequestBody requestBody;
  MagentaResponses responses;
  List<String> tags;

  factory AuthForgotPasswordPost.fromRawJson(String str) =>
      AuthForgotPasswordPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthForgotPasswordPost.fromJson(Map<String, dynamic> json) =>
      AuthForgotPasswordPost(
        requestBody: TentacledRequestBody.fromJson(json["requestBody"]),
        responses: MagentaResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "requestBody": requestBody.toJson(),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class TentacledRequestBody {
  TentacledRequestBody({
    required this.content,
  });

  StickyContent content;

  factory TentacledRequestBody.fromRawJson(String str) =>
      TentacledRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledRequestBody.fromJson(Map<String, dynamic> json) =>
      TentacledRequestBody(
        content: StickyContent.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
      };
}

class StickyContent {
  StickyContent({
    required this.applicationJson,
    required this.contentApplicationJson,
    required this.textJson,
  });

  HilariousApplicationJson applicationJson;
  AmbitiousApplicationJson contentApplicationJson;
  StickyTextJson textJson;

  factory StickyContent.fromRawJson(String str) =>
      StickyContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyContent.fromJson(Map<String, dynamic> json) => StickyContent(
        applicationJson:
            HilariousApplicationJson.fromJson(json["application/*+json"]),
        contentApplicationJson:
            AmbitiousApplicationJson.fromJson(json["application/json"]),
        textJson: StickyTextJson.fromJson(json["text/json"]),
      );

  Map<String, dynamic> toJson() => {
        "application/*+json": applicationJson.toJson(),
        "application/json": contentApplicationJson.toJson(),
        "text/json": textJson.toJson(),
      };
}

class HilariousApplicationJson {
  HilariousApplicationJson({
    required this.schema,
  });

  Schema5 schema;

  factory HilariousApplicationJson.fromRawJson(String str) =>
      HilariousApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HilariousApplicationJson.fromJson(Map<String, dynamic> json) =>
      HilariousApplicationJson(
        schema: Schema5.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema5 {
  Schema5({
    required this.ref,
  });

  String ref;

  factory Schema5.fromRawJson(String str) => Schema5.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema5.fromJson(Map<String, dynamic> json) => Schema5(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class AmbitiousApplicationJson {
  AmbitiousApplicationJson({
    required this.schema,
  });

  Schema6 schema;

  factory AmbitiousApplicationJson.fromRawJson(String str) =>
      AmbitiousApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmbitiousApplicationJson.fromJson(Map<String, dynamic> json) =>
      AmbitiousApplicationJson(
        schema: Schema6.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema6 {
  Schema6({
    required this.ref,
  });

  String ref;

  factory Schema6.fromRawJson(String str) => Schema6.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema6.fromJson(Map<String, dynamic> json) => Schema6(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class StickyTextJson {
  StickyTextJson({
    required this.schema,
  });

  Schema7 schema;

  factory StickyTextJson.fromRawJson(String str) =>
      StickyTextJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyTextJson.fromJson(Map<String, dynamic> json) => StickyTextJson(
        schema: Schema7.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema7 {
  Schema7({
    required this.ref,
  });

  String ref;

  factory Schema7.fromRawJson(String str) => Schema7.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema7.fromJson(Map<String, dynamic> json) => Schema7(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class MagentaResponses {
  MagentaResponses({
    required this.the200,
  });

  Mischievous200 the200;

  factory MagentaResponses.fromRawJson(String str) =>
      MagentaResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MagentaResponses.fromJson(Map<String, dynamic> json) =>
      MagentaResponses(
        the200: Mischievous200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Mischievous200 {
  Mischievous200({
    required this.description,
  });

  String description;

  factory Mischievous200.fromRawJson(String str) =>
      Mischievous200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mischievous200.fromJson(Map<String, dynamic> json) => Mischievous200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class AuthLogin {
  AuthLogin({
    required this.post,
  });

  AuthLoginPost post;

  factory AuthLogin.fromRawJson(String str) =>
      AuthLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthLogin.fromJson(Map<String, dynamic> json) => AuthLogin(
        post: AuthLoginPost.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
      };
}

class AuthLoginPost {
  AuthLoginPost({
    required this.requestBody,
    required this.responses,
    required this.tags,
  });

  StickyRequestBody requestBody;
  FriskyResponses responses;
  List<String> tags;

  factory AuthLoginPost.fromRawJson(String str) =>
      AuthLoginPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthLoginPost.fromJson(Map<String, dynamic> json) => AuthLoginPost(
        requestBody: StickyRequestBody.fromJson(json["requestBody"]),
        responses: FriskyResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "requestBody": requestBody.toJson(),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class StickyRequestBody {
  StickyRequestBody({
    required this.content,
  });

  IndigoContent content;

  factory StickyRequestBody.fromRawJson(String str) =>
      StickyRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyRequestBody.fromJson(Map<String, dynamic> json) =>
      StickyRequestBody(
        content: IndigoContent.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
      };
}

class IndigoContent {
  IndigoContent({
    required this.applicationJson,
    required this.contentApplicationJson,
    required this.textJson,
  });

  CunningApplicationJson applicationJson;
  MagentaApplicationJson contentApplicationJson;
  IndigoTextJson textJson;

  factory IndigoContent.fromRawJson(String str) =>
      IndigoContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoContent.fromJson(Map<String, dynamic> json) => IndigoContent(
        applicationJson:
            CunningApplicationJson.fromJson(json["application/*+json"]),
        contentApplicationJson:
            MagentaApplicationJson.fromJson(json["application/json"]),
        textJson: IndigoTextJson.fromJson(json["text/json"]),
      );

  Map<String, dynamic> toJson() => {
        "application/*+json": applicationJson.toJson(),
        "application/json": contentApplicationJson.toJson(),
        "text/json": textJson.toJson(),
      };
}

class CunningApplicationJson {
  CunningApplicationJson({
    required this.schema,
  });

  Schema8 schema;

  factory CunningApplicationJson.fromRawJson(String str) =>
      CunningApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CunningApplicationJson.fromJson(Map<String, dynamic> json) =>
      CunningApplicationJson(
        schema: Schema8.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema8 {
  Schema8({
    required this.ref,
  });

  String ref;

  factory Schema8.fromRawJson(String str) => Schema8.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema8.fromJson(Map<String, dynamic> json) => Schema8(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class MagentaApplicationJson {
  MagentaApplicationJson({
    required this.schema,
  });

  Schema9 schema;

  factory MagentaApplicationJson.fromRawJson(String str) =>
      MagentaApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MagentaApplicationJson.fromJson(Map<String, dynamic> json) =>
      MagentaApplicationJson(
        schema: Schema9.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema9 {
  Schema9({
    required this.ref,
  });

  String ref;

  factory Schema9.fromRawJson(String str) => Schema9.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema9.fromJson(Map<String, dynamic> json) => Schema9(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class IndigoTextJson {
  IndigoTextJson({
    required this.schema,
  });

  Schema10 schema;

  factory IndigoTextJson.fromRawJson(String str) =>
      IndigoTextJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoTextJson.fromJson(Map<String, dynamic> json) => IndigoTextJson(
        schema: Schema10.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema10 {
  Schema10({
    required this.ref,
  });

  String ref;

  factory Schema10.fromRawJson(String str) =>
      Schema10.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema10.fromJson(Map<String, dynamic> json) => Schema10(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class FriskyResponses {
  FriskyResponses({
    required this.the200,
  });

  Braggadocious200 the200;

  factory FriskyResponses.fromRawJson(String str) =>
      FriskyResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FriskyResponses.fromJson(Map<String, dynamic> json) =>
      FriskyResponses(
        the200: Braggadocious200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Braggadocious200 {
  Braggadocious200({
    required this.description,
  });

  String description;

  factory Braggadocious200.fromRawJson(String str) =>
      Braggadocious200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Braggadocious200.fromJson(Map<String, dynamic> json) =>
      Braggadocious200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class AuthResetPassword {
  AuthResetPassword({
    required this.post,
  });

  AuthResetPasswordPost post;

  factory AuthResetPassword.fromRawJson(String str) =>
      AuthResetPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResetPassword.fromJson(Map<String, dynamic> json) =>
      AuthResetPassword(
        post: AuthResetPasswordPost.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
      };
}

class AuthResetPasswordPost {
  AuthResetPasswordPost({
    required this.requestBody,
    required this.responses,
    required this.tags,
  });

  IndigoRequestBody requestBody;
  MischievousResponses responses;
  List<String> tags;

  factory AuthResetPasswordPost.fromRawJson(String str) =>
      AuthResetPasswordPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResetPasswordPost.fromJson(Map<String, dynamic> json) =>
      AuthResetPasswordPost(
        requestBody: IndigoRequestBody.fromJson(json["requestBody"]),
        responses: MischievousResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "requestBody": requestBody.toJson(),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class IndigoRequestBody {
  IndigoRequestBody({
    required this.content,
  });

  IndecentContent content;

  factory IndigoRequestBody.fromRawJson(String str) =>
      IndigoRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoRequestBody.fromJson(Map<String, dynamic> json) =>
      IndigoRequestBody(
        content: IndecentContent.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
      };
}

class IndecentContent {
  IndecentContent({
    required this.applicationJson,
    required this.contentApplicationJson,
    required this.textJson,
  });

  FriskyApplicationJson applicationJson;
  MischievousApplicationJson contentApplicationJson;
  IndecentTextJson textJson;

  factory IndecentContent.fromRawJson(String str) =>
      IndecentContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndecentContent.fromJson(Map<String, dynamic> json) =>
      IndecentContent(
        applicationJson:
            FriskyApplicationJson.fromJson(json["application/*+json"]),
        contentApplicationJson:
            MischievousApplicationJson.fromJson(json["application/json"]),
        textJson: IndecentTextJson.fromJson(json["text/json"]),
      );

  Map<String, dynamic> toJson() => {
        "application/*+json": applicationJson.toJson(),
        "application/json": contentApplicationJson.toJson(),
        "text/json": textJson.toJson(),
      };
}

class FriskyApplicationJson {
  FriskyApplicationJson({
    required this.schema,
  });

  Schema11 schema;

  factory FriskyApplicationJson.fromRawJson(String str) =>
      FriskyApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FriskyApplicationJson.fromJson(Map<String, dynamic> json) =>
      FriskyApplicationJson(
        schema: Schema11.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema11 {
  Schema11({
    required this.ref,
  });

  String ref;

  factory Schema11.fromRawJson(String str) =>
      Schema11.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema11.fromJson(Map<String, dynamic> json) => Schema11(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class MischievousApplicationJson {
  MischievousApplicationJson({
    required this.schema,
  });

  Schema12 schema;

  factory MischievousApplicationJson.fromRawJson(String str) =>
      MischievousApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MischievousApplicationJson.fromJson(Map<String, dynamic> json) =>
      MischievousApplicationJson(
        schema: Schema12.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema12 {
  Schema12({
    required this.ref,
  });

  String ref;

  factory Schema12.fromRawJson(String str) =>
      Schema12.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema12.fromJson(Map<String, dynamic> json) => Schema12(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class IndecentTextJson {
  IndecentTextJson({
    required this.schema,
  });

  Schema13 schema;

  factory IndecentTextJson.fromRawJson(String str) =>
      IndecentTextJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndecentTextJson.fromJson(Map<String, dynamic> json) =>
      IndecentTextJson(
        schema: Schema13.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema13 {
  Schema13({
    required this.ref,
  });

  String ref;

  factory Schema13.fromRawJson(String str) =>
      Schema13.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema13.fromJson(Map<String, dynamic> json) => Schema13(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class MischievousResponses {
  MischievousResponses({
    required this.the200,
  });

  The2001 the200;

  factory MischievousResponses.fromRawJson(String str) =>
      MischievousResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MischievousResponses.fromJson(Map<String, dynamic> json) =>
      MischievousResponses(
        the200: The2001.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class The2001 {
  The2001({
    required this.description,
  });

  String description;

  factory The2001.fromRawJson(String str) => The2001.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory The2001.fromJson(Map<String, dynamic> json) => The2001(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class Companies {
  Companies({
    required this.companiesGet,
  });

  CompaniesGet companiesGet;

  factory Companies.fromRawJson(String str) =>
      Companies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Companies.fromJson(Map<String, dynamic> json) => Companies(
        companiesGet: CompaniesGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "get": companiesGet.toJson(),
      };
}

class CompaniesGet {
  CompaniesGet({
    required this.responses,
    required this.tags,
  });

  PurpleResponses responses;
  List<String> tags;

  factory CompaniesGet.fromRawJson(String str) =>
      CompaniesGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesGet.fromJson(Map<String, dynamic> json) => CompaniesGet(
        responses: PurpleResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class PurpleResponses {
  PurpleResponses({
    required this.the200,
  });

  Purple200 the200;

  factory PurpleResponses.fromRawJson(String str) =>
      PurpleResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleResponses.fromJson(Map<String, dynamic> json) =>
      PurpleResponses(
        the200: Purple200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Purple200 {
  Purple200({
    required this.description,
  });

  String description;

  factory Purple200.fromRawJson(String str) =>
      Purple200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Purple200.fromJson(Map<String, dynamic> json) => Purple200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class CompaniesCompanyId {
  CompaniesCompanyId({
    required this.companiesCompanyIdGet,
  });

  CompaniesCompanyIdGet companiesCompanyIdGet;

  factory CompaniesCompanyId.fromRawJson(String str) =>
      CompaniesCompanyId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyId.fromJson(Map<String, dynamic> json) =>
      CompaniesCompanyId(
        companiesCompanyIdGet: CompaniesCompanyIdGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "get": companiesCompanyIdGet.toJson(),
      };
}

class CompaniesCompanyIdGet {
  CompaniesCompanyIdGet({
    required this.parameters,
    required this.responses,
    required this.tags,
  });

  List<PurpleParameter> parameters;
  TentacledResponses responses;
  List<String> tags;

  factory CompaniesCompanyIdGet.fromRawJson(String str) =>
      CompaniesCompanyIdGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdGet.fromJson(Map<String, dynamic> json) =>
      CompaniesCompanyIdGet(
        parameters: List<PurpleParameter>.from(
            json["parameters"].map((x) => PurpleParameter.fromJson(x))),
        responses: TentacledResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class PurpleParameter {
  PurpleParameter({
    required this.parameterIn,
    required this.name,
    required this.required,
    required this.schema,
  });

  String parameterIn;
  String name;
  bool required;
  StickySchema schema;

  factory PurpleParameter.fromRawJson(String str) =>
      PurpleParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleParameter.fromJson(Map<String, dynamic> json) =>
      PurpleParameter(
        parameterIn: json["in"],
        name: json["name"],
        required: json["required"],
        schema: StickySchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "required": required,
        "schema": schema.toJson(),
      };
}

class StickySchema {
  StickySchema({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory StickySchema.fromRawJson(String str) =>
      StickySchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickySchema.fromJson(Map<String, dynamic> json) => StickySchema(
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "type": type,
      };
}

class TentacledResponses {
  TentacledResponses({
    required this.the200,
  });

  Tentacled200 the200;

  factory TentacledResponses.fromRawJson(String str) =>
      TentacledResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledResponses.fromJson(Map<String, dynamic> json) =>
      TentacledResponses(
        the200: Tentacled200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Tentacled200 {
  Tentacled200({
    required this.description,
  });

  String description;

  factory Tentacled200.fromRawJson(String str) =>
      Tentacled200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tentacled200.fromJson(Map<String, dynamic> json) => Tentacled200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class CompaniesCompanyIdRegisterUser {
  CompaniesCompanyIdRegisterUser({
    required this.post,
  });

  CompaniesCompanyIdRegisterUserPost post;

  factory CompaniesCompanyIdRegisterUser.fromRawJson(String str) =>
      CompaniesCompanyIdRegisterUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdRegisterUser.fromJson(Map<String, dynamic> json) =>
      CompaniesCompanyIdRegisterUser(
        post: CompaniesCompanyIdRegisterUserPost.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
      };
}

class CompaniesCompanyIdRegisterUserPost {
  CompaniesCompanyIdRegisterUserPost({
    required this.parameters,
    required this.requestBody,
    required this.responses,
    required this.tags,
  });

  List<PostParameter> parameters;
  FluffyRequestBody requestBody;
  StickyResponses responses;
  List<String> tags;

  factory CompaniesCompanyIdRegisterUserPost.fromRawJson(String str) =>
      CompaniesCompanyIdRegisterUserPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdRegisterUserPost.fromJson(
          Map<String, dynamic> json) =>
      CompaniesCompanyIdRegisterUserPost(
        parameters: List<PostParameter>.from(
            json["parameters"].map((x) => PostParameter.fromJson(x))),
        requestBody: FluffyRequestBody.fromJson(json["requestBody"]),
        responses: StickyResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "requestBody": requestBody.toJson(),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class PostParameter {
  PostParameter({
    required this.parameterIn,
    required this.name,
    required this.required,
    required this.schema,
  });

  String parameterIn;
  String name;
  bool required;
  IndigoSchema schema;

  factory PostParameter.fromRawJson(String str) =>
      PostParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostParameter.fromJson(Map<String, dynamic> json) => PostParameter(
        parameterIn: json["in"],
        name: json["name"],
        required: json["required"],
        schema: IndigoSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "required": required,
        "schema": schema.toJson(),
      };
}

class IndigoSchema {
  IndigoSchema({
    required this.type,
  });

  String type;

  factory IndigoSchema.fromRawJson(String str) =>
      IndigoSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoSchema.fromJson(Map<String, dynamic> json) => IndigoSchema(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class FluffyRequestBody {
  FluffyRequestBody({
    required this.content,
  });

  FluffyContent content;

  factory FluffyRequestBody.fromRawJson(String str) =>
      FluffyRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyRequestBody.fromJson(Map<String, dynamic> json) =>
      FluffyRequestBody(
        content: FluffyContent.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
      };
}

class FluffyContent {
  FluffyContent({
    required this.applicationJson,
    required this.contentApplicationJson,
    required this.textJson,
  });

  TentacledApplicationJson applicationJson;
  StickyApplicationJson contentApplicationJson;
  FluffyTextJson textJson;

  factory FluffyContent.fromRawJson(String str) =>
      FluffyContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyContent.fromJson(Map<String, dynamic> json) => FluffyContent(
        applicationJson:
            TentacledApplicationJson.fromJson(json["application/*+json"]),
        contentApplicationJson:
            StickyApplicationJson.fromJson(json["application/json"]),
        textJson: FluffyTextJson.fromJson(json["text/json"]),
      );

  Map<String, dynamic> toJson() => {
        "application/*+json": applicationJson.toJson(),
        "application/json": contentApplicationJson.toJson(),
        "text/json": textJson.toJson(),
      };
}

class TentacledApplicationJson {
  TentacledApplicationJson({
    required this.schema,
  });

  IndecentSchema schema;

  factory TentacledApplicationJson.fromRawJson(String str) =>
      TentacledApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledApplicationJson.fromJson(Map<String, dynamic> json) =>
      TentacledApplicationJson(
        schema: IndecentSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class IndecentSchema {
  IndecentSchema({
    required this.ref,
  });

  String ref;

  factory IndecentSchema.fromRawJson(String str) =>
      IndecentSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndecentSchema.fromJson(Map<String, dynamic> json) => IndecentSchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class StickyApplicationJson {
  StickyApplicationJson({
    required this.schema,
  });

  HilariousSchema schema;

  factory StickyApplicationJson.fromRawJson(String str) =>
      StickyApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyApplicationJson.fromJson(Map<String, dynamic> json) =>
      StickyApplicationJson(
        schema: HilariousSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class HilariousSchema {
  HilariousSchema({
    required this.ref,
  });

  String ref;

  factory HilariousSchema.fromRawJson(String str) =>
      HilariousSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HilariousSchema.fromJson(Map<String, dynamic> json) =>
      HilariousSchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class FluffyTextJson {
  FluffyTextJson({
    required this.schema,
  });

  AmbitiousSchema schema;

  factory FluffyTextJson.fromRawJson(String str) =>
      FluffyTextJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyTextJson.fromJson(Map<String, dynamic> json) => FluffyTextJson(
        schema: AmbitiousSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class AmbitiousSchema {
  AmbitiousSchema({
    required this.ref,
  });

  String ref;

  factory AmbitiousSchema.fromRawJson(String str) =>
      AmbitiousSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmbitiousSchema.fromJson(Map<String, dynamic> json) =>
      AmbitiousSchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class StickyResponses {
  StickyResponses({
    required this.the200,
  });

  Sticky200 the200;

  factory StickyResponses.fromRawJson(String str) =>
      StickyResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyResponses.fromJson(Map<String, dynamic> json) =>
      StickyResponses(
        the200: Sticky200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Sticky200 {
  Sticky200({
    required this.description,
  });

  String description;

  factory Sticky200.fromRawJson(String str) =>
      Sticky200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sticky200.fromJson(Map<String, dynamic> json) => Sticky200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class CompaniesCompanyIdUsers {
  CompaniesCompanyIdUsers({
    required this.companiesCompanyIdUsersGet,
  });

  CompaniesCompanyIdUsersGet companiesCompanyIdUsersGet;

  factory CompaniesCompanyIdUsers.fromRawJson(String str) =>
      CompaniesCompanyIdUsers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdUsers.fromJson(Map<String, dynamic> json) =>
      CompaniesCompanyIdUsers(
        companiesCompanyIdUsersGet:
            CompaniesCompanyIdUsersGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "get": companiesCompanyIdUsersGet.toJson(),
      };
}

class CompaniesCompanyIdUsersGet {
  CompaniesCompanyIdUsersGet({
    required this.parameters,
    required this.responses,
    required this.tags,
  });

  List<FluffyParameter> parameters;
  IndigoResponses responses;
  List<String> tags;

  factory CompaniesCompanyIdUsersGet.fromRawJson(String str) =>
      CompaniesCompanyIdUsersGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdUsersGet.fromJson(Map<String, dynamic> json) =>
      CompaniesCompanyIdUsersGet(
        parameters: List<FluffyParameter>.from(
            json["parameters"].map((x) => FluffyParameter.fromJson(x))),
        responses: IndigoResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class FluffyParameter {
  FluffyParameter({
    required this.parameterIn,
    required this.name,
    required this.required,
    required this.schema,
  });

  String parameterIn;
  String name;
  bool required;
  CunningSchema schema;

  factory FluffyParameter.fromRawJson(String str) =>
      FluffyParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyParameter.fromJson(Map<String, dynamic> json) =>
      FluffyParameter(
        parameterIn: json["in"],
        name: json["name"],
        required: json["required"],
        schema: CunningSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "required": required,
        "schema": schema.toJson(),
      };
}

class CunningSchema {
  CunningSchema({
    required this.type,
  });

  String type;

  factory CunningSchema.fromRawJson(String str) =>
      CunningSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CunningSchema.fromJson(Map<String, dynamic> json) => CunningSchema(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class IndigoResponses {
  IndigoResponses({
    required this.the200,
  });

  Indigo200 the200;

  factory IndigoResponses.fromRawJson(String str) =>
      IndigoResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoResponses.fromJson(Map<String, dynamic> json) =>
      IndigoResponses(
        the200: Indigo200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Indigo200 {
  Indigo200({
    required this.description,
  });

  String description;

  factory Indigo200.fromRawJson(String str) =>
      Indigo200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Indigo200.fromJson(Map<String, dynamic> json) => Indigo200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class CompaniesCompanyIdUsersUserId {
  CompaniesCompanyIdUsersUserId({
    required this.delete,
    required this.companiesCompanyIdUsersUserIdGet,
  });

  Delete delete;
  CompaniesCompanyIdUsersUserIdGet companiesCompanyIdUsersUserIdGet;

  factory CompaniesCompanyIdUsersUserId.fromRawJson(String str) =>
      CompaniesCompanyIdUsersUserId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdUsersUserId.fromJson(Map<String, dynamic> json) =>
      CompaniesCompanyIdUsersUserId(
        delete: Delete.fromJson(json["delete"]),
        companiesCompanyIdUsersUserIdGet:
            CompaniesCompanyIdUsersUserIdGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "delete": delete.toJson(),
        "get": companiesCompanyIdUsersUserIdGet.toJson(),
      };
}

class CompaniesCompanyIdUsersUserIdGet {
  CompaniesCompanyIdUsersUserIdGet({
    required this.parameters,
    required this.responses,
    required this.tags,
  });

  List<TentacledParameter> parameters;
  IndecentResponses responses;
  List<String> tags;

  factory CompaniesCompanyIdUsersUserIdGet.fromRawJson(String str) =>
      CompaniesCompanyIdUsersUserIdGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdUsersUserIdGet.fromJson(
          Map<String, dynamic> json) =>
      CompaniesCompanyIdUsersUserIdGet(
        parameters: List<TentacledParameter>.from(
            json["parameters"].map((x) => TentacledParameter.fromJson(x))),
        responses: IndecentResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class TentacledParameter {
  TentacledParameter({
    required this.parameterIn,
    required this.name,
    required this.required,
    required this.schema,
  });

  String parameterIn;
  String name;
  bool required;
  FriskySchema schema;

  factory TentacledParameter.fromRawJson(String str) =>
      TentacledParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledParameter.fromJson(Map<String, dynamic> json) =>
      TentacledParameter(
        parameterIn: json["in"],
        name: json["name"],
        required: json["required"],
        schema: FriskySchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "required": required,
        "schema": schema.toJson(),
      };
}

class FriskySchema {
  FriskySchema({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory FriskySchema.fromRawJson(String str) =>
      FriskySchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FriskySchema.fromJson(Map<String, dynamic> json) => FriskySchema(
        format: json["format"] == null ? null : json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format == null ? null : format,
        "type": type,
      };
}

class IndecentResponses {
  IndecentResponses({
    required this.the200,
  });

  Hilarious200 the200;

  factory IndecentResponses.fromRawJson(String str) =>
      IndecentResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndecentResponses.fromJson(Map<String, dynamic> json) =>
      IndecentResponses(
        the200: Hilarious200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Hilarious200 {
  Hilarious200({
    required this.description,
  });

  String description;

  factory Hilarious200.fromRawJson(String str) =>
      Hilarious200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hilarious200.fromJson(Map<String, dynamic> json) => Hilarious200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class Delete {
  Delete({
    required this.parameters,
    required this.responses,
    required this.tags,
  });

  List<DeleteParameter> parameters;
  DeleteResponses responses;
  List<String> tags;

  factory Delete.fromRawJson(String str) => Delete.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Delete.fromJson(Map<String, dynamic> json) => Delete(
        parameters: List<DeleteParameter>.from(
            json["parameters"].map((x) => DeleteParameter.fromJson(x))),
        responses: DeleteResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class DeleteParameter {
  DeleteParameter({
    required this.parameterIn,
    required this.name,
    required this.required,
    required this.schema,
  });

  String parameterIn;
  String name;
  bool required;
  MagentaSchema schema;

  factory DeleteParameter.fromRawJson(String str) =>
      DeleteParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteParameter.fromJson(Map<String, dynamic> json) =>
      DeleteParameter(
        parameterIn: json["in"],
        name: json["name"],
        required: json["required"],
        schema: MagentaSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "required": required,
        "schema": schema.toJson(),
      };
}

class MagentaSchema {
  MagentaSchema({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory MagentaSchema.fromRawJson(String str) =>
      MagentaSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MagentaSchema.fromJson(Map<String, dynamic> json) => MagentaSchema(
        format: json["format"] == null ? null : json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format == null ? null : format,
        "type": type,
      };
}

class DeleteResponses {
  DeleteResponses({
    required this.the200,
  });

  Indecent200 the200;

  factory DeleteResponses.fromRawJson(String str) =>
      DeleteResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteResponses.fromJson(Map<String, dynamic> json) =>
      DeleteResponses(
        the200: Indecent200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Indecent200 {
  Indecent200({
    required this.description,
  });

  String description;

  factory Indecent200.fromRawJson(String str) =>
      Indecent200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Indecent200.fromJson(Map<String, dynamic> json) => Indecent200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class CompaniesCompanyIdUsersUserIdUpdate {
  CompaniesCompanyIdUsersUserIdUpdate({
    required this.put,
  });

  Put put;

  factory CompaniesCompanyIdUsersUserIdUpdate.fromRawJson(String str) =>
      CompaniesCompanyIdUsersUserIdUpdate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesCompanyIdUsersUserIdUpdate.fromJson(
          Map<String, dynamic> json) =>
      CompaniesCompanyIdUsersUserIdUpdate(
        put: Put.fromJson(json["put"]),
      );

  Map<String, dynamic> toJson() => {
        "put": put.toJson(),
      };
}

class Put {
  Put({
    required this.parameters,
    required this.requestBody,
    required this.responses,
    required this.tags,
  });

  List<PutParameter> parameters;
  PutRequestBody requestBody;
  PutResponses responses;
  List<String> tags;

  factory Put.fromRawJson(String str) => Put.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Put.fromJson(Map<String, dynamic> json) => Put(
        parameters: List<PutParameter>.from(
            json["parameters"].map((x) => PutParameter.fromJson(x))),
        requestBody: PutRequestBody.fromJson(json["requestBody"]),
        responses: PutResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "requestBody": requestBody.toJson(),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class PutParameter {
  PutParameter({
    required this.parameterIn,
    required this.name,
    required this.required,
    required this.schema,
  });

  String parameterIn;
  String name;
  bool required;
  MischievousSchema schema;

  factory PutParameter.fromRawJson(String str) =>
      PutParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PutParameter.fromJson(Map<String, dynamic> json) => PutParameter(
        parameterIn: json["in"],
        name: json["name"],
        required: json["required"],
        schema: MischievousSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "required": required,
        "schema": schema.toJson(),
      };
}

class MischievousSchema {
  MischievousSchema({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory MischievousSchema.fromRawJson(String str) =>
      MischievousSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MischievousSchema.fromJson(Map<String, dynamic> json) =>
      MischievousSchema(
        format: json["format"] == null ? null : json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format == null ? null : format,
        "type": type,
      };
}

class PutRequestBody {
  PutRequestBody({
    required this.content,
  });

  TentacledContent content;

  factory PutRequestBody.fromRawJson(String str) =>
      PutRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PutRequestBody.fromJson(Map<String, dynamic> json) => PutRequestBody(
        content: TentacledContent.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
      };
}

class TentacledContent {
  TentacledContent({
    required this.applicationJson,
    required this.contentApplicationJson,
    required this.textJson,
  });

  IndigoApplicationJson applicationJson;
  IndecentApplicationJson contentApplicationJson;
  TentacledTextJson textJson;

  factory TentacledContent.fromRawJson(String str) =>
      TentacledContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledContent.fromJson(Map<String, dynamic> json) =>
      TentacledContent(
        applicationJson:
            IndigoApplicationJson.fromJson(json["application/*+json"]),
        contentApplicationJson:
            IndecentApplicationJson.fromJson(json["application/json"]),
        textJson: TentacledTextJson.fromJson(json["text/json"]),
      );

  Map<String, dynamic> toJson() => {
        "application/*+json": applicationJson.toJson(),
        "application/json": contentApplicationJson.toJson(),
        "text/json": textJson.toJson(),
      };
}

class IndigoApplicationJson {
  IndigoApplicationJson({
    required this.schema,
  });

  BraggadociousSchema schema;

  factory IndigoApplicationJson.fromRawJson(String str) =>
      IndigoApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndigoApplicationJson.fromJson(Map<String, dynamic> json) =>
      IndigoApplicationJson(
        schema: BraggadociousSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class BraggadociousSchema {
  BraggadociousSchema({
    required this.ref,
  });

  String ref;

  factory BraggadociousSchema.fromRawJson(String str) =>
      BraggadociousSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BraggadociousSchema.fromJson(Map<String, dynamic> json) =>
      BraggadociousSchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class IndecentApplicationJson {
  IndecentApplicationJson({
    required this.schema,
  });

  Schema1 schema;

  factory IndecentApplicationJson.fromRawJson(String str) =>
      IndecentApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndecentApplicationJson.fromJson(Map<String, dynamic> json) =>
      IndecentApplicationJson(
        schema: Schema1.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema1 {
  Schema1({
    required this.ref,
  });

  String ref;

  factory Schema1.fromRawJson(String str) => Schema1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema1.fromJson(Map<String, dynamic> json) => Schema1(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class TentacledTextJson {
  TentacledTextJson({
    required this.schema,
  });

  Schema2 schema;

  factory TentacledTextJson.fromRawJson(String str) =>
      TentacledTextJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledTextJson.fromJson(Map<String, dynamic> json) =>
      TentacledTextJson(
        schema: Schema2.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class Schema2 {
  Schema2({
    required this.ref,
  });

  String ref;

  factory Schema2.fromRawJson(String str) => Schema2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema2.fromJson(Map<String, dynamic> json) => Schema2(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class PutResponses {
  PutResponses({
    required this.the200,
  });

  Ambitious200 the200;

  factory PutResponses.fromRawJson(String str) =>
      PutResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PutResponses.fromJson(Map<String, dynamic> json) => PutResponses(
        the200: Ambitious200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Ambitious200 {
  Ambitious200({
    required this.description,
  });

  String description;

  factory Ambitious200.fromRawJson(String str) =>
      Ambitious200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ambitious200.fromJson(Map<String, dynamic> json) => Ambitious200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class CompaniesRegister {
  CompaniesRegister({
    required this.post,
  });

  CompaniesRegisterPost post;

  factory CompaniesRegister.fromRawJson(String str) =>
      CompaniesRegister.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesRegister.fromJson(Map<String, dynamic> json) =>
      CompaniesRegister(
        post: CompaniesRegisterPost.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
      };
}

class CompaniesRegisterPost {
  CompaniesRegisterPost({
    required this.requestBody,
    required this.responses,
    required this.tags,
  });

  PurpleRequestBody requestBody;
  FluffyResponses responses;
  List<String> tags;

  factory CompaniesRegisterPost.fromRawJson(String str) =>
      CompaniesRegisterPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesRegisterPost.fromJson(Map<String, dynamic> json) =>
      CompaniesRegisterPost(
        requestBody: PurpleRequestBody.fromJson(json["requestBody"]),
        responses: FluffyResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "requestBody": requestBody.toJson(),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class PurpleRequestBody {
  PurpleRequestBody({
    required this.content,
    required this.required,
  });

  PurpleContent content;
  bool required;

  factory PurpleRequestBody.fromRawJson(String str) =>
      PurpleRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleRequestBody.fromJson(Map<String, dynamic> json) =>
      PurpleRequestBody(
        content: PurpleContent.fromJson(json["content"]),
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "required": required,
      };
}

class PurpleContent {
  PurpleContent({
    required this.applicationJson,
    required this.contentApplicationJson,
    required this.textJson,
  });

  PurpleApplicationJson applicationJson;
  FluffyApplicationJson contentApplicationJson;
  PurpleTextJson textJson;

  factory PurpleContent.fromRawJson(String str) =>
      PurpleContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleContent.fromJson(Map<String, dynamic> json) => PurpleContent(
        applicationJson:
            PurpleApplicationJson.fromJson(json["application/*+json"]),
        contentApplicationJson:
            FluffyApplicationJson.fromJson(json["application/json"]),
        textJson: PurpleTextJson.fromJson(json["text/json"]),
      );

  Map<String, dynamic> toJson() => {
        "application/*+json": applicationJson.toJson(),
        "application/json": contentApplicationJson.toJson(),
        "text/json": textJson.toJson(),
      };
}

class PurpleApplicationJson {
  PurpleApplicationJson({
    required this.schema,
  });

  PurpleSchema schema;

  factory PurpleApplicationJson.fromRawJson(String str) =>
      PurpleApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleApplicationJson.fromJson(Map<String, dynamic> json) =>
      PurpleApplicationJson(
        schema: PurpleSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class PurpleSchema {
  PurpleSchema({
    required this.ref,
  });

  String ref;

  factory PurpleSchema.fromRawJson(String str) =>
      PurpleSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleSchema.fromJson(Map<String, dynamic> json) => PurpleSchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class FluffyApplicationJson {
  FluffyApplicationJson({
    required this.schema,
  });

  FluffySchema schema;

  factory FluffyApplicationJson.fromRawJson(String str) =>
      FluffyApplicationJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyApplicationJson.fromJson(Map<String, dynamic> json) =>
      FluffyApplicationJson(
        schema: FluffySchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class FluffySchema {
  FluffySchema({
    required this.ref,
  });

  String ref;

  factory FluffySchema.fromRawJson(String str) =>
      FluffySchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffySchema.fromJson(Map<String, dynamic> json) => FluffySchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class PurpleTextJson {
  PurpleTextJson({
    required this.schema,
  });

  TentacledSchema schema;

  factory PurpleTextJson.fromRawJson(String str) =>
      PurpleTextJson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleTextJson.fromJson(Map<String, dynamic> json) => PurpleTextJson(
        schema: TentacledSchema.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "schema": schema.toJson(),
      };
}

class TentacledSchema {
  TentacledSchema({
    required this.ref,
  });

  String ref;

  factory TentacledSchema.fromRawJson(String str) =>
      TentacledSchema.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TentacledSchema.fromJson(Map<String, dynamic> json) =>
      TentacledSchema(
        ref: json["\u0024ref"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
      };
}

class FluffyResponses {
  FluffyResponses({
    required this.the200,
  });

  Fluffy200 the200;

  factory FluffyResponses.fromRawJson(String str) =>
      FluffyResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyResponses.fromJson(Map<String, dynamic> json) =>
      FluffyResponses(
        the200: Fluffy200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Fluffy200 {
  Fluffy200({
    required this.description,
  });

  String description;

  factory Fluffy200.fromRawJson(String str) =>
      Fluffy200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fluffy200.fromJson(Map<String, dynamic> json) => Fluffy200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class Subscriptions {
  Subscriptions({
    required this.subscriptionsGet,
  });

  SubscriptionsGet subscriptionsGet;

  factory Subscriptions.fromRawJson(String str) =>
      Subscriptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscriptions.fromJson(Map<String, dynamic> json) => Subscriptions(
        subscriptionsGet: SubscriptionsGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "get": subscriptionsGet.toJson(),
      };
}

class SubscriptionsGet {
  SubscriptionsGet({
    required this.responses,
    required this.tags,
  });

  HilariousResponses responses;
  List<String> tags;

  factory SubscriptionsGet.fromRawJson(String str) =>
      SubscriptionsGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionsGet.fromJson(Map<String, dynamic> json) =>
      SubscriptionsGet(
        responses: HilariousResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class HilariousResponses {
  HilariousResponses({
    required this.the200,
  });

  Cunning200 the200;

  factory HilariousResponses.fromRawJson(String str) =>
      HilariousResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HilariousResponses.fromJson(Map<String, dynamic> json) =>
      HilariousResponses(
        the200: Cunning200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Cunning200 {
  Cunning200({
    required this.description,
  });

  String description;

  factory Cunning200.fromRawJson(String str) =>
      Cunning200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cunning200.fromJson(Map<String, dynamic> json) => Cunning200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class UsersLoadUserWithCompany {
  UsersLoadUserWithCompany({
    required this.usersLoadUserWithCompanyGet,
  });

  UsersLoadUserWithCompanyGet usersLoadUserWithCompanyGet;

  factory UsersLoadUserWithCompany.fromRawJson(String str) =>
      UsersLoadUserWithCompany.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsersLoadUserWithCompany.fromJson(Map<String, dynamic> json) =>
      UsersLoadUserWithCompany(
        usersLoadUserWithCompanyGet:
            UsersLoadUserWithCompanyGet.fromJson(json["get"]),
      );

  Map<String, dynamic> toJson() => {
        "get": usersLoadUserWithCompanyGet.toJson(),
      };
}

class UsersLoadUserWithCompanyGet {
  UsersLoadUserWithCompanyGet({
    required this.parameters,
    required this.responses,
    required this.tags,
  });

  List<StickyParameter> parameters;
  AmbitiousResponses responses;
  List<String> tags;

  factory UsersLoadUserWithCompanyGet.fromRawJson(String str) =>
      UsersLoadUserWithCompanyGet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsersLoadUserWithCompanyGet.fromJson(Map<String, dynamic> json) =>
      UsersLoadUserWithCompanyGet(
        parameters: List<StickyParameter>.from(
            json["parameters"].map((x) => StickyParameter.fromJson(x))),
        responses: AmbitiousResponses.fromJson(json["responses"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
        "responses": responses.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class StickyParameter {
  StickyParameter({
    required this.parameterIn,
    required this.name,
    required this.schema,
  });

  String parameterIn;
  String name;
  Schema3 schema;

  factory StickyParameter.fromRawJson(String str) =>
      StickyParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StickyParameter.fromJson(Map<String, dynamic> json) =>
      StickyParameter(
        parameterIn: json["in"],
        name: json["name"],
        schema: Schema3.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
        "in": parameterIn,
        "name": name,
        "schema": schema.toJson(),
      };
}

class Schema3 {
  Schema3({
    required this.format,
    required this.type,
  });

  String format;
  String type;

  factory Schema3.fromRawJson(String str) => Schema3.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schema3.fromJson(Map<String, dynamic> json) => Schema3(
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "format": format,
        "type": type,
      };
}

class AmbitiousResponses {
  AmbitiousResponses({
    required this.the200,
  });

  Magenta200 the200;

  factory AmbitiousResponses.fromRawJson(String str) =>
      AmbitiousResponses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmbitiousResponses.fromJson(Map<String, dynamic> json) =>
      AmbitiousResponses(
        the200: Magenta200.fromJson(json["200"]),
      );

  Map<String, dynamic> toJson() => {
        "200": the200.toJson(),
      };
}

class Magenta200 {
  Magenta200({
    required this.description,
  });

  String description;

  factory Magenta200.fromRawJson(String str) =>
      Magenta200.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Magenta200.fromJson(Map<String, dynamic> json) => Magenta200(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}
