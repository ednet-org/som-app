part of som_manager;

// lib/som/manager/model.dart

class ManagerModel extends ManagerEntries {
  ManagerModel(Model model) : super(model);

  void fromJsonToProviderEntry() {
    fromJsonToEntry(somManagerProviderEntry);
  }

  void fromJsonToInquiryEntry() {
    fromJsonToEntry(somManagerInquiryEntry);
  }

  void fromJsonToCompanyEntry() {
    fromJsonToEntry(somManagerCompanyEntry);
  }

  void fromJsonToUserEntry() {
    fromJsonToEntry(somManagerUserEntry);
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
    initProviders();
    initBuyers();
    initInquiries();
    initUsers();
    initOffers();
  }

  void initProviders() {
    var provider1 = Provider(providers.concept);
    provider1.company = 'city';
    providers.add(provider1);

    var provider2 = Provider(providers.concept);
    provider2.company = 'call';
    providers.add(provider2);

    var provider3 = Provider(providers.concept);
    provider3.company = 'interest';
    providers.add(provider3);
  }

  void initInquiries() {
    var inquiry1 = Inquiry(inquiries.concept);
    inquiry1.title = 'body';
    inquiry1.description = 'home';
    inquiry1.category = 'training';
    inquiry1.branch = 'measuremewnt';
    inquiry1.publishingDate = new DateTime.now();
    inquiry1.expirationDate = new DateTime.now();
    inquiry1.deliveryLocation = 'knowledge';
    inquiry1.providerCriteria = 'up';
    inquiry1.status = 'dog';
    var inquiry1Buyer = users.random();
    inquiry1.buyer = inquiry1Buyer;
    inquiries.add(inquiry1);
    inquiry1Buyer.inquiries.add(inquiry1);

    var inquiry2 = Inquiry(inquiries.concept);
    inquiry2.title = 'body';
    inquiry2.description = 'test';
    inquiry2.category = 'vessel';
    inquiry2.branch = 'sin';
    inquiry2.publishingDate = new DateTime.now();
    inquiry2.expirationDate = new DateTime.now();
    inquiry2.deliveryLocation = 'circle';
    inquiry2.providerCriteria = 'heaven';
    inquiry2.status = 'umbrella';
    var inquiry2Buyer = users.random();
    inquiry2.buyer = inquiry2Buyer;
    inquiries.add(inquiry2);
    inquiry2Buyer.inquiries.add(inquiry2);

    var inquiry3 = Inquiry(inquiries.concept);
    inquiry3.title = 'corner';
    inquiry3.description = 'hall';
    inquiry3.category = 'output';
    inquiry3.branch = 'money';
    inquiry3.publishingDate = new DateTime.now();
    inquiry3.expirationDate = new DateTime.now();
    inquiry3.deliveryLocation = 'observation';
    inquiry3.providerCriteria = 'wheat';
    inquiry3.status = 'month';
    var inquiry3Buyer = users.random();
    inquiry3.buyer = inquiry3Buyer;
    inquiries.add(inquiry3);
    inquiry3Buyer.inquiries.add(inquiry3);
  }

  void initCompanies() {
    var company1 = Company(companies.concept);
    company1.name = 'house';
    company1.role = 'letter';
    company1.address = 'line';
    company1.uidNumber = 'message';
    company1.registrationNumber = 'children';
    company1.numberOfEmployees = 'fascination';
    company1.websiteUrl = 'family';
    companies.add(company1);

    var company2 = Company(companies.concept);
    company2.name = 'capacity';
    company2.role = 'point';
    company2.address = 'bank';
    company2.uidNumber = 'ball';
    company2.registrationNumber = 'tape';
    company2.numberOfEmployees = 'parfem';
    company2.websiteUrl = 'school';
    companies.add(company2);

    var company3 = Company(companies.concept);
    company3.name = 'baby';
    company3.role = 'understanding';
    company3.address = 'cash';
    company3.uidNumber = 'present';
    company3.registrationNumber = 'plate';
    company3.numberOfEmployees = 'professor';
    company3.websiteUrl = 'security';
    companies.add(company3);
  }

  void initUsers() {
    var user1 = User(users.concept);
    user1.username = 'cloud';
    user1.roleAtSom = 'plaho';
    user1.roleAtCompany = 'beach';
    var user1Company = companies.random();
    user1.company = user1Company;
    users.add(user1);
    user1Company.employees.add(user1);

    var user2 = User(users.concept);
    user2.username = 'beginning';
    user2.roleAtSom = 'girl';
    user2.roleAtCompany = 'office';
    var user2Company = companies.random();
    user2.company = user2Company;
    users.add(user2);
    user2Company.employees.add(user2);

    var user3 = User(users.concept);
    user3.username = 'redo';
    user3.roleAtSom = 'price';
    user3.roleAtCompany = 'highway';
    var user3Company = companies.random();
    user3.company = user3Company;
    users.add(user3);
    user3Company.employees.add(user3);
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
    offer1.description = 'salad';
    offer1.deliveryTime = 'wave';
    offer1.status = 'yellow';
    offer1.expirationDate = new DateTime.now();
    offer1.price = 23.714070149551127;
    var offer1Provider = providers.random();
    offer1.provider = offer1Provider;
    var offer1Inquiry = inquiries.random();
    offer1.inquiry = offer1Inquiry;
    offers.add(offer1);
    offer1Provider.offers.add(offer1);
    offer1Inquiry.offers.add(offer1);

    var offer2 = Offer(offers.concept);
    offer2.description = 'video';
    offer2.deliveryTime = 'brad';
    offer2.status = 'baby';
    offer2.expirationDate = new DateTime.now();
    offer2.price = 22.666423913441168;
    var offer2Provider = providers.random();
    offer2.provider = offer2Provider;
    var offer2Inquiry = inquiries.random();
    offer2.inquiry = offer2Inquiry;
    offers.add(offer2);
    offer2Provider.offers.add(offer2);
    offer2Inquiry.offers.add(offer2);

    var offer3 = Offer(offers.concept);
    offer3.description = 'highway';
    offer3.deliveryTime = 'wife';
    offer3.status = 'judge';
    offer3.expirationDate = new DateTime.now();
    offer3.price = 22.00698277703641;
    var offer3Provider = providers.random();
    offer3.provider = offer3Provider;
    var offer3Inquiry = inquiries.random();
    offer3.inquiry = offer3Inquiry;
    offers.add(offer3);
    offer3Provider.offers.add(offer3);
    offer3Inquiry.offers.add(offer3);
  }

// added after code gen - begin

// added after code gen - end
}
