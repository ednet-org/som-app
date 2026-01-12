import 'package:ednet_core/ednet_core.dart';

class SomDomainModel {
  SomDomainModel() {
    final domain = Domain('Som');
    model = Model(domain, 'SomModel');
    companyConcept = Concept(model, 'Company')
      ..entry = true
      ..description = 'Company aggregate';
    _addAttribute(companyConcept, 'name', required: true);
    _addAttribute(companyConcept, 'address', required: true);
    _addAttribute(companyConcept, 'uidNr', required: true);
    _addAttribute(companyConcept, 'registrationNr', required: true);
    _addAttribute(companyConcept, 'companySize', required: true);
    _addAttribute(companyConcept, 'type', required: true);
    _addAttribute(companyConcept, 'websiteUrl');

    userConcept = Concept(model, 'User')
      ..entry = true
      ..description = 'User aggregate';
    _addAttribute(userConcept, 'email', required: true);
    _addAttribute(userConcept, 'firstName', required: true);
    _addAttribute(userConcept, 'lastName', required: true);
    _addAttribute(userConcept, 'salutation', required: true);
    _addAttribute(userConcept, 'roles', required: true);

    inquiryConcept = Concept(model, 'Inquiry')
      ..entry = true
      ..description = 'Inquiry aggregate';
    _addAttribute(inquiryConcept, 'branchId', required: true);
    _addAttribute(inquiryConcept, 'categoryId', required: true);
    _addAttribute(inquiryConcept, 'deadline', required: true);
    _addAttribute(inquiryConcept, 'deliveryZips', required: true);
    _addAttribute(inquiryConcept, 'numberOfProviders', required: true);

    offerConcept = Concept(model, 'Offer')
      ..entry = true
      ..description = 'Offer aggregate';
    _addAttribute(offerConcept, 'inquiryId', required: true);
    _addAttribute(offerConcept, 'providerCompanyId', required: true);

    adConcept = Concept(model, 'Ad')
      ..entry = true
      ..description = 'Ad aggregate';
    _addAttribute(adConcept, 'branchId', required: true);
    _addAttribute(adConcept, 'url', required: true);
    _addAttribute(adConcept, 'type', required: true);
  }

  late final Model model;
  late final Concept companyConcept;
  late final Concept userConcept;
  late final Concept inquiryConcept;
  late final Concept offerConcept;
  late final Concept adConcept;

  SomCompany newCompany() => SomCompany(companyConcept);
  SomUser newUser() => SomUser(userConcept);
  SomInquiry newInquiry() => SomInquiry(inquiryConcept);
  SomOffer newOffer() => SomOffer(offerConcept);
  SomAd newAd() => SomAd(adConcept);

  void _addAttribute(Concept concept, String code, {bool required = false}) {
    final attribute = Attribute(concept, code);
    attribute.required = required;
  }
}

mixin RequiredValidation<E extends Entity<E>> on Entity<E> {
  void validateRequired() {
    for (final attribute in concept.attributes.whereType<Attribute>()) {
      if (attribute.required) {
        final value = getAttribute(attribute.code);
        if (value == null || (value is String && value.trim().isEmpty)) {
          throw EDNetException('Missing required field: ${attribute.code}');
        }
      }
    }
  }
}

class SomCompany extends Entity<SomCompany>
    with RequiredValidation<SomCompany> {
  SomCompany(Concept concept) {
    this.concept = concept;
  }
}

class SomUser extends Entity<SomUser> with RequiredValidation<SomUser> {
  SomUser(Concept concept) {
    this.concept = concept;
  }
}

class SomInquiry extends Entity<SomInquiry>
    with RequiredValidation<SomInquiry> {
  SomInquiry(Concept concept) {
    this.concept = concept;
  }
}

class SomOffer extends Entity<SomOffer> with RequiredValidation<SomOffer> {
  SomOffer(Concept concept) {
    this.concept = concept;
  }
}

class SomAd extends Entity<SomAd> with RequiredValidation<SomAd> {
  SomAd(Concept concept) {
    this.concept = concept;
  }
}
