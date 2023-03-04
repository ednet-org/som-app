part of som_manager; 
 
// lib/gen/som/manager/registrations.dart 
 
abstract class RegistrationGen extends Entity<Registration> { 
 
  RegistrationGen(Concept concept) {
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Registration newEntity() => Registration(concept!);
  Registrations newEntities() => Registrations(concept!);
  
} 
 
abstract class RegistrationsGen extends Entities<Registration> { 
 
  RegistrationsGen(Concept concept) {
    this.concept = concept; 
  } 
 
  Registrations newEntities() => Registrations(concept!);
  Registration newEntity() => Registration(concept!);
  
} 
 
