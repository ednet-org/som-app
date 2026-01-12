part of som_manager; 
 
// lib/gen/som/manager/model_entries.dart 
 
class ManagerEntries extends ModelEntries { 
 
  ManagerEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("OfferProvider"); 
    entries["OfferProvider"] = OfferProviders(concept); 
    concept = model.concepts.singleWhereCode("PlatformRole"); 
    entries["PlatformRole"] = PlatformRoles(concept); 
    concept = model.concepts.singleWhereCode("Consultant"); 
    entries["Consultant"] = Consultants(concept); 
    concept = model.concepts.singleWhereCode("Buyer"); 
    entries["Buyer"] = Buyers(concept); 
    concept = model.concepts.singleWhereCode("TenantRole"); 
    entries["TenantRole"] = TenantRoles(concept); 
    concept = model.concepts.singleWhereCode("Platform"); 
    entries["Platform"] = Platforms(concept); 
    concept = model.concepts.singleWhereCode("Company"); 
    entries["Company"] = Companies(concept); 
    concept = model.concepts.singleWhereCode("User"); 
    entries["User"] = Users(concept); 
    concept = model.concepts.singleWhereCode("Inquiry"); 
    entries["Inquiry"] = Inquiries(concept); 
    concept = model.concepts.singleWhereCode("Registration"); 
    entries["Registration"] = Registrations(concept); 
    concept = model.concepts.singleWhereCode("Offer"); 
    entries["Offer"] = Offers(concept); 
    return entries; 
  } 
 
  Entities? newEntities(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Email") { 
      return Emails(concept); 
    } 
    if (concept.code == "PhoneNumber") { 
      return PhoneNumbers(concept); 
    } 
    if (concept.code == "StreetDetails") { 
      return StreetDetailss(concept); 
    } 
    if (concept.code == "Address") { 
      return Addresss(concept); 
    } 
    if (concept.code == "ZIP") { 
      return ZIPs(concept); 
    } 
    if (concept.code == "Street") { 
      return Streets(concept); 
    } 
    if (concept.code == "Country") { 
      return Countries(concept); 
    } 
    if (concept.code == "Attachment") { 
      return Attachments(concept); 
    } 
    if (concept.code == "Category") { 
      return Categories(concept); 
    } 
    if (concept.code == "OfferProvider") { 
      return OfferProviders(concept); 
    } 
    if (concept.code == "PlatformRole") { 
      return PlatformRoles(concept); 
    } 
    if (concept.code == "Consultant") { 
      return Consultants(concept); 
    } 
    if (concept.code == "Buyer") { 
      return Buyers(concept); 
    } 
    if (concept.code == "TenantRole") { 
      return TenantRoles(concept); 
    } 
    if (concept.code == "Platform") { 
      return Platforms(concept); 
    } 
    if (concept.code == "Company") { 
      return Companies(concept); 
    } 
    if (concept.code == "CompanyRoleAtSom") { 
      return CompanyRoleAtSoms(concept); 
    } 
    if (concept.code == "CompanyType") { 
      return CompanyTypes(concept); 
    } 
    if (concept.code == "CompanySize") { 
      return CompanySizes(concept); 
    } 
    if (concept.code == "User") { 
      return Users(concept); 
    } 
    if (concept.code == "Inquiry") { 
      return Inquiries(concept); 
    } 
    if (concept.code == "InquiryStatus") { 
      return InquiryStatuss(concept); 
    } 
    if (concept.code == "ProviderCriteria") { 
      return ProviderCriterias(concept); 
    } 
    if (concept.code == "Registration") { 
      return Registrations(concept); 
    } 
    if (concept.code == "Offer") { 
      return Offers(concept); 
    } 
    return null; 
  } 
 
  Entity? newEntity(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Email") { 
      return Email(concept); 
    } 
    if (concept.code == "PhoneNumber") { 
      return PhoneNumber(concept); 
    } 
    if (concept.code == "StreetDetails") { 
      return StreetDetails(concept); 
    } 
    if (concept.code == "Address") { 
      return Address(concept); 
    } 
    if (concept.code == "ZIP") { 
      return ZIP(concept); 
    } 
    if (concept.code == "Street") { 
      return Street(concept); 
    } 
    if (concept.code == "Country") { 
      return Country(concept); 
    } 
    if (concept.code == "Attachment") { 
      return Attachment(concept); 
    } 
    if (concept.code == "Category") { 
      return Category(concept); 
    } 
    if (concept.code == "OfferProvider") { 
      return OfferProvider(concept); 
    } 
    if (concept.code == "PlatformRole") { 
      return PlatformRole(concept); 
    } 
    if (concept.code == "Consultant") { 
      return Consultant(concept); 
    } 
    if (concept.code == "Buyer") { 
      return Buyer(concept); 
    } 
    if (concept.code == "TenantRole") { 
      return TenantRole(concept); 
    } 
    if (concept.code == "Platform") { 
      return Platform(concept); 
    } 
    if (concept.code == "Company") { 
      return Company(concept); 
    } 
    if (concept.code == "CompanyRoleAtSom") { 
      return CompanyRoleAtSom(concept); 
    } 
    if (concept.code == "CompanyType") { 
      return CompanyType(concept); 
    } 
    if (concept.code == "CompanySize") { 
      return CompanySize(concept); 
    } 
    if (concept.code == "User") { 
      return User(concept); 
    } 
    if (concept.code == "Inquiry") { 
      return Inquiry(concept); 
    } 
    if (concept.code == "InquiryStatus") { 
      return InquiryStatus(concept); 
    } 
    if (concept.code == "ProviderCriteria") { 
      return ProviderCriteria(concept); 
    } 
    if (concept.code == "Registration") { 
      return Registration(concept); 
    } 
    if (concept.code == "Offer") { 
      return Offer(concept); 
    } 
    return null; 
  } 
 
  OfferProviders get offerProviders => getEntry("OfferProvider") as OfferProviders; 
  PlatformRoles get platformRoles => getEntry("PlatformRole") as PlatformRoles; 
  Consultants get consultants => getEntry("Consultant") as Consultants; 
  Buyers get buyers => getEntry("Buyer") as Buyers; 
  TenantRoles get tenantRoles => getEntry("TenantRole") as TenantRoles; 
  Platforms get platforms => getEntry("Platform") as Platforms; 
  Companies get companies => getEntry("Company") as Companies; 
  Users get users => getEntry("User") as Users; 
  Inquiries get inquiries => getEntry("Inquiry") as Inquiries; 
  Registrations get registrations => getEntry("Registration") as Registrations; 
  Offers get offers => getEntry("Offer") as Offers; 
 
} 
 
