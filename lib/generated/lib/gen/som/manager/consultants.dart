part of som_manager; 
 
// lib/gen/som/manager/consultants.dart 
 
abstract class ConsultantGen extends Entity<Consultant> { 
 
  ConsultantGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get user => getAttribute("user"); 
  void set user(String a) { setAttribute("user", a); } 
  
  Consultant newEntity() => Consultant(concept); 
  Consultants newEntities() => Consultants(concept); 
  
} 
 
abstract class ConsultantsGen extends Entities<Consultant> { 
 
  ConsultantsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Consultants newEntities() => Consultants(concept); 
  Consultant newEntity() => Consultant(concept); 
  
} 
 
