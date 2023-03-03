part of som_manager; 
 
// lib/gen/som/manager/model_entries.dart 
 
class ManagerEntries extends ModelEntries { 
 
  ManagerEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("Company"); 
    entries["Company"] = Companies(concept); 
    concept = model.concepts.singleWhereCode("Buyer"); 
    entries["Buyer"] = Buyers(concept); 
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
    if (concept.code == "Country") { 
      return Countries(concept); 
    } 
    if (concept.code == "ZIP") { 
      return ZIPs(concept); 
    } 
    if (concept.code == "Street") { 
      return Streets(concept); 
    } 
    if (concept.code == "Attachment") { 
      return Attachments(concept); 
    } 
    if (concept.code == "Category") { 
      return Categories(concept); 
    } 
    if (concept.code == "Tag") { 
      return Tags(concept); 
    } 
    if (concept.code == "Registration") { 
      return Registrations(concept); 
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
    if (concept.code == "Buyer") { 
      return Buyers(concept); 
    } 
    if (concept.code == "UserRoleAtCompany") { 
      return UserRoleAtCompanies(concept); 
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
    if (concept.code == "Country") { 
      return Country(concept); 
    } 
    if (concept.code == "ZIP") { 
      return ZIP(concept); 
    } 
    if (concept.code == "Street") { 
      return Street(concept); 
    } 
    if (concept.code == "Attachment") { 
      return Attachment(concept); 
    } 
    if (concept.code == "Category") { 
      return Category(concept); 
    } 
    if (concept.code == "Tag") { 
      return Tag(concept); 
    } 
    if (concept.code == "Registration") { 
      return Registration(concept); 
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
    if (concept.code == "Buyer") { 
      return Buyer(concept); 
    } 
    if (concept.code == "UserRoleAtCompany") { 
      return UserRoleAtCompany(concept); 
    } 
    if (concept.code == "Offer") { 
      return Offer(concept); 
    } 
    return null; 
  } 
 
  Companies get companies => getEntry("Company") as Companies; 
  Buyers get buyers => getEntry("Buyer") as Buyers; 
  Offers get offers => getEntry("Offer") as Offers; 
 
} 
 
