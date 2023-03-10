part of som_manager; 
 
// lib/gen/som/manager/companies.dart 
 
abstract class CompanyGen extends Entity<Company> { 
 
  CompanyGen(Concept concept) { 
    this.concept = concept; 
    Concept categoryConcept = concept.model.concepts.singleWhereCode("Category") as Concept; 
    assert(categoryConcept != null); 
    setChild("branches", Categories(categoryConcept)); 
    Concept userConcept = concept.model.concepts.singleWhereCode("User") as Concept; 
    assert(userConcept != null); 
    setChild("employees", Users(userConcept)); 
  } 
 
  Reference get platformRoleReference => getReference("platformRole") as Reference; 
  void set platformRoleReference(Reference reference) { setReference("platformRole", reference); } 
  
  PlatformRole get platformRole => getParent("platformRole") as PlatformRole; 
  void set platformRole(PlatformRole p) { setParent("platformRole", p); } 
  
  Reference get tenantRoleReference => getReference("tenantRole") as Reference; 
  void set tenantRoleReference(Reference reference) { setReference("tenantRole", reference); } 
  
  TenantRole get tenantRole => getParent("tenantRole") as TenantRole; 
  void set tenantRole(TenantRole p) { setParent("tenantRole", p); } 
  
  Reference get platformReference => getReference("platform") as Reference; 
  void set platformReference(Reference reference) { setReference("platform", reference); } 
  
  Platform get platform => getParent("platform") as Platform; 
  void set platform(Platform p) { setParent("platform", p); } 
  
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
  
  Categories get branches => getChild("branches") as Categories; 
  
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
 
