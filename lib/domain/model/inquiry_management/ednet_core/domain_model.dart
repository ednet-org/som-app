import 'package:ednet_core/ednet_core.dart';

class Inquiry extends Entity<Inquiry> {
  String get name => code ?? 'Inquiry';

  set name(String name) => code = name;

  String status;
  String inquiryCreator;
  Branch branch;
  DateTime deadline;
  DateTime creationDate;
  DateTime offerCreationDate;
  DateTime decisionDate;
  DateTime assignmentDate;
  String buyerData;
  String companyName;
  String contactPersonName;
  String contactPersonLastName;
  String contactPersonTitle;
  String contactPersonSalutation;
  String telephone;
  String email;
  String inquiryDescription;
  String deliveryAddress;
  List<Provider> providers;

  Inquiry(
      this.status,
      this.inquiryCreator,
      this.branch,
      this.deadline,
      this.creationDate,
      this.offerCreationDate,
      this.decisionDate,
      this.assignmentDate,
      this.buyerData,
      this.companyName,
      this.contactPersonName,
      this.contactPersonLastName,
      this.contactPersonTitle,
      this.contactPersonSalutation,
      this.telephone,
      this.email,
      this.inquiryDescription,
      this.deliveryAddress,
      this.providers);
}

class Offer extends Entity<Offer> {
  String get name => code ?? 'Offer';

  set name(String name) => code = name;

  Inquiry inquiry;
  Company provider;
  DateTime offerCreationDate;
  String offerPDF;
  String buyerAction;
  String providerAction;
  DateTime forwardDate;
  DateTime resolveDate;

  Offer(
      this.inquiry,
      this.provider,
      this.offerCreationDate,
      this.offerPDF,
      this.buyerAction,
      this.providerAction,
      this.forwardDate,
      this.resolveDate);
}

class Company extends Entity<Company> {
  String get name => code ?? 'Company';

  set name(String name) => code = name;

  String branch;
  String companySize;
  String providerType;
  String postcode;
  bool claimed;
  int numReceivedInquiries;
  int numSentOffers;
  int numAcceptedOffers;
  String registrationDate;
  String subscriptionPackageType;
  String IBAN;
  String BIC;
  String accountHolder;
  String paymentInterval;

  Company(
      this.branch,
      this.companySize,
      this.providerType,
      this.postcode,
      this.claimed,
      this.numReceivedInquiries,
      this.numSentOffers,
      this.numAcceptedOffers,
      this.registrationDate,
      this.subscriptionPackageType,
      this.IBAN,
      this.BIC,
      this.accountHolder,
      this.paymentInterval);
}

class Branch extends Entity<Branch> {
  String get name => code ?? 'Branch';

  set name(String name) => code = name;

  String category;

  Branch(this.category);
}

class Provider extends Entity<Provider> {
  String get name => code ?? 'Provider';
}
