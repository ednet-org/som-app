part of som_manager;

// lib/gen/som/manager/users.dart

abstract class UserGen extends Entity<User> {
  UserGen(Concept concept) {
    this.concept = concept;
    Concept? phoneNumberConcept =
        concept.model.concepts.singleWhereCode("PhoneNumber");
    assert(phoneNumberConcept != null);
    setChild("phoneNumber", PhoneNumbers(phoneNumberConcept!));
    Concept? emailConcept = concept.model.concepts.singleWhereCode("Email");
    assert(emailConcept != null);
    setChild("email", Emails(emailConcept!));
    Concept? inquiryConcept = concept.model.concepts.singleWhereCode("Inquiry");
    assert(inquiryConcept != null);
    setChild("inquiries", Inquiries(inquiryConcept!));
  }

  Reference get companyReference => getReference("company") as Reference;

  void set companyReference(Reference reference) {
    setReference("company", reference);
  }

  Company get company => getParent("company") as Company;

  void set company(Company p) {
    setParent("company", p);
  }

  String get username => getAttribute("username");

  void set username(String a) {
    setAttribute("username", a);
  }

  String get roleAtSom => getAttribute("roleAtSom");

  void set roleAtSom(String a) {
    setAttribute("roleAtSom", a);
  }

  String get roleAtCompany => getAttribute("roleAtCompany");

  void set roleAtCompany(String a) {
    setAttribute("roleAtCompany", a);
  }

  PhoneNumbers get phoneNumber => getChild("phoneNumber") as PhoneNumbers;

  void set phoneNumber(PhoneNumbers phoneNumbers) {
    setChild("phoneNumber", phoneNumbers);
  }

  Emails get email => getChild("email") as Emails;

  Inquiries get inquiries => getChild("inquiries") as Inquiries;

  User newEntity() => User(concept);

  Users newEntities() => Users(concept);
}

abstract class UsersGen extends Entities<User> {
  UsersGen(Concept concept) {
    this.concept = concept;
  }

  Users newEntities() => Users(concept);

  User newEntity() => User(concept);
}
