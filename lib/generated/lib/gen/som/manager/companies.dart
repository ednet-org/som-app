part of som_manager; 
 
// lib/gen/som/manager/companies.dart 
 
abstract class CompanyGen extends Entity<Company> { 
 
  CompanyGen(Concept concept) { 
    this.concept = concept; 
    Concept? userConcept = concept.model.concepts.singleWhereCode("User"); 
    assert(userConcept!= null); 
    setChild("employees", Users(userConcept!)); 
    setChild("users", Users(userConcept!)); 
  } 
 
  String get id => getAttribute("id"); 
  void set id(String a) { setAttribute("id", a); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get role => getAttribute("role"); 
  void set role(String a) { setAttribute("role", a); } 
  
  String get address => getAttribute("address"); 
  void set address(String a) { setAttribute("address", a); } 
  
  Users get employees => getChild("employees") as Users; 
  
  Users get users => getChild("users") as Users; 
  
  Company newEntity() => Company(concept); 
  Companies newEntities() => Companies(concept); 
  
} 
 
abstract class CompaniesGen extends Entities<Company> { 
 
  CompaniesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Companies newEntities() => Companies(concept); 
  Company newEntity() => Company(concept); 
  
} 
 
