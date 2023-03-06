part of som_manager; 
 
// lib/gen/som/manager/addresss.dart 
 
abstract class AddressGen extends Entity<Address> { 
 
  AddressGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get countryReference => getReference("country") as Reference; 
  void set countryReference(Reference reference) { setReference("country", reference); } 
  
  Country get country => getParent("country") as Country; 
  void set country(Country p) { setParent("country", p); } 
  
  String get city => getAttribute("city"); 
  void set city(String a) { setAttribute("city", a); } 
  
  String get street => getAttribute("street"); 
  void set street(String a) { setAttribute("street", a); } 
  
  String get number => getAttribute("number"); 
  void set number(String a) { setAttribute("number", a); } 
  
  String get zip => getAttribute("zip"); 
  void set zip(String a) { setAttribute("zip", a); } 
  
  Address newEntity() => Address(concept); 
  Addresss newEntities() => Addresss(concept); 
  
} 
 
abstract class AddresssGen extends Entities<Address> { 
 
  AddresssGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Addresss newEntities() => Addresss(concept); 
  Address newEntity() => Address(concept); 
  
} 
 
