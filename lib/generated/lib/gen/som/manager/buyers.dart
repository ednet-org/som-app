part of som_manager; 
 
// lib/gen/som/manager/buyers.dart 
 
abstract class BuyerGen extends Entity<Buyer> { 
 
  BuyerGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Buyer newEntity() => Buyer(concept!); 
  Buyers newEntities() => Buyers(concept!); 
  
} 
 
abstract class BuyersGen extends Entities<Buyer> { 
 
  BuyersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Buyers newEntities() => Buyers(concept!); 
  Buyer newEntity() => Buyer(concept!); 
  
} 
 
