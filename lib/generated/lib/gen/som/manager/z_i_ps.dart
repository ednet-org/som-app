part of som_manager; 
 
// lib/gen/som/manager/z_i_ps.dart 
 
abstract class ZIPGen extends Entity<ZIP> { 
 
  ZIPGen(Concept concept) {
    this.concept = concept; 
  } 
 
  ZIP newEntity() => ZIP(concept!);
  ZIPs newEntities() => ZIPs(concept!);
  
} 
 
abstract class ZIPsGen extends Entities<ZIP> { 
 
  ZIPsGen(Concept concept) {
    this.concept = concept; 
  } 
 
  ZIPs newEntities() => ZIPs(concept!);
  ZIP newEntity() => ZIP(concept!);
  
} 
 
