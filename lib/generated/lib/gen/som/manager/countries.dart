part of som_manager; 
 
// lib/gen/som/manager/countries.dart 
 
abstract class CountryGen extends Entity<Country> { 
 
  CountryGen(Concept concept) { 
    this.concept = concept; 
    Concept addressConcept = concept.model.concepts.singleWhereCode("Address") as Concept; 
    assert(addressConcept != null); 
    setChild("addresses", Addresss(addressConcept)); 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get countryCode => getAttribute("countryCode"); 
  void set countryCode(String a) { setAttribute("countryCode", a); } 
  
  Addresss get addresses => getChild("addresses") as Addresss; 
  
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
 
