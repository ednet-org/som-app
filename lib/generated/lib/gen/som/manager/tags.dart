part of som_manager; 
 
// lib/gen/som/manager/tags.dart 
 
abstract class TagGen extends Entity<Tag> { 
 
  TagGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get categoryReference => getReference("category") as Reference; 
  void set categoryReference(Reference reference) { setReference("category", reference); } 
  
  Category get category => getParent("category") as Category; 
  void set category(Category p) { setParent("category", p); } 
  
  Reference get tagReference => getReference("tag") as Reference; 
  void set tagReference(Reference reference) { setReference("tag", reference); } 
  
  Category get tag => getParent("tag") as Category; 
  void set tag(Category p) { setParent("tag", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Tag newEntity() => Tag(concept); 
  Tags newEntities() => Tags(concept); 
  
} 
 
abstract class TagsGen extends Entities<Tag> { 
 
  TagsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Tags newEntities() => Tags(concept); 
  Tag newEntity() => Tag(concept); 
  
} 
 
