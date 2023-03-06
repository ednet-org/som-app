part of som_manager; 
 
// lib/gen/som/manager/registrations.dart 
 
abstract class RegistrationGen extends Entity<Registration> { 
 
  RegistrationGen(Concept concept) { 
    this.concept = concept; 
    Concept offerProviderConcept = concept.model.concepts.singleWhereCode("OfferProvider") as Concept; 
    assert(offerProviderConcept != null); 
    setChild("provider", OfferProviders(offerProviderConcept)); 
    Concept buyerConcept = concept.model.concepts.singleWhereCode("Buyer") as Concept; 
    assert(buyerConcept != null); 
    setChild("buyer", Buyers(buyerConcept)); 
  } 
 
  String get company => getAttribute("company"); 
  void set company(String a) { setAttribute("company", a); } 
  
  String get user => getAttribute("user"); 
  void set user(String a) { setAttribute("user", a); } 
  
  String get platformRole => getAttribute("platformRole"); 
  void set platformRole(String a) { setAttribute("platformRole", a); } 
  
  OfferProviders get provider => getChild("provider") as OfferProviders; 
  
  Buyers get buyer => getChild("buyer") as Buyers; 
  
  Registration newEntity() => Registration(concept); 
  Registrations newEntities() => Registrations(concept); 
  
} 
 
abstract class RegistrationsGen extends Entities<Registration> { 
 
  RegistrationsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Registrations newEntities() => Registrations(concept); 
  Registration newEntity() => Registration(concept); 
  
} 
 
