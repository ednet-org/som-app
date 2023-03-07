part of som_manager; 
 
// lib/gen/som/manager/platform_roles.dart 
 
abstract class PlatformRoleGen extends Entity<PlatformRole> { 
 
  PlatformRoleGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get companyReference => getReference("company") as Reference; 
  void set companyReference(Reference reference) { setReference("company", reference); } 
  
  Company get company => getParent("company") as Company; 
  void set company(Company p) { setParent("company", p); } 
  
  Reference get platformReference => getReference("platform") as Reference; 
  void set platformReference(Reference reference) { setReference("platform", reference); } 
  
  Platform get platform => getParent("platform") as Platform; 
  void set platform(Platform p) { setParent("platform", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get value => getAttribute("value"); 
  void set value(String a) { setAttribute("value", a); } 
  
  PlatformRole newEntity() => PlatformRole(concept); 
  PlatformRoles newEntities() => PlatformRoles(concept); 
  
} 
 
abstract class PlatformRolesGen extends Entities<PlatformRole> { 
 
  PlatformRolesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  PlatformRoles newEntities() => PlatformRoles(concept); 
  PlatformRole newEntity() => PlatformRole(concept); 
  
} 
 
