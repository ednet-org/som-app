 
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
    initBuyers(); 
    initCompanies(); 
    initOffers(); 
  } 
 
  void initCompanies() { 
    var company1 = Company(companies.concept); 
    company1.name = 'house'; 
    company1.role = 'job'; 
    company1.address = 'software'; 
    company1.uidNumber = 'baby'; 
    company1.registrationNumber = 'yellow'; 
    company1.numberOfEmployees = 'account'; 
    company1.websiteUrl = 'boat'; 
    var company1Categories = categories.random(); 
    company1.categories = company1Categories; 
    companies.add(company1); 
    company1Categories.companies.add(company1); 
 
    var company2 = Company(companies.concept); 
    company2.name = 'down'; 
    company2.role = 'bird'; 
    company2.address = 'job'; 
    company2.uidNumber = 'family'; 
    company2.registrationNumber = 'place'; 
    company2.numberOfEmployees = 'universe'; 
    company2.websiteUrl = 'agreement'; 
    var company2Categories = categories.random(); 
    company2.categories = company2Categories; 
    companies.add(company2); 
    company2Categories.companies.add(company2); 
 
    var company3 = Company(companies.concept); 
    company3.name = 'algorithm'; 
    company3.role = 'cabinet'; 
    company3.address = 'candy'; 
    company3.uidNumber = 'sin'; 
    company3.registrationNumber = 'walking'; 
    company3.numberOfEmployees = 'selfdo'; 
    company3.websiteUrl = 'salary'; 
    var company3Categories = categories.random(); 
    company3.categories = company3Categories; 
    companies.add(company3); 
    company3Categories.companies.add(company3); 
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept); 
    buyer1.id = 'teacher'; 
    buyers.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept); 
    buyer2.id = 'center'; 
    buyers.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept); 
    buyer3.id = 'up'; 
    buyers.add(buyer3); 
 
  } 
 
  void initOffers() { 
    var offer1 = Offer(offers.concept); 
    offer1.description = 'kids'; 
    offer1.deliveryTime = 'agile'; 
    offer1.status = 'sand'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 33.93740403598292; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    var offer1Provider = providerCriterias.random(); 
    offer1.provider = offer1Provider; 
    offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept); 
    offer2.description = 'universe'; 
    offer2.deliveryTime = 'holiday'; 
    offer2.status = 'beer'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 48.01983339628342; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    var offer2Provider = providerCriterias.random(); 
    offer2.provider = offer2Provider; 
    offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept); 
    offer3.description = 'up'; 
    offer3.deliveryTime = 'city'; 
    offer3.status = 'performance'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 27.38586021018854; 
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
 
