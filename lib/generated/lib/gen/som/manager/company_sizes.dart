part of som_manager; 
 
// lib/gen/som/manager/company_sizes.dart 
 
abstract class CompanySizeGen extends Entity<CompanySize> { 
 
  CompanySizeGen(Concept concept) { 
    this.concept = concept; 
    Concept companyConcept = concept.model.concepts.singleWhereCode("Company") as Concept; 
    assert(companyConcept != null); 
    setChild("companies", Companies(companyConcept)); 
  } 
 
  String get value => getAttribute("value"); 
  void set value(String a) { setAttribute("value", a); } 
  
  Companies get companies => getChild("companies") as Companies; 
  
  CompanySize newEntity() => CompanySize(concept); 
  CompanySizes newEntities() => CompanySizes(concept); 
  
} 
 
abstract class CompanySizesGen extends Entities<CompanySize> { 
 
  CompanySizesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CompanySizes newEntities() => CompanySizes(concept); 
  CompanySize newEntity() => CompanySize(concept); 
  
} 
 
