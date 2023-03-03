part of som_manager; 
 
// lib/gen/som/manager/offers.dart 
 
abstract class OfferGen extends Entity<Offer> { 
 
  OfferGen(Concept concept) { 
    this.concept = concept; 
    Concept? attachmentConcept = concept.model.concepts.singleWhereCode("Attachment"); 
    assert(attachmentConcept!= null); 
    setChild("attachments", Attachments(attachmentConcept!)); 
  } 
 
  Reference get inquiryReference => getReference("inquiry") as Reference; 
  void set inquiryReference(Reference reference) { setReference("inquiry", reference); } 
  
  Inquiry get inquiry => getParent("inquiry") as Inquiry; 
  void set inquiry(Inquiry p) { setParent("inquiry", p); } 
  
  Reference get providerReference => getReference("provider") as Reference; 
  void set providerReference(Reference reference) { setReference("provider", reference); } 
  
  ProviderCriteria get provider => getParent("provider") as ProviderCriteria; 
  void set provider(ProviderCriteria p) { setParent("provider", p); } 
  
  String get id => getAttribute("id"); 
  void set id(String a) { setAttribute("id", a); } 
  
  String get inquiry => getAttribute("inquiry"); 
  void set inquiry(String a) { setAttribute("inquiry", a); } 
  
  String get provider => getAttribute("provider"); 
  void set provider(String a) { setAttribute("provider", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get deliveryTime => getAttribute("deliveryTime"); 
  void set deliveryTime(String a) { setAttribute("deliveryTime", a); } 
  
  String get attachments => getAttribute("attachments"); 
  void set attachments(String a) { setAttribute("attachments", a); } 
  
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
 
