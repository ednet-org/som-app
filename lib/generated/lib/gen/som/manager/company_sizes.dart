part of som_manager; 
 
// lib/gen/som/manager/company_sizes.dart 
 
abstract class CompanySizeGen extends Entity<CompanySize> { 
 
  CompanySizeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get size => getAttribute("size"); 
  void set size(String a) { setAttribute("size", a); } 
  
  CompanySize newEntity() => CompanySize(concept); 
  CompanySizes newEntities() => CompanySizes(concept); 
  
} 
 
abstract class CompanySizesGen extends Entities<CompanySize> { 
 
  CompanySizesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CompanySizes newEntities() => CompanySizes(concept!); 
  CompanySize newEntity() => CompanySize(concept!); 
  
} 
 
