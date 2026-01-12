part of som_manager;

// lib/gen/som/manager/users.dart

abstract class UserGen extends Entity<User> {
  UserGen(Concept concept) {
    this.concept = concept;
    Concept platformRoleConcept =
        concept.model.concepts.singleWhereCode("PlatformRole") as Concept;
    setChild("platformRoles", PlatformRoles(platformRoleConcept));
    Concept phoneNumberConcept =
        concept.model.concepts.singleWhereCode("PhoneNumber") as Concept;
    setChild("phoneNumber", PhoneNumbers(phoneNumberConcept));
    Concept emailConcept =
        concept.model.concepts.singleWhereCode("Email") as Concept;
    setChild("email", Emails(emailConcept));
  }

  Reference get tenantRoleReference => getReference("tenantRole") as Reference;
  void set tenantRoleReference(Reference reference) {
    setReference("tenantRole", reference);
  }

  TenantRole get tenantRole => getParent("tenantRole") as TenantRole;
  void set tenantRole(TenantRole p) {
    setParent("tenantRole", p);
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

  PlatformRoles get platformRoles => getChild("platformRoles") as PlatformRoles;

  PhoneNumbers get phoneNumber => getChild("phoneNumber") as PhoneNumbers;

  Emails get email => getChild("email") as Emails;

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
