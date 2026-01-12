part of som_manager; 
 
// lib/gen/som/manager/provider_criterias.dart 
 
abstract class ProviderCriteriaGen extends Entity<ProviderCriteria> { 
 
  ProviderCriteriaGen(Concept concept) { 
    this.concept = concept; 
    Concept categoryConcept = concept.model.concepts.singleWhereCode("Category") as Concept; 
    assert(categoryConcept != null); 
    setChild("categories", Categories(categoryConcept)); 
  } 
 
  Reference get inquiryReference => getReference("inquiry") as Reference; 
  void set inquiryReference(Reference reference) { setReference("inquiry", reference); } 
  
  Inquiry get inquiry => getParent("inquiry") as Inquiry; 
  void set inquiry(Inquiry p) { setParent("inquiry", p); } 
  
  String get deliveryLocation => getAttribute("deliveryLocation"); 
  void set deliveryLocation(String a) { setAttribute("deliveryLocation", a); } 
  
  int get radius => getAttribute("radius"); 
  void set radius(int a) { setAttribute("radius", a); } 
  
  String get companyType => getAttribute("companyType"); 
  void set companyType(String a) { setAttribute("companyType", a); } 
  
  String get companySize => getAttribute("companySize"); 
  void set companySize(String a) { setAttribute("companySize", a); } 
  
  Categories get categories => getChild("categories") as Categories; 
  
  ProviderCriteria newEntity() => ProviderCriteria(concept); 
  ProviderCriterias newEntities() => ProviderCriterias(concept); 
  
} 
 
abstract class ProviderCriteriasGen extends Entities<ProviderCriteria> { 
 
  ProviderCriteriasGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ProviderCriterias newEntities() => ProviderCriterias(concept); 
  ProviderCriteria newEntity() => ProviderCriteria(concept); 
  
} 
 
