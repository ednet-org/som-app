part of som_manager; 
 
// lib/gen/som/manager/companies.dart 
 
abstract class CompanyGen extends Entity<Company> { 
 
  CompanyGen(Concept concept) { 
    this.concept = concept; 
    Concept? categoryConcept = concept.model.concepts.singleWhereCode("Category"); 
    assert(categoryConcept!= null); 
    setChild("categories", Categories(categoryConcept!)); 
    Concept? userConcept = concept.model.concepts.singleWhereCode("User"); 
    assert(userConcept!= null); 
    setChild("employees", Users(userConcept!)); 
  } 
 
  Reference get categoriesReference => getReference("categories") as Reference; 
  void set categoriesReference(Reference reference) { setReference("categories", reference); } 
  
  Category get categories => getParent("categories") as Category; 
  void set categories(Category p) { setParent("categories", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get role => getAttribute("role"); 
  void set role(String a) { setAttribute("role", a); } 
  
  String get address => getAttribute("address"); 
  void set address(String a) { setAttribute("address", a); } 
  
  String get uidNumber => getAttribute("uidNumber"); 
  void set uidNumber(String a) { setAttribute("uidNumber", a); } 
  
  String get registrationNumber => getAttribute("registrationNumber"); 
  void set registrationNumber(String a) { setAttribute("registrationNumber", a); } 
  
  String get numberOfEmployees => getAttribute("numberOfEmployees"); 
  void set numberOfEmployees(String a) { setAttribute("numberOfEmployees", a); } 
  
  String get websiteUrl => getAttribute("websiteUrl"); 
  void set websiteUrl(String a) { setAttribute("websiteUrl", a); } 
  
  Categories get categories => getChild("categories") as Categories; 
  
  Users get employees => getChild("employees") as Users; 
  
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
 
