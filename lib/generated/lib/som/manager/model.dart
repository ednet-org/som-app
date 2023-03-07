 
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
    offerProvider1.company = 'opinion'; 
    offerProvider1.user = 'advisor'; 
    var offerProvider1Registration = registrations.random(); 
    offerProvider1.registration = offerProvider1Registration; 
    offerProviders.add(offerProvider1); 
    offerProvider1Registration.provider.add(offerProvider1); 
 
    var offerProvider2 = OfferProvider(offerProviders.concept); 
    offerProvider2.company = 'big'; 
    offerProvider2.user = 'beer'; 
    var offerProvider2Registration = registrations.random(); 
    offerProvider2.registration = offerProvider2Registration; 
    offerProviders.add(offerProvider2); 
    offerProvider2Registration.provider.add(offerProvider2); 
 
    var offerProvider3 = OfferProvider(offerProviders.concept); 
    offerProvider3.company = 'hat'; 
    offerProvider3.user = 'line'; 
    var offerProvider3Registration = registrations.random(); 
    offerProvider3.registration = offerProvider3Registration; 
    offerProviders.add(offerProvider3); 
    offerProvider3Registration.provider.add(offerProvider3); 
 
  } 
 
  void initPlatformRoles() { 
    var platformRole1 = PlatformRole(platformRoles.concept); 
    platformRole1.name = 'grading'; 
    platformRole1.value = 'question'; 
    var platformRole1User = users.random(); 
    platformRole1.user = platformRole1User; 
    var platformRole1Platform = platforms.random(); 
    platformRole1.platform = platformRole1Platform; 
    platformRoles.add(platformRole1); 
    platformRole1User.platformRoles.add(platformRole1); 
    platformRole1Platform.roles.add(platformRole1); 
 
    var platformRole2 = PlatformRole(platformRoles.concept); 
    platformRole2.name = 'edition'; 
    platformRole2.value = 'sailing'; 
    var platformRole2User = users.random(); 
    platformRole2.user = platformRole2User; 
    var platformRole2Platform = platforms.random(); 
    platformRole2.platform = platformRole2Platform; 
    platformRoles.add(platformRole2); 
    platformRole2User.platformRoles.add(platformRole2); 
    platformRole2Platform.roles.add(platformRole2); 
 
    var platformRole3 = PlatformRole(platformRoles.concept); 
    platformRole3.name = 'measuremewnt'; 
    platformRole3.value = 'bank'; 
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
    consultant1.user = 'objective'; 
    var consultant1Platform = platforms.random(); 
    consultant1.platform = consultant1Platform; 
    consultants.add(consultant1); 
    consultant1Platform.consultants.add(consultant1); 
 
    var consultant2 = Consultant(consultants.concept); 
    consultant2.user = 'answer'; 
    var consultant2Platform = platforms.random(); 
    consultant2.platform = consultant2Platform; 
    consultants.add(consultant2); 
    consultant2Platform.consultants.add(consultant2); 
 
    var consultant3 = Consultant(consultants.concept); 
    consultant3.user = 'meter'; 
    var consultant3Platform = platforms.random(); 
    consultant3.platform = consultant3Platform; 
    consultants.add(consultant3); 
    consultant3Platform.consultants.add(consultant3); 
 
  } 
 
  void initBuyers() { 
    var buyer1 = Buyer(buyers.concept); 
    buyer1.user = 'thing'; 
    var buyer1Registration = registrations.random(); 
    buyer1.registration = buyer1Registration; 
    buyers.add(buyer1); 
    buyer1Registration.buyer.add(buyer1); 
 
    var buyer2 = Buyer(buyers.concept); 
    buyer2.user = 'unit'; 
    var buyer2Registration = registrations.random(); 
    buyer2.registration = buyer2Registration; 
    buyers.add(buyer2); 
    buyer2Registration.buyer.add(buyer2); 
 
    var buyer3 = Buyer(buyers.concept); 
    buyer3.user = 'mind'; 
    var buyer3Registration = registrations.random(); 
    buyer3.registration = buyer3Registration; 
    buyers.add(buyer3); 
    buyer3Registration.buyer.add(buyer3); 
 
  } 
 
  void initTenantRoles() { 
    var tenantRole1 = TenantRole(tenantRoles.concept); 
    tenantRole1.name = 'guest'; 
    tenantRole1.value = 'office'; 
    tenantRoles.add(tenantRole1); 
 
    var tenantRole2 = TenantRole(tenantRoles.concept); 
    tenantRole2.name = 'time'; 
    tenantRole2.value = 'electronic'; 
    tenantRoles.add(tenantRole2); 
 
    var tenantRole3 = TenantRole(tenantRoles.concept); 
    tenantRole3.name = 'security'; 
    tenantRole3.value = 'navigation'; 
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
    company1.name = 'algorithm'; 
    company1.role = 'universe'; 
    company1.address = 'life'; 
    company1.uidNumber = 'capacity'; 
    company1.registrationNumber = 'small'; 
    company1.numberOfEmployees = 'void'; 
    company1.websiteUrl = 'circle'; 
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
    company2.name = 'test'; 
    company2.role = 'cardboard'; 
    company2.address = 'tape'; 
    company2.uidNumber = 'holiday'; 
    company2.registrationNumber = 'money'; 
    company2.numberOfEmployees = 'photo'; 
    company2.websiteUrl = 'test'; 
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
    company3.name = 'university'; 
    company3.role = 'tax'; 
    company3.address = 'milk'; 
    company3.uidNumber = 'hell'; 
    company3.registrationNumber = 'consulting'; 
    company3.numberOfEmployees = 'kids'; 
    company3.websiteUrl = 'ship'; 
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
    user1.username = 'school'; 
    user1.roleAtSom = 'hall'; 
    user1.roleAtCompany = 'answer'; 
    var user1TenantRole = tenantRoles.random(); 
    user1.tenantRole = user1TenantRole; 
    var user1Company = companies.random(); 
    user1.company = user1Company; 
    users.add(user1); 
    user1TenantRole.users.add(user1); 
    user1Company.employees.add(user1); 
 
    var user2 = User(users.concept); 
    user2.username = 'universe'; 
    user2.roleAtSom = 'phone'; 
    user2.roleAtCompany = 'output'; 
    var user2TenantRole = tenantRoles.random(); 
    user2.tenantRole = user2TenantRole; 
    var user2Company = companies.random(); 
    user2.company = user2Company; 
    users.add(user2); 
    user2TenantRole.users.add(user2); 
    user2Company.employees.add(user2); 
 
    var user3 = User(users.concept); 
    user3.username = 'children'; 
    user3.roleAtSom = 'salary'; 
    user3.roleAtCompany = 'entrance'; 
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
    inquiry1.title = 'phone'; 
    inquiry1.description = 'sentence'; 
    inquiry1.category = 'right'; 
    inquiry1.branch = 'measuremewnt'; 
    inquiry1.publishingDate = new DateTime.now(); 
    inquiry1.expirationDate = new DateTime.now(); 
    inquiry1.deliveryLocation = 'hunting'; 
    inquiry1.attachments = 'wheat'; 
    var inquiry1Buyer = buyers.random(); 
    inquiry1.buyer = inquiry1Buyer; 
    inquiries.add(inquiry1); 
    inquiry1Buyer.inquiries.add(inquiry1); 
 
    var inquiry2 = Inquiry(inquiries.concept); 
    inquiry2.title = 'hat'; 
    inquiry2.description = 'candy'; 
    inquiry2.category = 'series'; 
    inquiry2.branch = 'picture'; 
    inquiry2.publishingDate = new DateTime.now(); 
    inquiry2.expirationDate = new DateTime.now(); 
    inquiry2.deliveryLocation = 'energy'; 
    inquiry2.attachments = 'craving'; 
    var inquiry2Buyer = buyers.random(); 
    inquiry2.buyer = inquiry2Buyer; 
    inquiries.add(inquiry2); 
    inquiry2Buyer.inquiries.add(inquiry2); 
 
    var inquiry3 = Inquiry(inquiries.concept); 
    inquiry3.title = 'country'; 
    inquiry3.description = 'season'; 
    inquiry3.category = 'autobus'; 
    inquiry3.branch = 'sun'; 
    inquiry3.publishingDate = new DateTime.now(); 
    inquiry3.expirationDate = new DateTime.now(); 
    inquiry3.deliveryLocation = 'walking'; 
    inquiry3.attachments = 'architecture'; 
    var inquiry3Buyer = buyers.random(); 
    inquiry3.buyer = inquiry3Buyer; 
    inquiries.add(inquiry3); 
    inquiry3Buyer.inquiries.add(inquiry3); 
 
  } 
 
  void initRegistrations() { 
    var registration1 = Registration(registrations.concept); 
    registration1.company = 'heaven'; 
    registration1.user = 'email'; 
    registration1.platformRole = 'craving'; 
    registrations.add(registration1); 
 
    var registration2 = Registration(registrations.concept); 
    registration2.company = 'baby'; 
    registration2.user = 'objective'; 
    registration2.platformRole = 'vacation'; 
    registrations.add(registration2); 
 
    var registration3 = Registration(registrations.concept); 
    registration3.company = 'money'; 
    registration3.user = 'sin'; 
    registration3.platformRole = 'phone'; 
    registrations.add(registration3); 
 
  } 
 
  void initOffers() { 
    var offer1 = Offer(offers.concept); 
    offer1.description = 'understanding'; 
    offer1.deliveryTime = 'entrance'; 
    offer1.status = 'salary'; 
    offer1.expirationDate = new DateTime.now(); 
    offer1.price = 77.40422886792476; 
    var offer1Provider = offerProviders.random(); 
    offer1.provider = offer1Provider; 
    var offer1Inquiry = inquiries.random(); 
    offer1.inquiry = offer1Inquiry; 
    offers.add(offer1); 
    offer1Provider.offers.add(offer1); 
    offer1Inquiry.offers.add(offer1); 
 
    var offer2 = Offer(offers.concept); 
    offer2.description = 'seed'; 
    offer2.deliveryTime = 'paper'; 
    offer2.status = 'kids'; 
    offer2.expirationDate = new DateTime.now(); 
    offer2.price = 37.293051099216235; 
    var offer2Provider = offerProviders.random(); 
    offer2.provider = offer2Provider; 
    var offer2Inquiry = inquiries.random(); 
    offer2.inquiry = offer2Inquiry; 
    offers.add(offer2); 
    offer2Provider.offers.add(offer2); 
    offer2Inquiry.offers.add(offer2); 
 
    var offer3 = Offer(offers.concept); 
    offer3.description = 'corner'; 
    offer3.deliveryTime = 'camping'; 
    offer3.status = 'discount'; 
    offer3.expirationDate = new DateTime.now(); 
    offer3.price = 90.6677982553649; 
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
 
