import 'dart:convert';

import '../services/mappings.dart';

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
    this.termsAcceptedAt,
    this.privacyAcceptedAt,
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
  final DateTime? termsAcceptedAt;
  final DateTime? privacyAcceptedAt;
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
        'termsAcceptedAt': termsAcceptedAt?.toIso8601String(),
        'privacyAcceptedAt': privacyAcceptedAt?.toIso8601String(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class UserRecord {
  static const Object _unset = Object();

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
    this.lastLoginCompanyId,
    required this.createdAt,
    required this.updatedAt,
    this.passwordHash,
    this.failedLoginAttempts = 0,
    this.lastFailedLoginAt,
    this.lockedAt,
    this.lockReason,
    this.removedAt,
    this.removedByUserId,
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
  final String? lastLoginCompanyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? passwordHash;
  final int failedLoginAttempts;
  final DateTime? lastFailedLoginAt;
  final DateTime? lockedAt;
  final String? lockReason;
  final DateTime? removedAt;
  final String? removedByUserId;

  UserRecord copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? salutation,
    String? title,
    String? telephoneNr,
    List<String>? roles,
    bool? isActive,
    bool? emailConfirmed,
    String? lastLoginRole,
    String? lastLoginCompanyId,
    String? companyId,
    DateTime? updatedAt,
    int? failedLoginAttempts,
    Object? lastFailedLoginAt = _unset,
    Object? lockedAt = _unset,
    Object? lockReason = _unset,
    Object? removedAt = _unset,
    Object? removedByUserId = _unset,
  }) {
    return UserRecord(
      id: id,
      companyId: companyId ?? this.companyId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      salutation: salutation ?? this.salutation,
      title: title ?? this.title,
      telephoneNr: telephoneNr ?? this.telephoneNr,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      lastLoginRole: lastLoginRole ?? this.lastLoginRole,
      lastLoginCompanyId: lastLoginCompanyId ?? this.lastLoginCompanyId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      passwordHash: passwordHash,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      lastFailedLoginAt: identical(lastFailedLoginAt, _unset)
          ? this.lastFailedLoginAt
          : lastFailedLoginAt as DateTime?,
      lockedAt:
          identical(lockedAt, _unset) ? this.lockedAt : lockedAt as DateTime?,
      lockReason: identical(lockReason, _unset)
          ? this.lockReason
          : lockReason as String?,
      removedAt: identical(removedAt, _unset)
          ? this.removedAt
          : removedAt as DateTime?,
      removedByUserId: identical(removedByUserId, _unset)
          ? this.removedByUserId
          : removedByUserId as String?,
    );
  }

  Map<String, dynamic> toDtoJson() => {
        'id': id,
        'companyId': companyId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'salutation': salutation,
        'title': title,
        'telephoneNr': telephoneNr,
        'roles': roles.map(roleToWire).toList(),
      };
}

class UserCompanyRoleRecord {
  UserCompanyRoleRecord({
    required this.userId,
    required this.companyId,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;
  final String companyId;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class EmailEventRecord {
  EmailEventRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String type;
  final DateTime createdAt;
}

class RoleRecord {
  RoleRecord({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class ProductRecord {
  ProductRecord({
    required this.id,
    required this.companyId,
    required this.name,
    required this.createdAt,
  });

  final String id;
  final String companyId;
  final String name;
  final DateTime createdAt;
}

class SubscriptionPlanRecord {
  SubscriptionPlanRecord({
    required this.id,
    required this.name,
    required this.sortPriority,
    required this.isActive,
    required this.priceInSubunit,
    required this.maxUsers,
    required this.setupFeeInSubunit,
    required this.bannerAdsPerMonth,
    required this.normalAdsPerMonth,
    required this.freeMonths,
    required this.commitmentPeriodMonths,
    required this.rules,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int sortPriority;
  final bool isActive;
  final int priceInSubunit;
  final int? maxUsers;
  final int? setupFeeInSubunit;
  final int? bannerAdsPerMonth;
  final int? normalAdsPerMonth;
  final int? freeMonths;
  final int? commitmentPeriodMonths;
  final List<Map<String, dynamic>> rules;
  final DateTime createdAt;

  Map<String, dynamic> toDtoJson() => {
        'id': id,
        'title': name,
        'sortPriority': sortPriority,
        'isActive': isActive,
        'priceInSubunit': priceInSubunit,
        'maxUsers': maxUsers,
        'setupFeeInSubunit': setupFeeInSubunit,
        'bannerAdsPerMonth': bannerAdsPerMonth,
        'normalAdsPerMonth': normalAdsPerMonth,
        'freeMonths': freeMonths,
        'commitmentPeriodMonths': commitmentPeriodMonths,
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

class BillingRecord {
  BillingRecord({
    required this.id,
    required this.companyId,
    required this.amountInSubunit,
    required this.currency,
    required this.status,
    required this.periodStart,
    required this.periodEnd,
    required this.createdAt,
    required this.paidAt,
  });

  final String id;
  final String companyId;
  final int amountInSubunit;
  final String currency;
  final String status;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime createdAt;
  final DateTime? paidAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyId': companyId,
        'amountInSubunit': amountInSubunit,
        'currency': currency,
        'status': status,
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'paidAt': paidAt?.toIso8601String(),
      };
}

class SubscriptionCancellationRecord {
  SubscriptionCancellationRecord({
    required this.id,
    required this.companyId,
    required this.requestedByUserId,
    required this.reason,
    required this.status,
    required this.requestedAt,
    required this.effectiveEndDate,
    required this.resolvedAt,
  });

  final String id;
  final String companyId;
  final String requestedByUserId;
  final String? reason;
  final String status;
  final DateTime requestedAt;
  final DateTime? effectiveEndDate;
  final DateTime? resolvedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyId': companyId,
        'requestedByUserId': requestedByUserId,
        'reason': reason,
        'status': status,
        'requestedAt': requestedAt.toIso8601String(),
        'effectiveEndDate': effectiveEndDate?.toIso8601String(),
        'resolvedAt': resolvedAt?.toIso8601String(),
      };
}

class ProviderProfileRecord {
  ProviderProfileRecord({
    required this.companyId,
    required this.bankDetails,
    required this.branchIds,
    required this.pendingBranchIds,
    required this.subscriptionPlanId,
    required this.paymentInterval,
    required this.providerType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.rejectionReason,
    this.rejectedAt,
  });

  final String companyId;
  final BankDetails bankDetails;
  final List<String> branchIds;
  final List<String> pendingBranchIds;
  final String subscriptionPlanId;
  final String paymentInterval;
  final String? providerType;
  final String status;
  final String? rejectionReason;
  final DateTime? rejectedAt;
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
    this.summaryPdfPath,
    required this.providerCriteria,
    required this.contactInfo,
    required this.notifiedAt,
    required this.assignedAt,
    required this.closedAt,
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
  final String? summaryPdfPath;
  final ProviderCriteria providerCriteria;
  final ContactInfo contactInfo;
  final DateTime? notifiedAt;
  final DateTime? assignedAt;
  final DateTime? closedAt;
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
        'summaryPdfPath': summaryPdfPath,
        'providerCriteria': providerCriteria.toJson(),
        'contactInfo': contactInfo.toJson(),
        'notifiedAt': notifiedAt?.toIso8601String(),
        'assignedAt': assignedAt?.toIso8601String(),
        'closedAt': closedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class InquiryAssignmentRecord {
  InquiryAssignmentRecord({
    required this.id,
    required this.inquiryId,
    required this.providerCompanyId,
    required this.assignedAt,
    required this.assignedByUserId,
    required this.deadlineReminderSentAt,
  });

  final String id;
  final String inquiryId;
  final String providerCompanyId;
  final DateTime assignedAt;
  final String assignedByUserId;
  final DateTime? deadlineReminderSentAt;
}

class OfferRecord {
  OfferRecord({
    required this.id,
    required this.inquiryId,
    required this.providerCompanyId,
    required this.providerUserId,
    required this.status,
    required this.pdfPath,
    this.summaryPdfPath,
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
  final String? summaryPdfPath;
  final DateTime? forwardedAt;
  final DateTime? resolvedAt;
  final String? buyerDecision;
  final String? providerDecision;
  final DateTime createdAt;
}

class DomainEventRecord {
  DomainEventRecord({
    required this.id,
    required this.type,
    required this.status,
    required this.entityType,
    required this.entityId,
    required this.actorId,
    required this.payload,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String status;
  final String entityType;
  final String entityId;
  final String? actorId;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;
}

class AuditLogRecord {
  AuditLogRecord({
    required this.id,
    required this.actorId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.metadata,
    required this.createdAt,
  });

  final String id;
  final String? actorId;
  final String action;
  final String entityType;
  final String entityId;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
}

class SchedulerStatusRecord {
  SchedulerStatusRecord({
    required this.jobName,
    required this.lastRunAt,
    required this.lastSuccessAt,
    required this.lastError,
    required this.updatedAt,
  });

  final String jobName;
  final DateTime? lastRunAt;
  final DateTime? lastSuccessAt;
  final String? lastError;
  final DateTime updatedAt;
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

class ProviderSearchParams {
  ProviderSearchParams({
    this.limit = 50,
    this.offset = 0,
    this.search,
    this.branchId,
    this.categoryId,
    this.providerType,
    this.status,
    this.zipPrefix,
    this.companySize,
    this.claimed,
  });

  final int limit;
  final int offset;
  final String? search;
  final String? branchId;
  final String? categoryId;
  final String? providerType;
  final String? status;
  final String? zipPrefix;
  final String? companySize;
  final bool? claimed;
}

class ProviderSearchResult {
  ProviderSearchResult({
    required this.totalCount,
    required this.items,
  });

  final int totalCount;
  final List<ProviderSummaryRecord> items;
}

class ProviderSummaryRecord {
  ProviderSummaryRecord({
    required this.companyId,
    required this.companyName,
    required this.companySize,
    required this.providerType,
    required this.postcode,
    required this.branchIds,
    required this.pendingBranchIds,
    required this.status,
    required this.rejectionReason,
    required this.rejectedAt,
    required this.subscriptionPlanId,
    required this.paymentInterval,
    required this.bankDetails,
    required this.registrationDate,
    List<CompanyBranchAssignmentRecord>? branchAssignments,
    List<CompanyCategoryAssignmentRecord>? categoryAssignments,
  })  : branchAssignments = branchAssignments ?? const [],
        categoryAssignments = categoryAssignments ?? const [];

  final String companyId;
  final String companyName;
  final String companySize;
  final String? providerType;
  final String postcode;
  final List<String> branchIds;
  final List<String> pendingBranchIds;
  final String status;
  final String? rejectionReason;
  final DateTime? rejectedAt;
  final String subscriptionPlanId;
  final String paymentInterval;
  final BankDetails bankDetails;
  final DateTime registrationDate;
  final List<CompanyBranchAssignmentRecord> branchAssignments;
  final List<CompanyCategoryAssignmentRecord> categoryAssignments;

  bool get claimed => status == 'active';

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'companyName': companyName,
        'companySize': companySize,
        'providerType': providerType,
        'postcode': postcode,
        'branchIds': branchIds,
        'pendingBranchIds': pendingBranchIds,
        'branchAssignments': branchAssignments.map((a) => a.toJson()).toList(),
        'categoryAssignments':
            categoryAssignments.map((a) => a.toJson()).toList(),
        'status': status,
        'rejectionReason': rejectionReason,
        'rejectedAt': rejectedAt?.toIso8601String(),
        'claimed': claimed,
        'subscriptionPlanId': subscriptionPlanId,
        'paymentInterval': paymentInterval,
        'iban': bankDetails.iban,
        'bic': bankDetails.bic,
        'accountOwner': bankDetails.accountOwner,
        'registrationDate': registrationDate.toIso8601String(),
      };
}

class CompanyBranchAssignmentRecord {
  CompanyBranchAssignmentRecord({
    required this.branchId,
    required this.branchName,
    required this.source,
    required this.status,
    this.confidence,
  });

  final String branchId;
  final String branchName;
  final String source;
  final String status;
  final double? confidence;

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'branchName': branchName,
        'source': source,
        'confidence': confidence,
        'status': status,
      };
}

class CompanyCategoryAssignmentRecord {
  CompanyCategoryAssignmentRecord({
    required this.categoryId,
    required this.categoryName,
    required this.branchId,
    required this.branchName,
    required this.source,
    required this.status,
    this.confidence,
  });

  final String categoryId;
  final String categoryName;
  final String branchId;
  final String branchName;
  final String source;
  final String status;
  final double? confidence;

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'branchId': branchId,
        'branchName': branchName,
        'source': source,
        'confidence': confidence,
        'status': status,
      };
}

class CompanyTaxonomyRecord {
  CompanyTaxonomyRecord({
    required this.companyId,
    required this.branches,
    required this.categories,
  });

  final String companyId;
  final List<CompanyBranchAssignmentRecord> branches;
  final List<CompanyCategoryAssignmentRecord> categories;

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'branches': branches.map((b) => b.toJson()).toList(),
        'categories': categories.map((c) => c.toJson()).toList(),
      };
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
