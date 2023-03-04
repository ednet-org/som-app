 
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
    var offer1 = Offer(offers.concept!); 
    offer1.description = 'video'; 
    offer1.deliveryTime = 'undo'; 
    offer1.status = 'software'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 87.15689391914314; 
    var offer1Provider = providers.random(); 
    offer1.provider = offer1Provider; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept!); 
    offer2.description = 'life'; 
    offer2.deliveryTime = 'smog'; 
    offer2.status = 'policeman'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 42.21968965438305; 
    var offer2Provider = providers.random(); 
    offer2.provider = offer2Provider; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept!); 
    offer3.description = 'darts'; 
    offer3.deliveryTime = 'account'; 
    offer3.status = 'beach'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 11.959987270068417; 
    var offer3Provider = providers.random(); 
    offer3.provider = offer3Provider; 
    var offer3Inquiry = inquiries.random(); 
    offer3.inquiry = offer3Inquiry; 
    offers.add(offer3); 
    offer3Provider.offers.add(offer3); 
    offer3Inquiry.offers.add(offer3); 
 
  } 
 
  void initUsers() { 
    var user1 = User(users.concept!); 
    user1.username = 'instruction'; 
    user1.roleAtSom = 'redo'; 
    user1.roleAtCompany = 'agreement'; 
    var user1Company = companies.random(); 
    user1.company = user1Company; 
    users.add(user1); 
    user1Company.employees.add(user1); 
 
    var user2 = User(users.concept!); 
    user2.username = 'observation'; 
    user2.roleAtSom = 'message'; 
    user2.roleAtCompany = 'answer'; 
    var user2Company = companies.random(); 
    user2.company = user2Company; 
    users.add(user2); 
    user2Company.employees.add(user2); 
 
    var user3 = User(users.concept!); 
    user3.username = 'notch'; 
    user3.roleAtSom = 'taxi'; 
    user3.roleAtCompany = 'tax'; 
    var user3Company = companies.random(); 
    user3.company = user3Company; 
    users.add(user3); 
    user3Company.employees.add(user3); 
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept!); 
    buyers.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept!); 
    buyers.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept!); 
    buyers.add(buyer3); 
 
  } 
 
  void initProviders() { 
    var provider1 = Provider(providers.concept!); 
    provider1.company = 'chemist'; 
    providers.add(provider1); 
 
    var provider2 = Provider(providers.concept!); 
    provider2.company = 'web'; 
    providers.add(provider2); 
 
    var provider3 = Provider(providers.concept!); 
    provider3.company = 'place'; 
    providers.add(provider3); 
 
  } 
 
  void initInquiries() { 
    var inquiry1 = Inquiry(inquiries.concept!); 
    inquiry1.title = 'question'; 
    inquiry1.description = 'music'; 
    inquiry1.category = 'computer'; 
    inquiry1.branch = 'tension'; 
    inquiry1.publishingDate = new DateTime.now(); 
    inquiry1.expirationDate = new DateTime.now(); 
    inquiry1.deliveryLocation = 'beach'; 
    inquiry1.providerCriteria = 'beans'; 
    inquiry1.status = 'kids'; 
    var inquiry1Buyer = users.random(); 
    inquiry1.buyer = inquiry1Buyer; 
    inquiries.add(inquiry1); 
    inquiry1Buyer.inquiries.add(inquiry1); 
 
    var inquiry2 = Inquiry(inquiries.concept!); 
    inquiry2.title = 'organization'; 
    inquiry2.description = 'sand'; 
    inquiry2.category = 'distance'; 
    inquiry2.branch = 'feeling'; 
    inquiry2.publishingDate = new DateTime.now(); 
    inquiry2.expirationDate = new DateTime.now(); 
    inquiry2.deliveryLocation = 'top'; 
    inquiry2.providerCriteria = 'highway'; 
    inquiry2.status = 'top'; 
    var inquiry2Buyer = users.random(); 
    inquiry2.buyer = inquiry2Buyer; 
    inquiries.add(inquiry2); 
    inquiry2Buyer.inquiries.add(inquiry2); 
 
    var inquiry3 = Inquiry(inquiries.concept!); 
    inquiry3.title = 'auto'; 
    inquiry3.description = 'smog'; 
    inquiry3.category = 'nothingness'; 
    inquiry3.branch = 'highway'; 
    inquiry3.publishingDate = new DateTime.now(); 
    inquiry3.expirationDate = new DateTime.now(); 
    inquiry3.deliveryLocation = 'edition'; 
    inquiry3.providerCriteria = 'body'; 
    inquiry3.status = 'parfem'; 
    var inquiry3Buyer = users.random(); 
    inquiry3.buyer = inquiry3Buyer; 
    inquiries.add(inquiry3); 
    inquiry3Buyer.inquiries.add(inquiry3); 
 
  } 
 
  void initCompanies() { 
    var company1 = Company(companies.concept!); 
    company1.name = 'hot'; 
    company1.role = 'seed'; 
    company1.address = 'coffee'; 
    company1.uidNumber = 'thing'; 
    company1.registrationNumber = 'hunting'; 
    company1.numberOfEmployees = 'series'; 
    company1.websiteUrl = 'course'; 
    companies.add(company1); 
 
    var company2 = Company(companies.concept!); 
    company2.name = 'auto'; 
    company2.role = 'word'; 
    company2.address = 'vessel'; 
    company2.uidNumber = 'ship'; 
    company2.registrationNumber = 'country'; 
    company2.numberOfEmployees = 'security'; 
    company2.websiteUrl = 'season'; 
    companies.add(company2); 
 
    var company3 = Company(companies.concept!); 
    company3.name = 'table'; 
    company3.role = 'ticket'; 
    company3.address = 'notch'; 
    company3.uidNumber = 'umbrella'; 
    company3.registrationNumber = 'effort'; 
    company3.numberOfEmployees = 'offence'; 
    company3.websiteUrl = 'cash'; 
    companies.add(company3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
