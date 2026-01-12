part of som_manager; 
 
// lib/gen/som/manager/buyers.dart 
 
abstract class BuyerGen extends Entity<Buyer> { 
 
  BuyerGen(Concept concept) { 
    this.concept = concept; 
    Concept inquiryConcept = concept.model.concepts.singleWhereCode("Inquiry") as Concept; 
    assert(inquiryConcept != null); 
    setChild("inquiries", Inquiries(inquiryConcept)); 
  } 
 
  Reference get registrationReference => getReference("registration") as Reference; 
  void set registrationReference(Reference reference) { setReference("registration", reference); } 
  
  Registration get registration => getParent("registration") as Registration; 
  void set registration(Registration p) { setParent("registration", p); } 
  
  String get user => getAttribute("user"); 
  void set user(String a) { setAttribute("user", a); } 
  
  Inquiries get inquiries => getChild("inquiries") as Inquiries; 
  
  Buyer newEntity() => Buyer(concept); 
  Buyers newEntities() => Buyers(concept); 
  
} 
 
abstract class BuyersGen extends Entities<Buyer> { 
 
  BuyersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Buyers newEntities() => Buyers(concept); 
  Buyer newEntity() => Buyer(concept); 
  
} 
 
