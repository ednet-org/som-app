part of som_manager;

// lib/gen/som/manager/som_providers.dart

abstract class SomProviderGen extends Entity<SomProvider> {
  SomProviderGen(Concept concept) {
    this.concept = concept;
    Concept? offerConcept = concept.model.concepts.singleWhereCode("Offer");
    assert(offerConcept != null);
    setChild("offers", Offers(offerConcept!));
  }

  String get company => getAttribute("company");

  void set company(String a) {
    setAttribute("company", a);
  }

  Offers get offers => getChild("offers") as Offers;

  SomProvider newEntity() => SomProvider(concept);

  SomProviders newEntities() => SomProviders(concept);
}

abstract class SomProvidersGen extends Entities<SomProvider> {
  SomProvidersGen(Concept concept) {
    this.concept = concept;
  }

  SomProviders newEntities() => SomProviders(concept);

  SomProvider newEntity() => SomProvider(concept);
}
