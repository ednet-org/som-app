part of som_manager; 
 
// lib/gen/som/manager/user_role_at_companies.dart 
 
abstract class UserRoleAtCompanyGen extends Entity<UserRoleAtCompany> { 
 
  UserRoleAtCompanyGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get role => getAttribute("role"); 
  void set role(String a) { setAttribute("role", a); } 
  
  UserRoleAtCompany newEntity() => UserRoleAtCompany(concept); 
  UserRoleAtCompanies newEntities() => UserRoleAtCompanies(concept); 
  
} 
 
abstract class UserRoleAtCompaniesGen extends Entities<UserRoleAtCompany> { 
 
  UserRoleAtCompaniesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  UserRoleAtCompanies newEntities() => UserRoleAtCompanies(concept!); 
  UserRoleAtCompany newEntity() => UserRoleAtCompany(concept!); 
  
} 
 
