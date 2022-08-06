// To parse this JSON data, do
//
//     final customerRegistrationRequestDto = customerRegistrationRequestDtoFromJson(jsonString);

import 'dart:convert';

class CustomerRegistrationRequestDto {
  CustomerRegistrationRequestDto({
    required this.company,
    required this.users,
  });

  Company company;
  List<User> users;

  factory CustomerRegistrationRequestDto.fromRawJson(String str) =>
      CustomerRegistrationRequestDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerRegistrationRequestDto.fromJson(Map<String, dynamic> json) =>
      CustomerRegistrationRequestDto(
        company: Company.fromJson(json["company"]),
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "company": company.toJson(),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class Company {
  Company({
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
  int companySize;
  String name;
  ProviderData providerData;
  String registrationNr;
  int type;
  String uidNr;
  String websiteUrl;

  factory Company.fromRawJson(String str) => Company.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        address: Address.fromJson(json["address"]),
        companySize: json["companySize"],
        name: json["name"],
        providerData: ProviderData.fromJson(json["providerData"]),
        registrationNr: json["registrationNr"],
        type: json["type"],
        uidNr: json["uidNr"],
        websiteUrl: json["websiteUrl"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "companySize": companySize,
        "name": name,
        "providerData": providerData.toJson(),
        "registrationNr": registrationNr,
        "type": type,
        "uidNr": uidNr,
        "websiteUrl": websiteUrl,
      };
}

class Address {
  Address({
    required this.city,
    required this.country,
    required this.number,
    required this.street,
    required this.zip,
  });

  String city;
  String country;
  String number;
  String street;
  String zip;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        number: json["number"],
        street: json["street"],
        zip: json["zip"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "number": number,
        "street": street,
        "zip": zip,
      };
}

class ProviderData {
  ProviderData({
    required this.bankDetails,
    required this.branchIds,
    required this.paymentInterval,
    required this.subscriptionPlanId,
  });

  BankDetails bankDetails;
  List<String> branchIds;
  int paymentInterval;
  String subscriptionPlanId;

  factory ProviderData.fromRawJson(String str) =>
      ProviderData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProviderData.fromJson(Map<String, dynamic> json) => ProviderData(
        bankDetails: BankDetails.fromJson(json["bankDetails"]),
        branchIds: List<String>.from(json["branchIds"].map((x) => x)),
        paymentInterval: json["paymentInterval"],
        subscriptionPlanId: json["subscriptionPlanId"],
      );

  Map<String, dynamic> toJson() => {
        "bankDetails": bankDetails.toJson(),
        "branchIds": List<dynamic>.from(branchIds.map((x) => x)),
        "paymentInterval": paymentInterval,
        "subscriptionPlanId": subscriptionPlanId,
      };
}

class BankDetails {
  BankDetails({
    required this.accountOwner,
    required this.bic,
    required this.iban,
  });

  String accountOwner;
  String bic;
  String iban;

  factory BankDetails.fromRawJson(String str) =>
      BankDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        accountOwner: json["accountOwner"],
        bic: json["bic"],
        iban: json["iban"],
      );

  Map<String, dynamic> toJson() => {
        "accountOwner": accountOwner,
        "bic": bic,
        "iban": iban,
      };
}

class User {
  User({
    required this.email,
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.roles,
    required this.salutation,
    required this.telephoneNr,
    required this.title,
  });

  String email;
  String firstName;
  String id;
  String lastName;
  List<int> roles;
  String salutation;
  String telephoneNr;
  String title;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        firstName: json["firstName"],
        id: json["id"],
        lastName: json["lastName"],
        roles: List<int>.from(json["roles"].map((x) => x)),
        salutation: json["salutation"],
        telephoneNr: json["telephoneNr"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "id": id,
        "lastName": lastName,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "salutation": salutation,
        "telephoneNr": telephoneNr,
        "title": title,
      };
}
