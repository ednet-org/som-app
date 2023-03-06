 
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
    initRegistrations(); 
    initInquiries(); 
    initOfferProviders(); 
    initBuyers(); 
    initConsultants(); 
    initUsers(); 
    initPlatformRoles(); 
    initOffers(); 
    initCompanies(); 
  } 
 
  void initOfferProviders() { 
    var offerProvider1 = OfferProvider(offerProviders.concept); 
    offerProvider1.company = 'course'; 
    offerProvider1.user = 'email'; 
    var offerProvider1Registration = registrations.random(); 
    offerProvider1.registration = offerProvider1Registration; 
    offerProviders.add(offerProvider1); 
    offerProvider1Registration.provider.add(offerProvider1); 
 
    var offerProvider2 = OfferProvider(offerProviders.concept); 
    offerProvider2.company = 'answer'; 
    offerProvider2.user = 'measuremewnt'; 
    var offerProvider2Registration = registrations.random(); 
    offerProvider2.registration = offerProvider2Registration; 
    offerProviders.add(offerProvider2); 
    offerProvider2Registration.provider.add(offerProvider2); 
 
    var offerProvider3 = OfferProvider(offerProviders.concept); 
    offerProvider3.company = 'money'; 
    offerProvider3.user = 'table'; 
    var offerProvider3Registration = registrations.random(); 
    offerProvider3.registration = offerProvider3Registration; 
    offerProviders.add(offerProvider3); 
    offerProvider3Registration.provider.add(offerProvider3); 
 
  } 
 
  void initPlatformRoles() { 
    var platformRole1 = PlatformRole(platformRoles.concept); 
    platformRole1.name = 'money'; 
    platformRole1.value = 'effort'; 
    var platformRole1User = users.random(); 
    platformRole1.user = platformRole1User; 
    var platformRole1Platform = platforms.random(); 
    platformRole1.platform = platformRole1Platform; 
    platformRoles.add(platformRole1); 
    platformRole1User.platformRoles.add(platformRole1); 
    platformRole1Platform.roles.add(platformRole1); 
 
    var platformRole2 = PlatformRole(platformRoles.concept); 
    platformRole2.name = 'table'; 
    platformRole2.value = 'children'; 
    var platformRole2User = users.random(); 
    platformRole2.user = platformRole2User; 
    var platformRole2Platform = platforms.random(); 
    platformRole2.platform = platformRole2Platform; 
    platformRoles.add(platformRole2); 
    platformRole2User.platformRoles.add(platformRole2); 
    platformRole2Platform.roles.add(platformRole2); 
 
    var platformRole3 = PlatformRole(platformRoles.concept); 
    platformRole3.name = 'craving'; 
    platformRole3.value = 'void'; 
    var platformRole3User = users.random(); 
    platformRole3.user = platformRole3User; 
    var platformRole3Platform = platforms.random(); 
    platformRole3.platform = platformRole3Platform; 
    platformRoles.add(platformRole3); 
    platformRole3User.platformRoles.add(platformRole3); 
    platformRole3Platform.roles.add(platformRole3); 
 
  } 
 
  void initConsultants() { 
    var consultant1 = Consultant(consultants.concept); 
    consultant1.user = 'team'; 
    var consultant1Platform = platforms.random(); 
    consultant1.platform = consultant1Platform; 
    consultants.add(consultant1); 
    consultant1Platform.consultants.add(consultant1); 
 
    var consultant2 = Consultant(consultants.concept); 
    consultant2.user = 'hunting'; 
    var consultant2Platform = platforms.random(); 
    consultant2.platform = consultant2Platform; 
    consultants.add(consultant2); 
    consultant2Platform.consultants.add(consultant2); 
 
    var consultant3 = Consultant(consultants.concept); 
    consultant3.user = 'selfdo'; 
    var consultant3Platform = platforms.random(); 
    consultant3.platform = consultant3Platform; 
    consultants.add(consultant3); 
    consultant3Platform.consultants.add(consultant3); 
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept); 
    buyer1.user = 'theme'; 
    var buyer1Registration = registrations.random(); 
    buyer1.registration = buyer1Registration; 
    buyers.add(buyer1); 
    buyer1Registration.buyer.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept); 
    buyer2.user = 'entrance'; 
    var buyer2Registration = registrations.random(); 
    buyer2.registration = buyer2Registration; 
    buyers.add(buyer2); 
    buyer2Registration.buyer.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept); 
    buyer3.user = 'cable'; 
    var buyer3Registration = registrations.random(); 
    buyer3.registration = buyer3Registration; 
    buyers.add(buyer3); 
    buyer3Registration.buyer.add(buyer3); 
 
  } 
 
  void initTenantRoles() { 
    var tenantRole1 = TenantRole(tenantRoles.concept); 
    tenantRole1.name = 'college'; 
    tenantRole1.value = 'office'; 
    tenantRoles.add(tenantRole1); 
 
    var tenantRole2 = TenantRole(tenantRoles.concept); 
    tenantRole2.name = 'mile'; 
    tenantRole2.value = 'abstract'; 
    tenantRoles.add(tenantRole2); 
 
    var tenantRole3 = TenantRole(tenantRoles.concept); 
    tenantRole3.name = 'university'; 
    tenantRole3.value = 'candy'; 
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
    company1.name = 'explanation'; 
    company1.role = 'cloud'; 
    company1.address = 'cup'; 
    company1.uidNumber = 'cloud'; 
    company1.registrationNumber = 'wave'; 
    company1.numberOfEmployees = 'electronic'; 
    company1.websiteUrl = 'end'; 
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
    company2.name = 'cabinet'; 
    company2.role = 'darts'; 
    company2.address = 'selfdo'; 
    company2.uidNumber = 'top'; 
    company2.registrationNumber = 'theme'; 
    company2.numberOfEmployees = 'tension'; 
    company2.websiteUrl = 'tree'; 
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
    company3.name = 'beach'; 
    company3.role = 'selfie'; 
    company3.address = 'university'; 
    company3.uidNumber = 'electronic'; 
    company3.registrationNumber = 'measuremewnt'; 
    company3.numberOfEmployees = 'lifespan'; 
    company3.websiteUrl = 'explanation'; 
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
    user1.username = 'election'; 
    user1.roleAtSom = 'time'; 
    user1.roleAtCompany = 'plate'; 
    var user1TenantRole = tenantRoles.random(); 
    user1.tenantRole = user1TenantRole; 
    var user1Company = companies.random(); 
    user1.company = user1Company; 
    users.add(user1); 
    user1TenantRole.users.add(user1); 
    user1Company.employees.add(user1); 
 
    var user2 = User(users.concept); 
    user2.username = 'cable'; 
    user2.roleAtSom = 'place'; 
    user2.roleAtCompany = 'salary'; 
    var user2TenantRole = tenantRoles.random(); 
    user2.tenantRole = user2TenantRole; 
    var user2Company = companies.random(); 
    user2.company = user2Company; 
    users.add(user2); 
    user2TenantRole.users.add(user2); 
    user2Company.employees.add(user2); 
 
    var user3 = User(users.concept); 
    user3.username = 'secretary'; 
    user3.roleAtSom = 'unit'; 
    user3.roleAtCompany = 'agile'; 
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
    inquiry1.title = 'time'; 
    inquiry1.description = 'bank'; 
    inquiry1.category = 'service'; 
    inquiry1.branch = 'instruction'; 
    inquiry1.publishingDate = new DateTime.now(); 
    inquiry1.expirationDate = new DateTime.now(); 
    inquiry1.deliveryLocation = 'place'; 
    inquiry1.attachments = 'ocean'; 
    var inquiry1Buyer = buyers.random(); 
    inquiry1.buyer = inquiry1Buyer; 
    inquiries.add(inquiry1); 
    inquiry1Buyer.inquiries.add(inquiry1); 
 
    var inquiry2 = Inquiry(inquiries.concept); 
    inquiry2.title = 'concern'; 
    inquiry2.description = 'coffee'; 
    inquiry2.category = 'center'; 
    inquiry2.branch = 'place'; 
    inquiry2.publishingDate = new DateTime.now(); 
    inquiry2.expirationDate = new DateTime.now(); 
    inquiry2.deliveryLocation = 'ship'; 
    inquiry2.attachments = 'sin'; 
    var inquiry2Buyer = buyers.random(); 
    inquiry2.buyer = inquiry2Buyer; 
    inquiries.add(inquiry2); 
    inquiry2Buyer.inquiries.add(inquiry2); 
 
    var inquiry3 = Inquiry(inquiries.concept); 
    inquiry3.title = 'rice'; 
    inquiry3.description = 'life'; 
    inquiry3.category = 'room'; 
    inquiry3.branch = 'kids'; 
    inquiry3.publishingDate = new DateTime.now(); 
    inquiry3.expirationDate = new DateTime.now(); 
    inquiry3.deliveryLocation = 'winter'; 
    inquiry3.attachments = 'chemist'; 
    var inquiry3Buyer = buyers.random(); 
    inquiry3.buyer = inquiry3Buyer; 
    inquiries.add(inquiry3); 
    inquiry3Buyer.inquiries.add(inquiry3); 
 
  } 
 
  void initRegistrations() { 
    var registration1 = Registration(registrations.concept); 
    registration1.company = 'rice'; 
    registration1.user = 'performance'; 
    registration1.platformRole = 'call'; 
    registrations.add(registration1); 
 
    var registration2 = Registration(registrations.concept); 
    registration2.company = 'opinion'; 
    registration2.user = 'nothingness'; 
    registration2.platformRole = 'call'; 
    registrations.add(registration2); 
 
    var registration3 = Registration(registrations.concept); 
    registration3.company = 'up'; 
    registration3.user = 'objective'; 
    registration3.platformRole = 'autobus'; 
    registrations.add(registration3); 
 
  } 
 
  void initOffers() { 
    var offer1 = Offer(offers.concept); 
    offer1.description = 'seed'; 
    offer1.deliveryTime = 'video'; 
    offer1.status = 'policeman'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 26.56184938658316; 
    var offer1Provider = offerProviders.random(); 
    offer1.provider = offer1Provider; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept); 
    offer2.description = 'cinema'; 
    offer2.deliveryTime = 'computer'; 
    offer2.status = 'dog'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 94.45217698264018; 
    var offer2Provider = offerProviders.random(); 
    offer2.provider = offer2Provider; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept); 
    offer3.description = 'time'; 
    offer3.deliveryTime = 'school'; 
    offer3.status = 'big'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 83.60107555017213; 
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
 
