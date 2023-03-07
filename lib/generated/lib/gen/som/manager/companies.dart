part of som_manager; 
 
// lib/gen/som/manager/companies.dart 
 
abstract class CompanyGen extends Entity<Company> { 
 
  CompanyGen(Concept concept) { 
    this.concept = concept; 
    Concept registrationConcept = concept.model.concepts.singleWhereCode("Registration") as Concept; 
    assert(registrationConcept != null); 
    setChild("registration", Registrations(registrationConcept)); 
    Concept userConcept = concept.model.concepts.singleWhereCode("User") as Concept; 
    assert(userConcept != null); 
    setChild("employees", Users(userConcept)); 
    Concept platformRoleConcept = concept.model.concepts.singleWhereCode("PlatformRole") as Concept; 
    assert(platformRoleConcept != null); 
    setChild("platformRoles", PlatformRoles(platformRoleConcept)); 
    Concept categoryConcept = concept.model.concepts.singleWhereCode("Category") as Concept; 
    assert(categoryConcept != null); 
    setChild("branches", Categories(categoryConcept)); 
  } 
 
  Reference get tenantRoleReference => getReference("tenantRole") as Reference; 
  void set tenantRoleReference(Reference reference) { setReference("tenantRole", reference); } 
  
  TenantRole get tenantRole => getParent("tenantRole") as TenantRole; 
  void set tenantRole(TenantRole p) { setParent("tenantRole", p); } 
  
  Reference get platformReference => getReference("platform") as Reference; 
  void set platformReference(Reference reference) { setReference("platform", reference); } 
  
  Platform get platform => getParent("platform") as Platform; 
  void set platform(Platform p) { setParent("platform", p); } 
  
  Reference get typeReference => getReference("type") as Reference; 
  void set typeReference(Reference reference) { setReference("type", reference); } 
  
  CompanyType get type => getParent("type") as CompanyType; 
  void set type(CompanyType p) { setParent("type", p); } 
  
  Reference get sizeReference => getReference("size") as Reference; 
  void set sizeReference(Reference reference) { setReference("size", reference); } 
  
  CompanySize get size => getParent("size") as CompanySize; 
  void set size(CompanySize p) { setParent("size", p); } 
  
  Reference get addressReference => getReference("address") as Reference; 
  void set addressReference(Reference reference) { setReference("address", reference); } 
  
  Address get address => getParent("address") as Address; 
  void set address(Address p) { setParent("address", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get uidNumber => getAttribute("uidNumber"); 
  void set uidNumber(String a) { setAttribute("uidNumber", a); } 
  
  String get registrationNumber => getAttribute("registrationNumber"); 
  void set registrationNumber(String a) { setAttribute("registrationNumber", a); } 
  
  String get numberOfEmployees => getAttribute("numberOfEmployees"); 
  void set numberOfEmployees(String a) { setAttribute("numberOfEmployees", a); } 
  
  String get websiteUrl => getAttribute("websiteUrl"); 
  void set websiteUrl(String a) { setAttribute("websiteUrl", a); } 
  
  Registrations get registration => getChild("registration") as Registrations; 
  
  Users get employees => getChild("employees") as Users; 
  
  PlatformRoles get platformRoles => getChild("platformRoles") as PlatformRoles; 
  
  Categories get branches => getChild("branches") as Categories; 
  
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
 
