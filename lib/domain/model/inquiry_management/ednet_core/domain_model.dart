import 'package:ednet_core/ednet_core.dart';

class Address {
  Address({
    required this.street,
    required this.number,
    required this.zip,
    required this.city,
    required this.country,
  });

  final String street;
  final String number;
  final String zip;
  final String city;
  final String country;
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
}

class ProviderCriteria {
  ProviderCriteria({
    this.providerZip,
    this.maxRadius,
    this.providerType,
    this.companySize,
  });

  final String? providerZip;
  final String? maxRadius;
  final String? providerType;
  final String? companySize;
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
}

class Role extends Entity<Role> {
  Role({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  String name;
  String? description;
}

class User extends Entity<User> {
  User({
    required this.id,
    required this.companyId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.salutation,
    required this.roles,
    this.title,
    this.telephone,
    this.activeRole,
    this.emailConfirmed = false,
    this.isActive = true,
  });

  final String id;
  final String companyId;
  final String email;
  final String firstName;
  final String lastName;
  final String salutation;
  final List<String> roles;
  final String? title;
  final String? telephone;
  String? activeRole;
  bool emailConfirmed;
  bool isActive;
}

class Company extends Entity<Company> {
  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.uidNr,
    required this.registrationNr,
    required this.companySize,
    required this.type,
    required this.status,
    this.websiteUrl,
  });

  final String id;
  final String name;
  final Address address;
  final String uidNr;
  final String registrationNr;
  final String companySize;
  final String type;
  String status;
  String? websiteUrl;
}

class ProviderProfile extends Entity<ProviderProfile> {
  ProviderProfile({
    required this.companyId,
    required this.bankDetails,
    required this.branchIds,
    required this.pendingBranchIds,
    required this.subscriptionPlanId,
    required this.paymentInterval,
    required this.providerType,
    required this.status,
    this.rejectionReason,
  });

  final String companyId;
  final BankDetails bankDetails;
  final List<String> branchIds;
  final List<String> pendingBranchIds;
  final String subscriptionPlanId;
  final String paymentInterval;
  final String providerType;
  String status;
  String? rejectionReason;
}

class SubscriptionPlan extends Entity<SubscriptionPlan> {
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.sortPriority,
    required this.isActive,
    required this.priceInSubunit,
    this.maxUsers,
    this.setupFeeInSubunit,
    this.bannerAdsPerMonth,
    this.normalAdsPerMonth,
    this.freeMonths,
    this.commitmentPeriodMonths,
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
}

class Subscription extends Entity<Subscription> {
  Subscription({
    required this.id,
    required this.companyId,
    required this.planId,
    required this.status,
    required this.paymentInterval,
    required this.startDate,
    required this.endDate,
  });

  final String id;
  final String companyId;
  final String planId;
  String status;
  final String paymentInterval;
  final DateTime startDate;
  final DateTime endDate;
}

class Branch extends Entity<Branch> {
  Branch({
    required this.id,
    required this.name,
  });

  final String id;
  String name;
}

class Category extends Entity<Category> {
  Category({
    required this.id,
    required this.branchId,
    required this.name,
  });

  final String id;
  final String branchId;
  String name;
}

class Product extends Entity<Product> {
  Product({
    required this.id,
    required this.companyId,
    required this.name,
  });

  final String id;
  final String companyId;
  String name;
}

class Inquiry extends Entity<Inquiry> {
  Inquiry({
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
    required this.providerCriteria,
    required this.contactInfo,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.pdfPath,
    this.notifiedAt,
    this.assignedAt,
    this.closedAt,
  });

  final String id;
  final String buyerCompanyId;
  final String createdByUserId;
  String status;
  final String branchId;
  final String categoryId;
  final List<String> productTags;
  final DateTime deadline;
  final List<String> deliveryZips;
  final int numberOfProviders;
  final ProviderCriteria providerCriteria;
  final ContactInfo contactInfo;
  final DateTime createdAt;
  DateTime updatedAt;
  String? description;
  String? pdfPath;
  DateTime? notifiedAt;
  DateTime? assignedAt;
  DateTime? closedAt;
}

class Offer extends Entity<Offer> {
  Offer({
    required this.id,
    required this.inquiryId,
    required this.providerCompanyId,
    required this.providerUserId,
    required this.status,
    required this.createdAt,
    this.pdfPath,
    this.forwardedAt,
    this.resolvedAt,
    this.buyerDecision,
    this.providerDecision,
  });

  final String id;
  final String inquiryId;
  final String providerCompanyId;
  final String providerUserId;
  String status;
  String? pdfPath;
  DateTime? forwardedAt;
  DateTime? resolvedAt;
  String? buyerDecision;
  String? providerDecision;
  final DateTime createdAt;
}

class Ad extends Entity<Ad> {
  Ad({
    required this.id,
    required this.companyId,
    required this.type,
    required this.status,
    required this.branchId,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
    this.headline,
    this.description,
    this.startDate,
    this.endDate,
    this.bannerDate,
  });

  final String id;
  final String companyId;
  String type;
  String status;
  final String branchId;
  final String url;
  String? imagePath;
  String? headline;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? bannerDate;
  final DateTime createdAt;
  DateTime updatedAt;
}
