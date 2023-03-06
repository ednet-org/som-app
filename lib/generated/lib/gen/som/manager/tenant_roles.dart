part of som_manager; 
 
// lib/gen/som/manager/tenant_roles.dart 
 
abstract class TenantRoleGen extends Entity<TenantRole> { 
 
  TenantRoleGen(Concept concept) { 
    this.concept = concept; 
    Concept userConcept = concept.model.concepts.singleWhereCode("User") as Concept; 
    assert(userConcept != null); 
    setChild("users", Users(userConcept)); 
    Concept companyConcept = concept.model.concepts.singleWhereCode("Company") as Concept; 
    assert(companyConcept != null); 
    setChild("companies", Companies(companyConcept)); 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get value => getAttribute("value"); 
  void set value(String a) { setAttribute("value", a); } 
  
  Users get users => getChild("users") as Users; 
  
  Companies get companies => getChild("companies") as Companies; 
  
  TenantRole newEntity() => TenantRole(concept); 
  TenantRoles newEntities() => TenantRoles(concept); 
  
} 
 
abstract class TenantRolesGen extends Entities<TenantRole> { 
 
  TenantRolesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  TenantRoles newEntities() => TenantRoles(concept); 
  TenantRole newEntity() => TenantRole(concept); 
  
} 
 
