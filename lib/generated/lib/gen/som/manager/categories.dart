part of som_manager; 
 
// lib/gen/som/manager/categories.dart 
 
abstract class CategoryGen extends Entity<Category> { 
 
  CategoryGen(Concept concept) { 
    this.concept = concept; 
    Concept? tagConcept = concept.model.concepts.singleWhereCode("Tag"); 
    assert(tagConcept!= null); 
    setChild("tag", Tags(tagConcept!)); 
    setChild("category", Tags(tagConcept));
  } 
 
  Reference get companiesReference => getReference("companies") as Reference; 
  void set companiesReference(Reference reference) { setReference("companies", reference); } 
  
  Company get companies => getParent("companies") as Company; 
  void set companies(Company p) { setParent("companies", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Tags get tag => getChild("tag") as Tags; 
  
  Tags get category => getChild("category") as Tags; 
  
  Category newEntity() => Category(concept); 
  Categories newEntities() => Categories(concept); 
  
} 
 
abstract class CategoriesGen extends Entities<Category> { 
 
  CategoriesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Categories newEntities() => Categories(concept);
  Category newEntity() => Category(concept);
  
} 
 
