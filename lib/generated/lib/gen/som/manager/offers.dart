part of som_manager; 
 
// lib/gen/som/manager/offers.dart 
 
abstract class OfferGen extends Entity<Offer> { 
 
  OfferGen(Concept concept) { 
    this.concept = concept; 
    Concept? attachmentConcept = concept.model.concepts.singleWhereCode("Attachment"); 
    assert(attachmentConcept!= null); 
    setChild("attachments", Attachments(attachmentConcept!)); 
  } 
 
  Reference get providerReference => getReference("provider") as Reference; 
  void set providerReference(Reference reference) { setReference("provider", reference); } 
  
  Provider get provider => getParent("provider") as Provider; 
  void set provider(Provider p) { setParent("provider", p); } 
  
  Reference get inquiryReference => getReference("inquiry") as Reference; 
  void set inquiryReference(Reference reference) { setReference("inquiry", reference); } 
  
  Inquiry get inquiry => getParent("inquiry") as Inquiry; 
  void set inquiry(Inquiry p) { setParent("inquiry", p); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get deliveryTime => getAttribute("deliveryTime"); 
  void set deliveryTime(String a) { setAttribute("deliveryTime", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  DateTime get expirationDate => getAttribute("expirationDate"); 
  void set expirationDate(DateTime a) { setAttribute("expirationDate", a); } 
  
  double get price => getAttribute("price"); 
  void set price(double a) { setAttribute("price", a); } 
  
  Attachments get attachments => getChild("attachments") as Attachments; 
  
  Offer newEntity() => Offer(concept); 
  Offers newEntities() => Offers(concept); 
  
} 
 
abstract class OffersGen extends Entities<Offer> { 
 
  OffersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Offers newEntities() => Offers(concept); 
  Offer newEntity() => Offer(concept); 
  
} 
 
