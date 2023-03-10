part of som_manager; 
 
// lib/gen/som/manager/company_role_at_soms.dart 
 
abstract class CompanyRoleAtSomGen extends Entity<CompanyRoleAtSom> { 
 
  CompanyRoleAtSomGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get value => getAttribute("value"); 
  void set value(String a) { setAttribute("value", a); } 
  
  CompanyRoleAtSom newEntity() => CompanyRoleAtSom(concept); 
  CompanyRoleAtSoms newEntities() => CompanyRoleAtSoms(concept); 
  
} 
 
abstract class CompanyRoleAtSomsGen extends Entities<CompanyRoleAtSom> { 
 
  CompanyRoleAtSomsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CompanyRoleAtSoms newEntities() => CompanyRoleAtSoms(concept); 
  CompanyRoleAtSom newEntity() => CompanyRoleAtSom(concept); 
  
} 
 
