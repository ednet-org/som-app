part of som_manager; 
 
// lib/gen/som/manager/inquiries.dart 
 
abstract class InquiryGen extends Entity<Inquiry> { 
 
  InquiryGen(Concept concept) { 
    this.concept = concept; 
    Concept? providerCriteriaConcept = concept.model.concepts.singleWhereCode("ProviderCriteria"); 
    assert(providerCriteriaConcept!= null); 
    setChild("inquiry", ProviderCriterias(providerCriteriaConcept!)); 
    Concept? attachmentConcept = concept.model.concepts.singleWhereCode("Attachment"); 
    assert(attachmentConcept!= null); 
    setChild("attachments", Attachments(attachmentConcept!)); 
    Concept? offerConcept = concept.model.concepts.singleWhereCode("Offer"); 
    assert(offerConcept!= null); 
    setChild("offers", Offers(offerConcept!)); 
  } 
 
  Reference get buyerReference => getReference("buyer") as Reference; 
  void set buyerReference(Reference reference) { setReference("buyer", reference); } 
  
  User get buyer => getParent("buyer") as User; 
  void set buyer(User p) { setParent("buyer", p); } 
  
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
  
  String get providerCriteria => getAttribute("providerCriteria"); 
  void set providerCriteria(String a) { setAttribute("providerCriteria", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  ProviderCriterias get inquiry => getChild("inquiry") as ProviderCriterias; 
  
  Attachments get attachments => getChild("attachments") as Attachments; 
  
  Offers get offers => getChild("offers") as Offers; 
  
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
 
