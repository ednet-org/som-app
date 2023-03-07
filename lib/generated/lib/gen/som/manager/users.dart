part of som_manager; 
 
// lib/gen/som/manager/users.dart 
 
abstract class UserGen extends Entity<User> { 
 
  UserGen(Concept concept) { 
    this.concept = concept; 
    Concept emailConcept = concept.model.concepts.singleWhereCode("Email") as Concept; 
    assert(emailConcept != null); 
    setChild("email", Emails(emailConcept)); 
  } 
 
  Reference get companyReference => getReference("company") as Reference; 
  void set companyReference(Reference reference) { setReference("company", reference); } 
  
  Company get company => getParent("company") as Company; 
  void set company(Company p) { setParent("company", p); } 
  
  Reference get tenantRoleReference => getReference("tenantRole") as Reference; 
  void set tenantRoleReference(Reference reference) { setReference("tenantRole", reference); } 
  
  TenantRole get tenantRole => getParent("tenantRole") as TenantRole; 
  void set tenantRole(TenantRole p) { setParent("tenantRole", p); } 
  
  String get username => getAttribute("username"); 
  void set username(String a) { setAttribute("username", a); } 
  
  String get phoneNumber => getAttribute("phoneNumber"); 
  void set phoneNumber(String a) { setAttribute("phoneNumber", a); } 
  
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
 
