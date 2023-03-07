part of som_manager; 
 
// lib/gen/som/manager/company_types.dart 
 
abstract class CompanyTypeGen extends Entity<CompanyType> { 
 
  CompanyTypeGen(Concept concept) { 
    this.concept = concept; 
    Concept companyConcept = concept.model.concepts.singleWhereCode("Company") as Concept; 
    assert(companyConcept != null); 
    setChild("companies", Companies(companyConcept)); 
  } 
 
  String get value => getAttribute("value"); 
  void set value(String a) { setAttribute("value", a); } 
  
  Companies get companies => getChild("companies") as Companies; 
  
  CompanyType newEntity() => CompanyType(concept); 
  CompanyTypes newEntities() => CompanyTypes(concept); 
  
} 
 
abstract class CompanyTypesGen extends Entities<CompanyType> { 
 
  CompanyTypesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CompanyTypes newEntities() => CompanyTypes(concept); 
  CompanyType newEntity() => CompanyType(concept); 
  
} 
 
