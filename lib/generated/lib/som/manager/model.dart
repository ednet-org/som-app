part of som_manager;

// lib/som/manager/model.dart

class ManagerModel extends ManagerEntries {
  ManagerModel(Model model) : super(model);

  void fromJsonToCompanyEntry() {
    fromJsonToEntry(somManagerCompanyEntry);
  }

  void fromJsonToBuyerEntry() {
    fromJsonToEntry(somManagerBuyerEntry);
  }

  void fromJsonToOfferEntry() {
    fromJsonToEntry(somManagerOfferEntry);
  }

  void fromJsonToModel() {
    fromJson(somManagerModel);
  }

  void init() {
    initCompanies();
    initBuyers();
    initOffers();
  }

  void initCompanies() {
    var company1 = Company(companies.concept);
    company1.name = 'productivity';
    company1.role = 'advisor';
    company1.address = 'consulting';
    company1.uidNumber = 'software';
    company1.registrationNumber = 'sand';
    company1.numberOfEmployees = 'point';
    company1.websiteUrl = 'beach';
    companies.add(company1);

    var company2 = Company(companies.concept);
    company2.name = 'call';
    company2.role = 'consulting';
    company2.address = 'bank';
    company2.uidNumber = 'slate';
    company2.registrationNumber = 'place';
    company2.numberOfEmployees = 'opinion';
    company2.websiteUrl = 'energy';
    companies.add(company2);

    var company3 = Company(companies.concept);
    company3.name = 'interest';
    company3.role = 'advisor';
    company3.address = 'tree';
    company3.uidNumber = 'end';
    company3.registrationNumber = 'seed';
    company3.numberOfEmployees = 'beans';
    company3.websiteUrl = 'organization';
    companies.add(company3);
  }

  void initBuyers() {
    var buyer1 = Buyer(buyers.concept);
    buyers.add(buyer1);

    var buyer2 = Buyer(buyers.concept);
    buyers.add(buyer2);

    var buyer3 = Buyer(buyers.concept);
    buyers.add(buyer3);
  }

  void initOffers() {
    var offer1 = Offer(offers.concept);
    offer1.description = 'small';
    offer1.deliveryTime = 'offence';
    offer1.status = 'interest';
    offer1.expirationDate = new DateTime.now();
    offer1.price = 7.961957513782025;
    var offer1Inquiry =
        companies.random().employees.random().inquiries.random();
    offer1.inquiry = offer1Inquiry;
    var offer1Provider = companies.random().employees.random().inquiries.random().providerCriteria;
    offer1.provider = offer1Provider;
    offers.add(offer1);
    offer1Inquiry.offers.add(offer1);
    offer1Provider.offers.add(offer1);

    var offer2 = Offer(offers.concept);
    offer2.description = 'enquiry';
    offer2.deliveryTime = 'course';
    offer2.status = 'course';
    offer2.expirationDate = new DateTime.now();
    offer2.price = 51.165193232827754;
    var offer2Inquiry = inquiries.random();
    offer2.inquiry = offer2Inquiry;
    var offer2Provider = providerCriterias.random();
    offer2.provider = offer2Provider;
    offers.add(offer2);
    offer2Inquiry.offers.add(offer2);
    offer2Provider.offers.add(offer2);

    var offer3 = Offer(offers.concept);
    offer3.description = 'heaven';
    offer3.deliveryTime = 'grading';
    offer3.status = 'knowledge';
    offer3.expirationDate = new DateTime.now();
    offer3.price = 67.75645178539538;
    var offer3Inquiry = inquiries.random();
    offer3.inquiry = offer3Inquiry;
    var offer3Provider = providerCriterias.random();
    offer3.provider = offer3Provider;
    offers.add(offer3);
    offer3Inquiry.offers.add(offer3);
    offer3Provider.offers.add(offer3);
  }

// added after code gen - begin

// added after code gen - end
}
