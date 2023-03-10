 
// test/som/manager/som_manager_company_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerCompanies( 
    SomDomain somDomain, ManagerModel managerModel, Companies companies) { 
  DomainSession session; 
  group("Testing Som.Manager.Company", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(companies.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(companies.isEmpty, isTrue); 
      expect(companies.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = managerModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = managerModel.toJson(); 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      managerModel.fromJson(json); 
      expect(managerModel.isEmpty, isFalse); 
 
      managerModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = managerModel.fromEntryToJson("Company"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Company"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Company"); 
      companies.clear(); 
      expect(companies.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(companies.isEmpty, isFalse); 
 
      companies.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add company required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add company unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found company by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var company = companies.singleWhereOid(ednetOid); 
      expect(company, isNull); 
    }); 
 
    test("Find company by oid", () { 
      var randomCompany = managerModel.companies.random(); 
      var company = companies.singleWhereOid(randomCompany.oid); 
      expect(company, isNotNull); 
      expect(company, equals(randomCompany)); 
    }); 
 
    test("Find company by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find company by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find company by attribute", () { 
      var randomCompany = managerModel.companies.random(); 
      var company = 
          companies.firstWhereAttribute("name", randomCompany.name); 
      expect(company, isNotNull); 
      expect(company.name, equals(randomCompany.name)); 
    }); 
 
    test("Select companies by attribute", () { 
      var randomCompany = managerModel.companies.random(); 
      var selectedCompanies = 
          companies.selectWhereAttribute("name", randomCompany.name); 
      expect(selectedCompanies.isEmpty, isFalse); 
      selectedCompanies.forEach((se) => 
          expect(se.name, equals(randomCompany.name))); 
 
      //selectedCompanies.display(title: "Select companies by name"); 
    }); 
 
    test("Select companies by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select companies by attribute, then add", () { 
      var randomCompany = managerModel.companies.random(); 
      var selectedCompanies = 
          companies.selectWhereAttribute("name", randomCompany.name); 
      expect(selectedCompanies.isEmpty, isFalse); 
      expect(selectedCompanies.source?.isEmpty, isFalse); 
      var companiesCount = companies.length; 
 
      var company = Company(companies.concept); 
      company.name = 'question'; 
      company.role = 'entertainment'; 
      company.address = 'word'; 
      company.uidNumber = 'slate'; 
      company.registrationNumber = 'teacher'; 
      company.numberOfEmployees = 'message'; 
      company.websiteUrl = 'craving'; 
      var added = selectedCompanies.add(company); 
      expect(added, isTrue); 
      expect(companies.length, equals(++companiesCount)); 
 
      //selectedCompanies.display(title: 
      //  "Select companies by attribute, then add"); 
      //companies.display(title: "All companies"); 
    }); 
 
    test("Select companies by attribute, then remove", () { 
      var randomCompany = managerModel.companies.random(); 
      var selectedCompanies = 
          companies.selectWhereAttribute("name", randomCompany.name); 
      expect(selectedCompanies.isEmpty, isFalse); 
      expect(selectedCompanies.source?.isEmpty, isFalse); 
      var companiesCount = companies.length; 
 
      var removed = selectedCompanies.remove(randomCompany); 
      expect(removed, isTrue); 
      expect(companies.length, equals(--companiesCount)); 
 
      randomCompany.display(prefix: "removed"); 
      //selectedCompanies.display(title: 
      //  "Select companies by attribute, then remove"); 
      //companies.display(title: "All companies"); 
    }); 
 
    test("Sort companies", () { 
      // no id attribute 
      // add compareTo method in the specific Company class 
      /* 
      companies.sort(); 
 
      //companies.display(title: "Sort companies"); 
      */ 
    }); 
 
    test("Order companies", () { 
      // no id attribute 
      // add compareTo method in the specific Company class 
      /* 
      var orderedCompanies = companies.order(); 
      expect(orderedCompanies.isEmpty, isFalse); 
      expect(orderedCompanies.length, equals(companies.length)); 
      expect(orderedCompanies.source?.isEmpty, isFalse); 
      expect(orderedCompanies.source?.length, equals(companies.length)); 
      expect(orderedCompanies, isNot(same(companies))); 
 
      //orderedCompanies.display(title: "Order companies"); 
      */ 
    }); 
 
    test("Copy companies", () { 
      var copiedCompanies = companies.copy(); 
      expect(copiedCompanies.isEmpty, isFalse); 
      expect(copiedCompanies.length, equals(companies.length)); 
      expect(copiedCompanies, isNot(same(companies))); 
      copiedCompanies.forEach((e) => 
        expect(e, equals(companies.singleWhereOid(e.oid)))); 
      copiedCompanies.forEach((e) => 
        expect(e, isNot(same(companies.singleWhereId(e.id!))))); 
 
      //copiedCompanies.display(title: "Copy companies"); 
    }); 
 
    test("True for every company", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random company", () { 
      var company1 = managerModel.companies.random(); 
      expect(company1, isNotNull); 
      var company2 = managerModel.companies.random(); 
      expect(company2, isNotNull); 
 
      //company1.display(prefix: "random1"); 
      //company2.display(prefix: "random2"); 
    }); 
 
    test("Update company id with try", () { 
      // no id attribute 
    }); 
 
    test("Update company id without try", () { 
      // no id attribute 
    }); 
 
    test("Update company id with success", () { 
      // no id attribute 
    }); 
 
    test("Update company non id attribute with failure", () { 
      var randomCompany = managerModel.companies.random(); 
      var afterUpdateEntity = randomCompany.copy(); 
      afterUpdateEntity.name = 'heaven'; 
      expect(afterUpdateEntity.name, equals('heaven')); 
      // companies.update can only be used if oid, code or id is set. 
      expect(() => companies.update(randomCompany, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomCompany = managerModel.companies.random(); 
      randomCompany.display(prefix:"before copy: "); 
      var randomCompanyCopy = randomCompany.copy(); 
      randomCompanyCopy.display(prefix:"after copy: "); 
      expect(randomCompany, equals(randomCompanyCopy)); 
      expect(randomCompany.oid, equals(randomCompanyCopy.oid)); 
      expect(randomCompany.code, equals(randomCompanyCopy.code)); 
      expect(randomCompany.name, equals(randomCompanyCopy.name)); 
      expect(randomCompany.role, equals(randomCompanyCopy.role)); 
      expect(randomCompany.address, equals(randomCompanyCopy.address)); 
      expect(randomCompany.uidNumber, equals(randomCompanyCopy.uidNumber)); 
      expect(randomCompany.registrationNumber, equals(randomCompanyCopy.registrationNumber)); 
      expect(randomCompany.numberOfEmployees, equals(randomCompanyCopy.numberOfEmployees)); 
      expect(randomCompany.websiteUrl, equals(randomCompanyCopy.websiteUrl)); 
 
    }); 
 
    test("company action undo and redo", () { 
      var companyCount = companies.length; 
      var company = Company(companies.concept); 
        company.name = 'organization'; 
      company.role = 'hat'; 
      company.address = 'fascination'; 
      company.uidNumber = 'call'; 
      company.registrationNumber = 'agreement'; 
      company.numberOfEmployees = 'room'; 
      company.websiteUrl = 'brad'; 
    var companyPlatformRole = managerModel.platformRoles.random(); 
    company.platformRole = companyPlatformRole; 
    var companyTenantRole = managerModel.tenantRoles.random(); 
    company.tenantRole = companyTenantRole; 
    var companyPlatform = managerModel.platforms.random(); 
    company.platform = companyPlatform; 
      companies.add(company); 
    companyPlatformRole.companies.add(company); 
    companyTenantRole.companies.add(company); 
    companyPlatform.companies.add(company); 
      expect(companies.length, equals(++companyCount)); 
      companies.remove(company); 
      expect(companies.length, equals(--companyCount)); 
 
      var action = AddCommand(session, companies, company); 
      action.doIt(); 
      expect(companies.length, equals(++companyCount)); 
 
      action.undo(); 
      expect(companies.length, equals(--companyCount)); 
 
      action.redo(); 
      expect(companies.length, equals(++companyCount)); 
    }); 
 
    test("company session undo and redo", () { 
      var companyCount = companies.length; 
      var company = Company(companies.concept); 
        company.name = 'cinema'; 
      company.role = 'celebration'; 
      company.address = 'ticket'; 
      company.uidNumber = 'algorithm'; 
      company.registrationNumber = 'blue'; 
      company.numberOfEmployees = 'cabinet'; 
      company.websiteUrl = 'salary'; 
    var companyPlatformRole = managerModel.platformRoles.random(); 
    company.platformRole = companyPlatformRole; 
    var companyTenantRole = managerModel.tenantRoles.random(); 
    company.tenantRole = companyTenantRole; 
    var companyPlatform = managerModel.platforms.random(); 
    company.platform = companyPlatform; 
      companies.add(company); 
    companyPlatformRole.companies.add(company); 
    companyTenantRole.companies.add(company); 
    companyPlatform.companies.add(company); 
      expect(companies.length, equals(++companyCount)); 
      companies.remove(company); 
      expect(companies.length, equals(--companyCount)); 
 
      var action = AddCommand(session, companies, company); 
      action.doIt(); 
      expect(companies.length, equals(++companyCount)); 
 
      session.past.undo(); 
      expect(companies.length, equals(--companyCount)); 
 
      session.past.redo(); 
      expect(companies.length, equals(++companyCount)); 
    }); 
 
    test("Company update undo and redo", () { 
      var company = managerModel.companies.random(); 
      var action = SetAttributeCommand(session, company, "name", 'agile'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(company.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(company.name, equals(action.after)); 
    }); 
 
    test("Company action with multiple undos and redos", () { 
      var companyCount = companies.length; 
      var company1 = managerModel.companies.random(); 
 
      var action1 = RemoveCommand(session, companies, company1); 
      action1.doIt(); 
      expect(companies.length, equals(--companyCount)); 
 
      var company2 = managerModel.companies.random(); 
 
      var action2 = RemoveCommand(session, companies, company2); 
      action2.doIt(); 
      expect(companies.length, equals(--companyCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(companies.length, equals(++companyCount)); 
 
      session.past.undo(); 
      expect(companies.length, equals(++companyCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(companies.length, equals(--companyCount)); 
 
      session.past.redo(); 
      expect(companies.length, equals(--companyCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var companyCount = companies.length; 
      var company1 = managerModel.companies.random(); 
      var company2 = managerModel.companies.random(); 
      while (company1 == company2) { 
        company2 = managerModel.companies.random();  
      } 
      var action1 = RemoveCommand(session, companies, company1); 
      var action2 = RemoveCommand(session, companies, company2); 
 
      var transaction = new Transaction("two removes on companies", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      companyCount = companyCount - 2; 
      expect(companies.length, equals(companyCount)); 
 
      companies.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      companyCount = companyCount + 2; 
      expect(companies.length, equals(companyCount)); 
 
      companies.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      companyCount = companyCount - 2; 
      expect(companies.length, equals(companyCount)); 
 
      companies.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var companyCount = companies.length; 
      var company1 = managerModel.companies.random(); 
      var company2 = company1; 
      var action1 = RemoveCommand(session, companies, company1); 
      var action2 = RemoveCommand(session, companies, company2); 
 
      var transaction = Transaction( 
        "two removes on companies, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(companies.length, equals(companyCount)); 
 
      //companies.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to company actions", () { 
      var companyCount = companies.length; 
 
      var reaction = CompanyReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var company = Company(companies.concept); 
        company.name = 'river'; 
      company.role = 'hospital'; 
      company.address = 'autobus'; 
      company.uidNumber = 'word'; 
      company.registrationNumber = 'flower'; 
      company.numberOfEmployees = 'water'; 
      company.websiteUrl = 'training'; 
    var companyPlatformRole = managerModel.platformRoles.random(); 
    company.platformRole = companyPlatformRole; 
    var companyTenantRole = managerModel.tenantRoles.random(); 
    company.tenantRole = companyTenantRole; 
    var companyPlatform = managerModel.platforms.random(); 
    company.platform = companyPlatform; 
      companies.add(company); 
    companyPlatformRole.companies.add(company); 
    companyTenantRole.companies.add(company); 
    companyPlatform.companies.add(company); 
      expect(companies.length, equals(++companyCount)); 
      companies.remove(company); 
      expect(companies.length, equals(--companyCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, companies, company); 
      addCommand.doIt(); 
      expect(companies.length, equals(++companyCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, company, "name", 'election'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class CompanyReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  var repository = Repository(); 
  SomDomain somDomain = repository.getDomainModels("Som") as SomDomain;   
  assert(somDomain != null); 
  ManagerModel managerModel = somDomain.getModelEntries("Manager") as ManagerModel;  
  assert(managerModel != null); 
  var companies = managerModel.companies; 
  testSomManagerCompanies(somDomain, managerModel, companies); 
} 
 
