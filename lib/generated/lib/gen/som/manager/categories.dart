part of som_manager; 
 
// lib/gen/som/manager/categories.dart 
 
abstract class CategoryGen extends Entity<Category> { 
 
  CategoryGen(Concept concept) { 
    this.concept = concept; 
    Concept categoryConcept = concept.model.concepts.singleWhereCode("Category") as Concept; 
    assert(categoryConcept != null); 
    setChild("tags", Categories(categoryConcept)); 
    setChild("categories", Categories(categoryConcept)); 
  } 
 
  Reference get categoryReference => getReference("category") as Reference; 
  void set categoryReference(Reference reference) { setReference("category", reference); } 
  
  Category get category => getParent("category") as Category; 
  void set category(Category p) { setParent("category", p); } 
  
  Reference get tagReference => getReference("tag") as Reference; 
  void set tagReference(Reference reference) { setReference("tag", reference); } 
  
  Category get tag => getParent("tag") as Category; 
  void set tag(Category p) { setParent("tag", p); } 
  
  Reference get companiesReference => getReference("companies") as Reference; 
  void set companiesReference(Reference reference) { setReference("companies", reference); } 
  
  Company get companies => getParent("companies") as Company; 
  void set companies(Company p) { setParent("companies", p); } 
  
  Reference get inquiriesReference => getReference("inquiries") as Reference; 
  void set inquiriesReference(Reference reference) { setReference("inquiries", reference); } 
  
  ProviderCriteria get inquiries => getParent("inquiries") as ProviderCriteria; 
  void set inquiries(ProviderCriteria p) { setParent("inquiries", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Categories get tags => getChild("tags") as Categories; 
  
  Categories get categories => getChild("categories") as Categories; 
  
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
 
