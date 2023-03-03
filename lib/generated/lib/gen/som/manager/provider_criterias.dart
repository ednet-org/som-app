part of som_manager; 
 
// lib/gen/som/manager/provider_criterias.dart 
 
abstract class ProviderCriteriaGen extends Entity<ProviderCriteria> { 
 
  ProviderCriteriaGen(Concept concept) { 
    this.concept = concept; 
    Concept? offerConcept = concept.model.concepts.singleWhereCode("Offer"); 
    assert(offerConcept!= null); 
    setChild("offers", Offers(offerConcept!)); 
  } 
 
  Reference get providerReference => getReference("provider") as Reference; 
  void set providerReference(Reference reference) { setReference("provider", reference); } 
  
  Inquiry get provider => getParent("provider") as Inquiry; 
  void set provider(Inquiry p) { setParent("provider", p); } 
  
  String get deliveryLocation => getAttribute("deliveryLocation"); 
  void set deliveryLocation(String a) { setAttribute("deliveryLocation", a); } 
  
  int get radius => getAttribute("radius"); 
  void set radius(int a) { setAttribute("radius", a); } 
  
  String get companyType => getAttribute("companyType"); 
  void set companyType(String a) { setAttribute("companyType", a); } 
  
  String get companySize => getAttribute("companySize"); 
  void set companySize(String a) { setAttribute("companySize", a); } 
  
  Offers get offers => getChild("offers") as Offers; 
  
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
 
