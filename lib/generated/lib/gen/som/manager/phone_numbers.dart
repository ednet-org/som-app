part of som_manager; 
 
// lib/gen/som/manager/phone_numbers.dart 
 
abstract class PhoneNumberGen extends Entity<PhoneNumber> { 
 
  PhoneNumberGen(Concept concept) {
    this.concept = concept; 
  } 
 
  Reference get ownerReference => getReference("owner") as Reference; 
  void set ownerReference(Reference reference) { setReference("owner", reference); } 
  
  User get owner => getParent("owner") as User; 
  void set owner(User p) { setParent("owner", p); } 
  
  String get number => getAttribute("number"); 
  void set number(String a) { setAttribute("number", a); } 
  
  PhoneNumber newEntity() => PhoneNumber(concept!);
  PhoneNumbers newEntities() => PhoneNumbers(concept!);
  
} 
 
abstract class PhoneNumbersGen extends Entities<PhoneNumber> { 
 
  PhoneNumbersGen(Concept concept) {
    this.concept = concept; 
  } 
 
  PhoneNumbers newEntities() => PhoneNumbers(concept!);
  PhoneNumber newEntity() => PhoneNumber(concept!);
  
} 
 
