part of som_manager; 
 
// lib/gen/som/manager/countries.dart 
 
abstract class CountryGen extends Entity<Country> { 
 
  CountryGen(Concept concept) { 
    this.concept = concept; 
    Concept? addressConcept = concept.model.concepts.singleWhereCode("Address"); 
    assert(addressConcept!= null); 
    setChild("address", Addresss(addressConcept!)); 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Addresss get address => getChild("address") as Addresss; 
  
  Country newEntity() => Country(concept); 
  Countries newEntities() => Countries(concept); 
  
} 
 
abstract class CountriesGen extends Entities<Country> { 
 
  CountriesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Countries newEntities() => Countries(concept); 
  Country newEntity() => Country(concept); 
  
} 
 
