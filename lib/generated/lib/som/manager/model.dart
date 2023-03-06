 
part of som_manager; 
 
// lib/som/manager/model.dart 
 
class ManagerModel extends ManagerEntries { 
 
  ManagerModel(Model model) : super(model); 
 
  void fromJsonToOfferProviderEntry() { 
    fromJsonToEntry(somManagerOfferProviderEntry); 
  } 
 
  void fromJsonToPlatformRoleEntry() { 
    fromJsonToEntry(somManagerPlatformRoleEntry); 
  } 
 
  void fromJsonToConsultantEntry() { 
    fromJsonToEntry(somManagerConsultantEntry); 
  } 
 
  void fromJsonToBuyerEntry() { 
    fromJsonToEntry(somManagerBuyerEntry); 
  } 
 
  void fromJsonToTenantRoleEntry() { 
    fromJsonToEntry(somManagerTenantRoleEntry); 
  } 
 
  void fromJsonToPlatformEntry() { 
    fromJsonToEntry(somManagerPlatformEntry); 
  } 
 
  void fromJsonToCompanyEntry() { 
    fromJsonToEntry(somManagerCompanyEntry); 
  } 
 
  void fromJsonToUserEntry() { 
    fromJsonToEntry(somManagerUserEntry); 
  } 
 
  void fromJsonToInquiryEntry() { 
    fromJsonToEntry(somManagerInquiryEntry); 
  } 
 
  void fromJsonToRegistrationEntry() { 
    fromJsonToEntry(somManagerRegistrationEntry); 
  } 
 
  void fromJsonToOfferEntry() { 
    fromJsonToEntry(somManagerOfferEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(somManagerModel); 
  } 
 
  void init() {
    initPlatforms();
    initTenantRoles();
    initPlatformRoles();
    initRegistrations();
    initBuyers();
    initInquiries();
    initOfferProviders(); 
    initConsultants();
    initCompanies();
    initUsers();
    initOffers();
  }
 
  void initOfferProviders() { 
    var offerProvider1 = OfferProvider(offerProviders.concept); 
    offerProvider1.company = 'measuremewnt'; 
    offerProvider1.user = 'team'; 
    var offerProvider1Registration = registrations.random(); 
    offerProvider1.registration = offerProvider1Registration; 
    offerProviders.add(offerProvider1); 
    offerProvider1Registration.provider.add(offerProvider1); 
 
    var offerProvider2 = OfferProvider(offerProviders.concept); 
    offerProvider2.company = 'ball'; 
    offerProvider2.user = 'big'; 
    var offerProvider2Registration = registrations.random(); 
    offerProvider2.registration = offerProvider2Registration; 
    offerProviders.add(offerProvider2); 
    offerProvider2Registration.provider.add(offerProvider2); 
 
    var offerProvider3 = OfferProvider(offerProviders.concept); 
    offerProvider3.company = 'present'; 
    offerProvider3.user = 'book'; 
    var offerProvider3Registration = registrations.random(); 
    offerProvider3.registration = offerProvider3Registration; 
    offerProviders.add(offerProvider3); 
    offerProvider3Registration.provider.add(offerProvider3); 
 
  } 
 
  void initPlatformRoles() { 
    var platformRole1 = PlatformRole(platformRoles.concept); 
    platformRole1.name = 'television'; 
    platformRole1.value = 'place'; 
    var platformRole1Platform = platforms.random();
    platformRole1.platform = platformRole1Platform; 
    platformRoles.add(platformRole1); 
    platformRole1Platform.roles.add(platformRole1);
 
    var platformRole2 = PlatformRole(platformRoles.concept); 
    platformRole2.name = 'letter'; 
    platformRole2.value = 'software'; 
    var platformRole2Platform = platforms.random();
    platformRole2.platform = platformRole2Platform; 
    platformRoles.add(platformRole2); 
    platformRole2Platform.roles.add(platformRole2);
 
    var platformRole3 = PlatformRole(platformRoles.concept); 
    platformRole3.name = 'ticket'; 
    platformRole3.value = 'dinner'; 
    var platformRole3Platform = platforms.random();
    platformRole3.platform = platformRole3Platform; 
    platformRoles.add(platformRole3); 
    platformRole3Platform.roles.add(platformRole3);
 
  } 
 
  void initConsultants() { 
    var consultant1 = Consultant(consultants.concept); 
    consultant1.user = 'hell'; 
    var consultant1Platform = platforms.random(); 
    consultant1.platform = consultant1Platform; 
    consultants.add(consultant1); 
    consultant1Platform.consultants.add(consultant1); 
 
    var consultant2 = Consultant(consultants.concept); 
    consultant2.user = 'theme'; 
    var consultant2Platform = platforms.random(); 
    consultant2.platform = consultant2Platform; 
    consultants.add(consultant2); 
    consultant2Platform.consultants.add(consultant2); 
 
    var consultant3 = Consultant(consultants.concept); 
    consultant3.user = 'wife'; 
    var consultant3Platform = platforms.random(); 
    consultant3.platform = consultant3Platform; 
    consultants.add(consultant3); 
    consultant3Platform.consultants.add(consultant3); 
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept); 
    buyer1.user = 'flower'; 
    var buyer1Registration = registrations.random(); 
    buyer1.registration = buyer1Registration; 
    buyers.add(buyer1); 
    buyer1Registration.buyer.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept); 
    buyer2.user = 'feeling'; 
    var buyer2Registration = registrations.random(); 
    buyer2.registration = buyer2Registration; 
    buyers.add(buyer2); 
    buyer2Registration.buyer.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept); 
    buyer3.user = 'vacation'; 
    var buyer3Registration = registrations.random(); 
    buyer3.registration = buyer3Registration; 
    buyers.add(buyer3); 
    buyer3Registration.buyer.add(buyer3); 
 
  } 
 
  void initTenantRoles() { 
    var tenantRole1 = TenantRole(tenantRoles.concept); 
    tenantRole1.name = 'bank'; 
    tenantRole1.value = 'message'; 
    tenantRoles.add(tenantRole1); 
 
    var tenantRole2 = TenantRole(tenantRoles.concept); 
    tenantRole2.name = 'meter'; 
    tenantRole2.value = 'up'; 
    tenantRoles.add(tenantRole2); 
 
    var tenantRole3 = TenantRole(tenantRoles.concept); 
    tenantRole3.name = 'hunting'; 
    tenantRole3.value = 'head'; 
    tenantRoles.add(tenantRole3); 
 
  } 
 
  void initPlatforms() { 
    var platform1 = Platform(platforms.concept); 
    platforms.add(platform1); 
 
    var platform2 = Platform(platforms.concept); 
    platforms.add(platform2); 
 
    var platform3 = Platform(platforms.concept); 
    platforms.add(platform3); 
 
  } 
 
  void initCompanies() { 
    var company1 = Company(companies.concept); 
    company1.name = 'sentence'; 
    company1.role = 'revolution'; 
    company1.address = 'vacation'; 
    company1.uidNumber = 'executive'; 
    company1.registrationNumber = 'vessel'; 
    company1.numberOfEmployees = 'price'; 
    company1.websiteUrl = 'answer'; 
    var company1PlatformRole = platformRoles.random(); 
    company1.platformRole = company1PlatformRole; 
    var company1TenantRole = tenantRoles.random(); 
    company1.tenantRole = company1TenantRole; 
    var company1Platform = platforms.random(); 
    company1.platform = company1Platform; 
    companies.add(company1); 
    company1PlatformRole.companies.add(company1); 
    company1TenantRole.companies.add(company1); 
    company1Platform.companies.add(company1); 
 
    var company2 = Company(companies.concept); 
    company2.name = 'lifespan'; 
    company2.role = 'test'; 
    company2.address = 'architecture'; 
    company2.uidNumber = 'feeling'; 
    company2.registrationNumber = 'measuremewnt'; 
    company2.numberOfEmployees = 'table'; 
    company2.websiteUrl = 'yellow'; 
    var company2PlatformRole = platformRoles.random(); 
    company2.platformRole = company2PlatformRole; 
    var company2TenantRole = tenantRoles.random(); 
    company2.tenantRole = company2TenantRole; 
    var company2Platform = platforms.random(); 
    company2.platform = company2Platform; 
    companies.add(company2); 
    company2PlatformRole.companies.add(company2); 
    company2TenantRole.companies.add(company2); 
    company2Platform.companies.add(company2); 
 
    var company3 = Company(companies.concept); 
    company3.name = 'picture'; 
    company3.role = 'grading'; 
    company3.address = 'country'; 
    company3.uidNumber = 'do'; 
    company3.registrationNumber = 'professor'; 
    company3.numberOfEmployees = 'right'; 
    company3.websiteUrl = 'distance'; 
    var company3PlatformRole = platformRoles.random(); 
    company3.platformRole = company3PlatformRole; 
    var company3TenantRole = tenantRoles.random(); 
    company3.tenantRole = company3TenantRole; 
    var company3Platform = platforms.random(); 
    company3.platform = company3Platform; 
    companies.add(company3); 
    company3PlatformRole.companies.add(company3); 
    company3TenantRole.companies.add(company3); 
    company3Platform.companies.add(company3); 
 
  } 
 
  void initUsers() {
    var user1 = User(users.concept);
    user1.username = 'autobus';
    user1.roleAtSom = 'marriage';
    user1.roleAtCompany = 'music';
    var user1TenantRole = tenantRoles.random();
    user1.tenantRole = user1TenantRole;
    var user1Company = companies.random();
    user1.company = user1Company;
    users.add(user1);
    user1TenantRole.users.add(user1);
    user1Company.employees.add(user1);

    var user2 = User(users.concept);
    user2.username = 'wave';
    user2.roleAtSom = 'camping';
    user2.roleAtCompany = 'money';
    var user2TenantRole = tenantRoles.random();
    user2.tenantRole = user2TenantRole;
    var user2Company = companies.random();
    user2.company = user2Company;
    users.add(user2);
    user2TenantRole.users.add(user2);
    user2Company.employees.add(user2);

    var user3 = User(users.concept);
    user3.username = 'place';
    user3.roleAtSom = 'capacity';
    user3.roleAtCompany = 'algorithm';
    var user3TenantRole = tenantRoles.random();
    user3.tenantRole = user3TenantRole;
    var user3Company = companies.random();
    user3.company = user3Company;
    users.add(user3);
    user3TenantRole.users.add(user3);
    user3Company.employees.add(user3);

  }

  void initInquiries() { 
    var inquiry1 = Inquiry(inquiries.concept); 
    inquiry1.title = 'policeman'; 
    inquiry1.description = 'election'; 
    inquiry1.category = 'cabinet'; 
    inquiry1.branch = 'grading'; 
    inquiry1.publishingDate = new DateTime.now(); 
    inquiry1.expirationDate = new DateTime.now(); 
    inquiry1.deliveryLocation = 'policeman'; 
    inquiry1.attachments = 'table'; 
    var inquiry1Buyer = buyers.random(); 
    inquiry1.buyer = inquiry1Buyer; 
    inquiries.add(inquiry1); 
    inquiry1Buyer.inquiries.add(inquiry1); 
 
    var inquiry2 = Inquiry(inquiries.concept); 
    inquiry2.title = 'ticket'; 
    inquiry2.description = 'health'; 
    inquiry2.category = 'secretary'; 
    inquiry2.branch = 'tape'; 
    inquiry2.publishingDate = new DateTime.now(); 
    inquiry2.expirationDate = new DateTime.now(); 
    inquiry2.deliveryLocation = 'productivity'; 
    inquiry2.attachments = 'redo'; 
    var inquiry2Buyer = buyers.random(); 
    inquiry2.buyer = inquiry2Buyer; 
    inquiries.add(inquiry2); 
    inquiry2Buyer.inquiries.add(inquiry2); 
 
    var inquiry3 = Inquiry(inquiries.concept); 
    inquiry3.title = 'dog'; 
    inquiry3.description = 'notch'; 
    inquiry3.category = 'teacher'; 
    inquiry3.branch = 'baby'; 
    inquiry3.publishingDate = new DateTime.now(); 
    inquiry3.expirationDate = new DateTime.now(); 
    inquiry3.deliveryLocation = 'team'; 
    inquiry3.attachments = 'auto'; 
    var inquiry3Buyer = buyers.random(); 
    inquiry3.buyer = inquiry3Buyer; 
    inquiries.add(inquiry3); 
    inquiry3Buyer.inquiries.add(inquiry3); 
 
  }

  void initRegistrations() { 
    var registration1 = Registration(registrations.concept); 
    registration1.company = 'finger'; 
    registration1.user = 'judge'; 
    registration1.platformRole = 'security'; 
    registrations.add(registration1); 
 
    var registration2 = Registration(registrations.concept); 
    registration2.company = 'picture'; 
    registration2.user = 'truck'; 
    registration2.platformRole = 'teaching'; 
    registrations.add(registration2); 
 
    var registration3 = Registration(registrations.concept); 
    registration3.company = 'craving'; 
    registration3.user = 'down'; 
    registration3.platformRole = 'mind'; 
    registrations.add(registration3); 
 
  } 
 
  void initOffers() { 
    var offer1 = Offer(offers.concept); 
    offer1.description = 'college'; 
    offer1.deliveryTime = 'service'; 
    offer1.status = 'school'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 30.837425587177904; 
    var offer1Provider = offerProviders.random(); 
    offer1.provider = offer1Provider; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept); 
    offer2.description = 'letter'; 
    offer2.deliveryTime = 'baby'; 
    offer2.status = 'park'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 44.29753430722313; 
    var offer2Provider = offerProviders.random(); 
    offer2.provider = offer2Provider; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept); 
    offer3.description = 'plaho'; 
    offer3.deliveryTime = 'dvd'; 
    offer3.status = 'selfdo'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 59.77070038951254; 
    var offer3Provider = offerProviders.random(); 
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
 
