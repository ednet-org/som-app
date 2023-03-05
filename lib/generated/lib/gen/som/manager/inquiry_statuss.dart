part of som_manager; 
 
// lib/gen/som/manager/inquiry_statuss.dart 
 
abstract class InquiryStatusGen extends Entity<InquiryStatus> { 
 
  InquiryStatusGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  InquiryStatus newEntity() => InquiryStatus(concept); 
  InquiryStatuss newEntities() => InquiryStatuss(concept); 
  
} 
 
abstract class InquiryStatussGen extends Entities<InquiryStatus> { 
 
  InquiryStatussGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  InquiryStatuss newEntities() => InquiryStatuss(concept);
  InquiryStatus newEntity() => InquiryStatus(concept);
  
} 
 
