import 'dart:convert';

class Address {
  Address({
    required this.country,
    required this.city,
    required this.street,
    required this.number,
    required this.zip,
  });

  final String country;
  final String city;
  final String street;
  final String number;
  final String zip;

  Map<String, dynamic> toJson() => {
        'country': country,
        'city': city,
        'street': street,
        'number': number,
        'zip': zip,
      };

  static Address fromJson(Map<String, dynamic> json) => Address(
        country: json['country'] as String? ?? '',
        city: json['city'] as String? ?? '',
        street: json['street'] as String? ?? '',
        number: json['number'] as String? ?? '',
        zip: json['zip'] as String? ?? '',
      );
}

class BankDetails {
  BankDetails({
    required this.iban,
    required this.bic,
    required this.accountOwner,
  });

  final String iban;
  final String bic;
  final String accountOwner;

  Map<String, dynamic> toJson() => {
        'iban': iban,
        'bic': bic,
        'accountOwner': accountOwner,
      };

  static BankDetails fromJson(Map<String, dynamic> json) => BankDetails(
        iban: json['iban'] as String? ?? '',
        bic: json['bic'] as String? ?? '',
        accountOwner: json['accountOwner'] as String? ?? '',
      );
}

class ProviderCriteria {
  ProviderCriteria({
    this.providerZip,
    this.radiusKm,
    this.providerType,
    this.companySize,
  });

  final String? providerZip;
  final int? radiusKm;
  final String? providerType;
  final String? companySize;

  Map<String, dynamic> toJson() => {
        'providerZip': providerZip,
        'radiusKm': radiusKm,
        'providerType': providerType,
        'companySize': companySize,
      };

  static ProviderCriteria fromJson(Map<String, dynamic> json) =>
      ProviderCriteria(
        providerZip: json['providerZip'] as String?,
        radiusKm: json['radiusKm'] as int?,
        providerType: json['providerType'] as String?,
        companySize: json['companySize'] as String?,
      );
}

class ContactInfo {
  ContactInfo({
    required this.companyName,
    required this.salutation,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    required this.email,
  });

  final String companyName;
  final String salutation;
  final String title;
  final String firstName;
  final String lastName;
  final String telephone;
  final String email;

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'salutation': salutation,
        'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'telephone': telephone,
        'email': email,
      };

  static ContactInfo fromJson(Map<String, dynamic> json) => ContactInfo(
        companyName: json['companyName'] as String? ?? '',
        salutation: json['salutation'] as String? ?? '',
        title: json['title'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        telephone: json['telephone'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );
}

class CompanyRecord {
  CompanyRecord({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.uidNr,
    required this.registrationNr,
    required this.companySize,
    required this.websiteUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String type;
  final Address address;
  final String uidNr;
  final String registrationNr;
  final String companySize;
  final String? websiteUrl;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'address': address.toJson(),
        'uidNr': uidNr,
        'registrationNr': registrationNr,
        'companySize': companySize,
        'websiteUrl': websiteUrl,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class UserRecord {
  UserRecord({
    required this.id,
    required this.companyId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.salutation,
    required this.title,
    required this.telephoneNr,
    required this.roles,
    required this.isActive,
    required this.emailConfirmed,
    required this.lastLoginRole,
    required this.createdAt,
    required this.updatedAt,
    this.passwordHash,
  });

  final String id;
  final String companyId;
  final String email;
  final String firstName;
  final String lastName;
  final String salutation;
  final String? title;
  final String? telephoneNr;
  final List<String> roles;
  final bool isActive;
  final bool emailConfirmed;
  final String? lastLoginRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? passwordHash;

  Map<String, dynamic> toDtoJson() => {
        'id': id,
        'companyId': companyId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'salutation': salutation,
        'title': title,
        'telephoneNr': telephoneNr,
        'roles': roles,
      };
}

class SubscriptionPlanRecord {
  SubscriptionPlanRecord({
    required this.id,
    required this.name,
    required this.sortPriority,
    required this.isActive,
    required this.priceInSubunit,
    required this.rules,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int sortPriority;
  final bool isActive;
  final int priceInSubunit;
  final List<Map<String, dynamic>> rules;
  final DateTime createdAt;

  Map<String, dynamic> toDtoJson() => {
        'id': id,
        'sortPriority': sortPriority,
        'isActive': isActive,
        'priceInSubunit': priceInSubunit,
        'rules': rules,
        'createdAt': createdAt.toIso8601String(),
      };
}

class SubscriptionRecord {
  SubscriptionRecord({
    required this.id,
    required this.companyId,
    required this.planId,
    required this.status,
    required this.paymentInterval,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  final String id;
  final String companyId;
  final String planId;
  final String status;
  final String paymentInterval;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
}

class ProviderProfileRecord {
  ProviderProfileRecord({
    required this.companyId,
    required this.bankDetails,
    required this.branchIds,
    required this.pendingBranchIds,
    required this.subscriptionPlanId,
    required this.paymentInterval,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String companyId;
  final BankDetails bankDetails;
  final List<String> branchIds;
  final List<String> pendingBranchIds;
  final String subscriptionPlanId;
  final String paymentInterval;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class InquiryRecord {
  InquiryRecord({
    required this.id,
    required this.buyerCompanyId,
    required this.createdByUserId,
    required this.status,
    required this.branchId,
    required this.categoryId,
    required this.productTags,
    required this.deadline,
    required this.deliveryZips,
    required this.numberOfProviders,
    required this.description,
    required this.pdfPath,
    required this.providerCriteria,
    required this.contactInfo,
    required this.notifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String buyerCompanyId;
  final String createdByUserId;
  final String status;
  final String branchId;
  final String categoryId;
  final List<String> productTags;
  final DateTime deadline;
  final List<String> deliveryZips;
  final int numberOfProviders;
  final String? description;
  final String? pdfPath;
  final ProviderCriteria providerCriteria;
  final ContactInfo contactInfo;
  final DateTime? notifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'buyerCompanyId': buyerCompanyId,
        'createdByUserId': createdByUserId,
        'status': status,
        'branchId': branchId,
        'categoryId': categoryId,
        'productTags': productTags,
        'deadline': deadline.toIso8601String(),
        'deliveryZips': deliveryZips,
        'numberOfProviders': numberOfProviders,
        'description': description,
        'pdfPath': pdfPath,
        'providerCriteria': providerCriteria.toJson(),
        'contactInfo': contactInfo.toJson(),
        'notifiedAt': notifiedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class OfferRecord {
  OfferRecord({
    required this.id,
    required this.inquiryId,
    required this.providerCompanyId,
    required this.providerUserId,
    required this.status,
    required this.pdfPath,
    required this.forwardedAt,
    required this.resolvedAt,
    required this.buyerDecision,
    required this.providerDecision,
    required this.createdAt,
  });

  final String id;
  final String inquiryId;
  final String providerCompanyId;
  final String? providerUserId;
  final String status;
  final String? pdfPath;
  final DateTime? forwardedAt;
  final DateTime? resolvedAt;
  final String? buyerDecision;
  final String? providerDecision;
  final DateTime createdAt;
}

class AdRecord {
  AdRecord({
    required this.id,
    required this.companyId,
    required this.type,
    required this.status,
    required this.branchId,
    required this.url,
    required this.imagePath,
    required this.headline,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.bannerDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String companyId;
  final String type;
  final String status;
  final String branchId;
  final String url;
  final String imagePath;
  final String? headline;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? bannerDate;
  final DateTime createdAt;
  final DateTime updatedAt;
}

String encodeJson(Object value) => jsonEncode(value);

Map<String, dynamic> decodeJsonMap(Object? value) {
  if (value == null) {
    return <String, dynamic>{};
  }
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.cast<String, dynamic>();
  }
  if (value is String && value.isNotEmpty) {
    return jsonDecode(value) as Map<String, dynamic>;
  }
  return <String, dynamic>{};
}

List<dynamic> decodeJsonList(Object? value) {
  if (value == null) {
    return <dynamic>[];
  }
  if (value is List) {
    return value;
  }
  if (value is String && value.isNotEmpty) {
    return jsonDecode(value) as List<dynamic>;
  }
  return <dynamic>[];
}

DateTime parseDate(Object? value) {
  if (value is DateTime) {
    return value.toUtc();
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value).toUtc();
  }
  throw StateError('Invalid date value $value');
}

DateTime? parseDateOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.toUtc();
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value).toUtc();
  }
  return null;
}

List<String> decodeStringList(Object? value) {
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  if (value is String) {
    return value
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }
  return <String>[];
}
