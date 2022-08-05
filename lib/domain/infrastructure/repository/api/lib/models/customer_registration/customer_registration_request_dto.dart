class CustomerRegistrationRequestDto {
  Company? company;
  List<Users>? users;

  CustomerRegistrationRequestDto({this.company, this.users});

  CustomerRegistrationRequestDto.fromJson(Map<String, dynamic> json) {
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  String? name;
  Address? address;
  String? uidNr;
  String? registrationNr;
  int? companySize;
  int? type;
  String? websiteUrl;
  ProviderData? providerData;

  Company(
      {this.name,
      this.address,
      this.uidNr,
      this.registrationNr,
      this.companySize,
      this.type,
      this.websiteUrl,
      this.providerData});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    uidNr = json['uidNr'];
    registrationNr = json['registrationNr'];
    companySize = json['companySize'];
    type = json['type'];
    websiteUrl = json['websiteUrl'];
    providerData = json['providerData'] != null
        ? new ProviderData.fromJson(json['providerData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['uidNr'] = this.uidNr;
    data['registrationNr'] = this.registrationNr;
    data['companySize'] = this.companySize;
    data['type'] = this.type;
    data['websiteUrl'] = this.websiteUrl;
    if (this.providerData != null) {
      data['providerData'] = this.providerData!.toJson();
    }
    return data;
  }
}

class Address {
  String? country;
  String? city;
  String? street;
  String? number;
  String? zip;

  Address({this.country, this.city, this.street, this.number, this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    city = json['city'];
    street = json['street'];
    number = json['number'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['city'] = this.city;
    data['street'] = this.street;
    data['number'] = this.number;
    data['zip'] = this.zip;
    return data;
  }
}

class ProviderData {
  BankDetails? bankDetails;
  List<String>? branchIds;
  int? paymentInterval;
  String? subscriptionPlanId;

  ProviderData(
      {this.bankDetails,
      this.branchIds,
      this.paymentInterval,
      this.subscriptionPlanId});

  ProviderData.fromJson(Map<String, dynamic> json) {
    bankDetails = json['bankDetails'] != null
        ? new BankDetails.fromJson(json['bankDetails'])
        : null;
    branchIds = json['branchIds'].cast<String>();
    paymentInterval = json['paymentInterval'];
    subscriptionPlanId = json['subscriptionPlanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bankDetails != null) {
      data['bankDetails'] = this.bankDetails!.toJson();
    }
    data['branchIds'] = this.branchIds;
    data['paymentInterval'] = this.paymentInterval;
    data['subscriptionPlanId'] = this.subscriptionPlanId;
    return data;
  }
}

class BankDetails {
  String? iban;
  String? bic;
  String? accountOwner;

  BankDetails({this.iban, this.bic, this.accountOwner});

  BankDetails.fromJson(Map<String, dynamic> json) {
    iban = json['iban'];
    bic = json['bic'];
    accountOwner = json['accountOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iban'] = this.iban;
    data['bic'] = this.bic;
    data['accountOwner'] = this.accountOwner;
    return data;
  }
}

class Users {
  String? email;
  String? firstName;
  String? lastName;
  String? salutation;
  List<int>? roles;
  String? telephoneNr;
  String? title;
  String? companyId;
  String? id;

  Users(
      {this.email,
      this.firstName,
      this.lastName,
      this.salutation,
      this.roles,
      this.telephoneNr,
      this.title,
      this.companyId,
      this.id});

  Users.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    salutation = json['salutation'];
    roles = json['roles'].cast<int>();
    telephoneNr = json['telephoneNr'];
    title = json['title'];
    companyId = json['companyId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['salutation'] = this.salutation;
    data['roles'] = this.roles;
    data['telephoneNr'] = this.telephoneNr;
    data['title'] = this.title;
    data['companyId'] = this.companyId;
    data['id'] = this.id;
    return data;
  }
}
