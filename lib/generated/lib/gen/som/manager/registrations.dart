part of som_manager; 
 
// lib/gen/som/manager/registrations.dart 
 
abstract class RegistrationGen extends Entity<Registration> { 
 
  RegistrationGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get companyReference => getReference("company") as Reference; 
  void set companyReference(Reference reference) { setReference("company", reference); } 
  
  Company get company => getParent("company") as Company; 
  void set company(Company p) { setParent("company", p); } 
  
  String get user => getAttribute("user"); 
  void set user(String a) { setAttribute("user", a); } 
  
  Registration newEntity() => Registration(concept); 
  Registrations newEntities() => Registrations(concept); 
  
} 
 
abstract class RegistrationsGen extends Entities<Registration> { 
 
  RegistrationsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Registrations newEntities() => Registrations(concept); 
  Registration newEntity() => Registration(concept); 
  
} 
 
