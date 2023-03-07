part of som_manager; 
 
// lib/gen/som/manager/offer_providers.dart 
 
abstract class OfferProviderGen extends Entity<OfferProvider> { 
 
  OfferProviderGen(Concept concept) { 
    this.concept = concept; 
    Concept offerConcept = concept.model.concepts.singleWhereCode("Offer") as Concept; 
    assert(offerConcept != null); 
    setChild("offers", Offers(offerConcept)); 
  } 
 
  String get company => getAttribute("company"); 
  void set company(String a) { setAttribute("company", a); } 
  
  String get user => getAttribute("user"); 
  void set user(String a) { setAttribute("user", a); } 
  
  Offers get offers => getChild("offers") as Offers; 
  
  OfferProvider newEntity() => OfferProvider(concept); 
  OfferProviders newEntities() => OfferProviders(concept); 
  
} 
 
abstract class OfferProvidersGen extends Entities<OfferProvider> { 
 
  OfferProvidersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  OfferProviders newEntities() => OfferProviders(concept); 
  OfferProvider newEntity() => OfferProvider(concept); 
  
} 
 
