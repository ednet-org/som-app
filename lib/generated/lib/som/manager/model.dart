 
part of som_manager; 
 
// lib/som/manager/model.dart 
 
class ManagerModel extends ManagerEntries { 
 
  ManagerModel(Model model) : super(model); 
 
  void fromJsonToOfferEntry() { 
    fromJsonToEntry(somManagerOfferEntry); 
  } 
 
  void fromJsonToUserEntry() { 
    fromJsonToEntry(somManagerUserEntry); 
  } 
 
  void fromJsonToBuyerEntry() { 
    fromJsonToEntry(somManagerBuyerEntry); 
  } 
 
  void fromJsonToProviderEntry() { 
    fromJsonToEntry(somManagerProviderEntry); 
  } 
 
  void fromJsonToInquiryEntry() { 
    fromJsonToEntry(somManagerInquiryEntry); 
  } 
 
  void fromJsonToCompanyEntry() { 
    fromJsonToEntry(somManagerCompanyEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(somManagerModel); 
  } 
 
  void init() { 
    initCompanies(); 
    initProviders(); 
    initBuyers(); 
    initUsers(); 
    initInquiries(); 
    initOffers(); 
  } 
 
  void initOffers() { 
    var offer1 = Offer(offers.concept);
    offer1.description = 'smog'; 
    offer1.deliveryTime = 'message'; 
    offer1.status = 'coffee'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 55.42256188644402; 
    var offer1Provider = providers.random(); 
    offer1.provider = offer1Provider; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept);
    offer2.description = 'health'; 
    offer2.deliveryTime = 'consciousness'; 
    offer2.status = 'security'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 98.41121030126715; 
    var offer2Provider = providers.random(); 
    offer2.provider = offer2Provider; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept);
    offer3.description = 'hat'; 
    offer3.deliveryTime = 'test'; 
    offer3.status = 'country'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 29.011237955745717; 
    var offer3Provider = providers.random(); 
    offer3.provider = offer3Provider; 
    var offer3Inquiry = inquiries.random(); 
    offer3.inquiry = offer3Inquiry; 
    offers.add(offer3); 
    offer3Provider.offers.add(offer3); 
    offer3Inquiry.offers.add(offer3); 
 
  } 
 
  void initUsers() { 
    var user1 = User(users.concept);
    user1.username = 'wheat'; 
    user1.roleAtSom = 'paper'; 
    user1.roleAtCompany = 'void'; 
    var user1Company = companies.random(); 
    user1.company = user1Company; 
    users.add(user1); 
    user1Company.employees.add(user1); 
 
    var user2 = User(users.concept);
    user2.username = 'crisis'; 
    user2.roleAtSom = 'void'; 
    user2.roleAtCompany = 'big'; 
    var user2Company = companies.random(); 
    user2.company = user2Company; 
    users.add(user2); 
    user2Company.employees.add(user2); 
 
    var user3 = User(users.concept);
    user3.username = 'down'; 
    user3.roleAtSom = 'center'; 
    user3.roleAtCompany = 'family'; 
    var user3Company = companies.random(); 
    user3.company = user3Company; 
    users.add(user3); 
    user3Company.employees.add(user3);

    users.exceptions.display();
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept);
    buyers.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept);
    buyers.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept);
    buyers.add(buyer3); 
 
  } 
 
  void initProviders() { 
    var provider1 = Provider(providers.concept);
    provider1.company = 'car'; 
    providers.add(provider1); 
 
    var provider2 = Provider(providers.concept);
    provider2.company = 'letter'; 
    providers.add(provider2); 
 
    var provider3 = Provider(providers.concept);
    provider3.company = 'music'; 
    providers.add(provider3); 
 
  } 
 
  void initInquiries() { 
    var inquiry1 = Inquiry(inquiries.concept);
    inquiry1.title = 'horse'; 
    inquiry1.description = 'thing'; 
    inquiry1.category = 'dog'; 
    inquiry1.branch = 'brad'; 
    inquiry1.publishingDate = new DateTime.now(); 
    inquiry1.expirationDate = new DateTime.now(); 
    inquiry1.deliveryLocation = 'vacation'; 
    inquiry1.providerCriteria = 'navigation'; 
    inquiry1.status = 'sun'; 
    var inquiry1Buyer = users.random(); 
    inquiry1.buyer = inquiry1Buyer; 
    inquiries.add(inquiry1); 
    inquiry1Buyer.inquiries.add(inquiry1); 
 
    var inquiry2 = Inquiry(inquiries.concept);
    inquiry2.title = 'sand'; 
    inquiry2.description = 'bird'; 
    inquiry2.category = 'text'; 
    inquiry2.branch = 'software'; 
    inquiry2.publishingDate = new DateTime.now(); 
    inquiry2.expirationDate = new DateTime.now(); 
    inquiry2.deliveryLocation = 'lunch'; 
    inquiry2.providerCriteria = 'organization'; 
    inquiry2.status = 'school'; 
    var inquiry2Buyer = users.random(); 
    inquiry2.buyer = inquiry2Buyer; 
    inquiries.add(inquiry2); 
    inquiry2Buyer.inquiries.add(inquiry2); 
 
    var inquiry3 = Inquiry(inquiries.concept);
    inquiry3.title = 'tall'; 
    inquiry3.description = 'web'; 
    inquiry3.category = 'plaho'; 
    inquiry3.branch = 'economy'; 
    inquiry3.publishingDate = new DateTime.now(); 
    inquiry3.expirationDate = new DateTime.now(); 
    inquiry3.deliveryLocation = 'dinner'; 
    inquiry3.providerCriteria = 'debt'; 
    inquiry3.status = 'abstract'; 
    var inquiry3Buyer = users.random(); 
    inquiry3.buyer = inquiry3Buyer; 
    inquiries.add(inquiry3); 
    inquiry3Buyer.inquiries.add(inquiry3); 
 
  } 
 
  void initCompanies() { 
    var company1 = Company(companies.concept);
    company1.name = 'nothingness'; 
    company1.role = 'output'; 
    company1.address = 'down'; 
    company1.uidNumber = 'big'; 
    company1.registrationNumber = 'place'; 
    company1.numberOfEmployees = 'element'; 
    company1.websiteUrl = 'sentence'; 
    companies.add(company1); 
 
    var company2 = Company(companies.concept);
    company2.name = 'cinema'; 
    company2.role = 'capacity'; 
    company2.address = 'up'; 
    company2.uidNumber = 'health'; 
    company2.registrationNumber = 'walking'; 
    company2.numberOfEmployees = 'undo'; 
    company2.websiteUrl = 'tree'; 
    companies.add(company2); 
 
    var company3 = Company(companies.concept);
    company3.name = 'auto'; 
    company3.role = 'body'; 
    company3.address = 'revolution'; 
    company3.uidNumber = 'productivity'; 
    company3.registrationNumber = 'call'; 
    company3.numberOfEmployees = 'train'; 
    company3.websiteUrl = 'restaurant'; 
    companies.add(company3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
