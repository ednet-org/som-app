part of som_manager; 
 
// lib/gen/som/manager/attachments.dart 
 
abstract class AttachmentGen extends Entity<Attachment> { 
 
  AttachmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get offerReference => getReference("offer") as Reference; 
  void set offerReference(Reference reference) { setReference("offer", reference); } 
  
  Offer get offer => getParent("offer") as Offer; 
  void set offer(Offer p) { setParent("offer", p); } 
  
  Reference get inquiryReference => getReference("inquiry") as Reference; 
  void set inquiryReference(Reference reference) { setReference("inquiry", reference); } 
  
  Inquiry get inquiry => getParent("inquiry") as Inquiry; 
  void set inquiry(Inquiry p) { setParent("inquiry", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  String get data => getAttribute("data"); 
  void set data(String a) { setAttribute("data", a); } 
  
  String get belongsTo => getAttribute("belongsTo"); 
  void set belongsTo(String a) { setAttribute("belongsTo", a); } 
  
  Attachment newEntity() => Attachment(concept); 
  Attachments newEntities() => Attachments(concept); 
  
} 
 
abstract class AttachmentsGen extends Entities<Attachment> { 
 
  AttachmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Attachments newEntities() => Attachments(concept);
  Attachment newEntity() => Attachment(concept);
  
} 
 
