part of som_manager; 
 
// lib/gen/som/manager/consultants.dart 
 
abstract class ConsultantGen extends Entity<Consultant> { 
 
  ConsultantGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get platformReference => getReference("platform") as Reference; 
  void set platformReference(Reference reference) { setReference("platform", reference); } 
  
  Platform get platform => getParent("platform") as Platform; 
  void set platform(Platform p) { setParent("platform", p); } 
  
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
 
