part of som_manager; 
 
// lib/gen/som/manager/company_types.dart 
 
abstract class CompanyTypeGen extends Entity<CompanyType> { 
 
  CompanyTypeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  CompanyType newEntity() => CompanyType(concept!); 
  CompanyTypes newEntities() => CompanyTypes(concept!); 
  
} 
 
abstract class CompanyTypesGen extends Entities<CompanyType> { 
 
  CompanyTypesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CompanyTypes newEntities() => CompanyTypes(concept!); 
  CompanyType newEntity() => CompanyType(concept!); 
  
} 
 
