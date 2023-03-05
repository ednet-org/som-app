part of som_manager; 
 
// lib/gen/som/manager/providers.dart 
 
abstract class ProviderGen extends Entity<Provider> { 
 
  ProviderGen(Concept concept) { 
    this.concept = concept; 
    Concept? offerConcept = concept.model.concepts.singleWhereCode("Offer"); 
    assert(offerConcept!= null); 
    setChild("offers", Offers(offerConcept!)); 
  } 
 
  String get company => getAttribute("company"); 
  void set company(String a) { setAttribute("company", a); } 
  
  Offers get offers => getChild("offers") as Offers; 
  
  Provider newEntity() => Provider(concept); 
  Providers newEntities() => Providers(concept); 
  
} 
 
abstract class ProvidersGen extends Entities<Provider> { 
 
  ProvidersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Providers newEntities() => Providers(concept!); 
  Provider newEntity() => Provider(concept!); 
  
} 
 
