part of som_manager; 
 
// lib/gen/som/manager/emails.dart 
 
abstract class EmailGen extends Entity<Email> { 
 
  EmailGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get ownerReference => getReference("owner") as Reference; 
  void set ownerReference(Reference reference) { setReference("owner", reference); } 
  
  User get owner => getParent("owner") as User; 
  void set owner(User p) { setParent("owner", p); } 
  
  String get value => getAttribute("value"); 
  void set value(String a) { setAttribute("value", a); } 
  
  Email newEntity() => Email(concept); 
  Emails newEntities() => Emails(concept); 
  
} 
 
abstract class EmailsGen extends Entities<Email> { 
 
  EmailsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Emails newEntities() => Emails(concept); 
  Email newEntity() => Email(concept); 
  
} 
 
