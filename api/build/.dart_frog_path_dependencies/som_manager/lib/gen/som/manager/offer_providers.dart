part of som_manager;

// lib/gen/som/manager/offer_providers.dart

abstract class OfferProviderGen extends Entity<OfferProvider> {
  OfferProviderGen(Concept concept) {
    this.concept = concept;
    Concept offerConcept =
        concept.model.concepts.singleWhereCode("Offer") as Concept;
    setChild("offers", Offers(offerConcept));
  }

  Reference get registrationReference =>
      getReference("registration") as Reference;
  void set registrationReference(Reference reference) {
    setReference("registration", reference);
  }

  Registration get registration => getParent("registration") as Registration;
  void set registration(Registration p) {
    setParent("registration", p);
  }

  String get company => getAttribute("company");
  void set company(String a) {
    setAttribute("company", a);
  }

  String get user => getAttribute("user");
  void set user(String a) {
    setAttribute("user", a);
  }

  Offers get offers => getChild("offers") as Offers;

  OfferProvider newEntity() => OfferProvider(concept);
  OfferProviders newEntities() => OfferProviders(concept);
}

abstract class OfferProvidersGen extends Entities<OfferProvider> {
  OfferProvidersGen(Concept concept) {
    this.concept = concept;
  }

  OfferProviders newEntities() => OfferProviders(concept);
  OfferProvider newEntity() => OfferProvider(concept);
}
