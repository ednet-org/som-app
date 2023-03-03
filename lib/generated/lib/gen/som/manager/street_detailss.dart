part of som_manager; 
 
// lib/gen/som/manager/street_detailss.dart 
 
abstract class StreetDetailsGen extends Entity<StreetDetails> { 
 
  StreetDetailsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  StreetDetails newEntity() => StreetDetails(concept); 
  StreetDetailss newEntities() => StreetDetailss(concept); 
  
} 
 
abstract class StreetDetailssGen extends Entities<StreetDetails> { 
 
  StreetDetailssGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  StreetDetailss newEntities() => StreetDetailss(concept); 
  StreetDetails newEntity() => StreetDetails(concept); 
  
} 
 
