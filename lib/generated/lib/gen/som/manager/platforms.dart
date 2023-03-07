part of som_manager; 
 
// lib/gen/som/manager/platforms.dart 
 
abstract class PlatformGen extends Entity<Platform> { 
 
  PlatformGen(Concept concept) { 
    this.concept = concept; 
    Concept companyConcept = concept.model.concepts.singleWhereCode("Company") as Concept; 
    assert(companyConcept != null); 
    setChild("companies", Companies(companyConcept)); 
    Concept platformRoleConcept = concept.model.concepts.singleWhereCode("PlatformRole") as Concept; 
    assert(platformRoleConcept != null); 
    setChild("roles", PlatformRoles(platformRoleConcept)); 
  } 
 
  Companies get companies => getChild("companies") as Companies; 
  
  PlatformRoles get roles => getChild("roles") as PlatformRoles; 
  
  Platform newEntity() => Platform(concept); 
  Platforms newEntities() => Platforms(concept); 
  
} 
 
abstract class PlatformsGen extends Entities<Platform> { 
 
  PlatformsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Platforms newEntities() => Platforms(concept); 
  Platform newEntity() => Platform(concept); 
  
} 
 
