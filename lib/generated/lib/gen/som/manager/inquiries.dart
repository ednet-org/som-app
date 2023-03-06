part of som_manager; 
 
// lib/gen/som/manager/inquiries.dart 
 
abstract class InquiryGen extends Entity<Inquiry> { 
 
  InquiryGen(Concept concept) { 
    this.concept = concept; 
    Concept providerCriteriaConcept = concept.model.concepts.singleWhereCode("ProviderCriteria") as Concept; 
    assert(providerCriteriaConcept != null); 
    setChild("providerCriteria", ProviderCriterias(providerCriteriaConcept)); 
    Concept offerConcept = concept.model.concepts.singleWhereCode("Offer") as Concept; 
    assert(offerConcept != null); 
    setChild("offers", Offers(offerConcept)); 
    Concept inquiryStatusConcept = concept.model.concepts.singleWhereCode("InquiryStatus") as Concept; 
    assert(inquiryStatusConcept != null); 
    setChild("status", InquiryStatuss(inquiryStatusConcept)); 
  } 
 
  Reference get buyerReference => getReference("buyer") as Reference; 
  void set buyerReference(Reference reference) { setReference("buyer", reference); } 
  
  Buyer get buyer => getParent("buyer") as Buyer; 
  void set buyer(Buyer p) { setParent("buyer", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get category => getAttribute("category"); 
  void set category(String a) { setAttribute("category", a); } 
  
  String get branch => getAttribute("branch"); 
  void set branch(String a) { setAttribute("branch", a); } 
  
  DateTime get publishingDate => getAttribute("publishingDate"); 
  void set publishingDate(DateTime a) { setAttribute("publishingDate", a); } 
  
  DateTime get expirationDate => getAttribute("expirationDate"); 
  void set expirationDate(DateTime a) { setAttribute("expirationDate", a); } 
  
  String get deliveryLocation => getAttribute("deliveryLocation"); 
  void set deliveryLocation(String a) { setAttribute("deliveryLocation", a); } 
  
  String get attachments => getAttribute("attachments"); 
  void set attachments(String a) { setAttribute("attachments", a); } 
  
  ProviderCriterias get providerCriteria => getChild("providerCriteria") as ProviderCriterias; 
  
  Offers get offers => getChild("offers") as Offers; 
  
  InquiryStatuss get status => getChild("status") as InquiryStatuss; 
  
  Inquiry newEntity() => Inquiry(concept); 
  Inquiries newEntities() => Inquiries(concept); 
  
} 
 
abstract class InquiriesGen extends Entities<Inquiry> { 
 
  InquiriesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Inquiries newEntities() => Inquiries(concept); 
  Inquiry newEntity() => Inquiry(concept); 
  
} 
 
