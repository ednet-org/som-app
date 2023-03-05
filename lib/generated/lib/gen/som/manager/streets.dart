part of som_manager; 
 
// lib/gen/som/manager/streets.dart 
 
abstract class StreetGen extends Entity<Street> { 
 
  StreetGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Street newEntity() => Street(concept); 
  Streets newEntities() => Streets(concept); 
  
} 
 
abstract class StreetsGen extends Entities<Street> { 
 
  StreetsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Streets newEntities() => Streets(concept!); 
  Street newEntity() => Street(concept!); 
  
} 
 
