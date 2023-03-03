part of som_manager; 
 
// lib/gen/som/manager/users.dart 
 
abstract class UserGen extends Entity<User> { 
 
  UserGen(Concept concept) { 
    this.concept = concept; 
    Concept? inquiryConcept = concept.model.concepts.singleWhereCode("Inquiry"); 
    assert(inquiryConcept!= null); 
    setChild("inquiries", Inquiries(inquiryConcept!)); 
    Concept? phoneNumberConcept = concept.model.concepts.singleWhereCode("PhoneNumber"); 
    assert(phoneNumberConcept!= null); 
    setChild("phoneNumber", PhoneNumbers(phoneNumberConcept!)); 
    Concept? emailConcept = concept.model.concepts.singleWhereCode("Email"); 
    assert(emailConcept!= null); 
    setChild("email", Emails(emailConcept!)); 
  } 
 
  Reference get companyReference => getReference("company") as Reference; 
  void set companyReference(Reference reference) { setReference("company", reference); } 
  
  Company get company => getParent("company") as Company; 
  void set company(Company p) { setParent("company", p); } 
  
  Reference get companyReference => getReference("company") as Reference; 
  void set companyReference(Reference reference) { setReference("company", reference); } 
  
  Company get company => getParent("company") as Company; 
  void set company(Company p) { setParent("company", p); } 
  
  String get id => getAttribute("id"); 
  void set id(String a) { setAttribute("id", a); } 
  
  String get username => getAttribute("username"); 
  void set username(String a) { setAttribute("username", a); } 
  
  String get company => getAttribute("company"); 
  void set company(String a) { setAttribute("company", a); } 
  
  String get roleAtSom => getAttribute("roleAtSom"); 
  void set roleAtSom(String a) { setAttribute("roleAtSom", a); } 
  
  String get roleAtCompany => getAttribute("roleAtCompany"); 
  void set roleAtCompany(String a) { setAttribute("roleAtCompany", a); } 
  
  String get phoneNumber => getAttribute("phoneNumber"); 
  void set phoneNumber(String a) { setAttribute("phoneNumber", a); } 
  
  String get email => getAttribute("email"); 
  void set email(String a) { setAttribute("email", a); } 
  
  Inquiries get inquiries => getChild("inquiries") as Inquiries; 
  
  PhoneNumbers get phoneNumber => getChild("phoneNumber") as PhoneNumbers; 
  
  Emails get email => getChild("email") as Emails; 
  
  User newEntity() => User(concept); 
  Users newEntities() => Users(concept); 
  
} 
 
abstract class UsersGen extends Entities<User> { 
 
  UsersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Users newEntities() => Users(concept); 
  User newEntity() => User(concept); 
  
} 
 
