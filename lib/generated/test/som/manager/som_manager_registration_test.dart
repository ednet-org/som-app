 
// test/som/manager/som_manager_registration_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerRegistrations( 
    SomDomain somDomain, ManagerModel managerModel, Registrations registrations) { 
  DomainSession session; 
  group("Testing Som.Manager.Registration", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(registrations.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(registrations.isEmpty, isTrue); 
      expect(registrations.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("Registration"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Registration"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Registration"); 
      registrations.clear(); 
      expect(registrations.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(registrations.isEmpty, isFalse); 
 
      registrations.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add registration required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add registration unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found registration by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var registration = registrations.singleWhereOid(ednetOid); 
      expect(registration, isNull); 
    }); 
 
    test("Find registration by oid", () { 
      var randomRegistration = managerModel.registrations.random(); 
      var registration = registrations.singleWhereOid(randomRegistration.oid); 
      expect(registration, isNotNull); 
      expect(registration, equals(randomRegistration)); 
    }); 
 
    test("Find registration by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find registration by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find registration by attribute", () { 
      var randomRegistration = managerModel.registrations.random(); 
      var registration = 
          registrations.firstWhereAttribute("company", randomRegistration.company); 
      expect(registration, isNotNull); 
      expect(registration.company, equals(randomRegistration.company)); 
    }); 
 
    test("Select registrations by attribute", () { 
      var randomRegistration = managerModel.registrations.random(); 
      var selectedRegistrations = 
          registrations.selectWhereAttribute("company", randomRegistration.company); 
      expect(selectedRegistrations.isEmpty, isFalse); 
      selectedRegistrations.forEach((se) => 
          expect(se.company, equals(randomRegistration.company))); 
 
      //selectedRegistrations.display(title: "Select registrations by company"); 
    }); 
 
    test("Select registrations by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select registrations by attribute, then add", () { 
      var randomRegistration = managerModel.registrations.random(); 
      var selectedRegistrations = 
          registrations.selectWhereAttribute("company", randomRegistration.company); 
      expect(selectedRegistrations.isEmpty, isFalse); 
      expect(selectedRegistrations.source?.isEmpty, isFalse); 
      var registrationsCount = registrations.length; 
 
      var registration = Registration(registrations.concept); 
      registration.company = 'truck'; 
      registration.user = 'line'; 
      registration.platformRole = 'blue'; 
      var added = selectedRegistrations.add(registration); 
      expect(added, isTrue); 
      expect(registrations.length, equals(++registrationsCount)); 
 
      //selectedRegistrations.display(title: 
      //  "Select registrations by attribute, then add"); 
      //registrations.display(title: "All registrations"); 
    }); 
 
    test("Select registrations by attribute, then remove", () { 
      var randomRegistration = managerModel.registrations.random(); 
      var selectedRegistrations = 
          registrations.selectWhereAttribute("company", randomRegistration.company); 
      expect(selectedRegistrations.isEmpty, isFalse); 
      expect(selectedRegistrations.source?.isEmpty, isFalse); 
      var registrationsCount = registrations.length; 
 
      var removed = selectedRegistrations.remove(randomRegistration); 
      expect(removed, isTrue); 
      expect(registrations.length, equals(--registrationsCount)); 
 
      randomRegistration.display(prefix: "removed"); 
      //selectedRegistrations.display(title: 
      //  "Select registrations by attribute, then remove"); 
      //registrations.display(title: "All registrations"); 
    }); 
 
    test("Sort registrations", () { 
      // no id attribute 
      // add compareTo method in the specific Registration class 
      /* 
      registrations.sort(); 
 
      //registrations.display(title: "Sort registrations"); 
      */ 
    }); 
 
    test("Order registrations", () { 
      // no id attribute 
      // add compareTo method in the specific Registration class 
      /* 
      var orderedRegistrations = registrations.order(); 
      expect(orderedRegistrations.isEmpty, isFalse); 
      expect(orderedRegistrations.length, equals(registrations.length)); 
      expect(orderedRegistrations.source?.isEmpty, isFalse); 
      expect(orderedRegistrations.source?.length, equals(registrations.length)); 
      expect(orderedRegistrations, isNot(same(registrations))); 
 
      //orderedRegistrations.display(title: "Order registrations"); 
      */ 
    }); 
 
    test("Copy registrations", () { 
      var copiedRegistrations = registrations.copy(); 
      expect(copiedRegistrations.isEmpty, isFalse); 
      expect(copiedRegistrations.length, equals(registrations.length)); 
      expect(copiedRegistrations, isNot(same(registrations))); 
      copiedRegistrations.forEach((e) => 
        expect(e, equals(registrations.singleWhereOid(e.oid)))); 
 
      //copiedRegistrations.display(title: "Copy registrations"); 
    }); 
 
    test("True for every registration", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random registration", () { 
      var registration1 = managerModel.registrations.random(); 
      expect(registration1, isNotNull); 
      var registration2 = managerModel.registrations.random(); 
      expect(registration2, isNotNull); 
 
      //registration1.display(prefix: "random1"); 
      //registration2.display(prefix: "random2"); 
    }); 
 
    test("Update registration id with try", () { 
      // no id attribute 
    }); 
 
    test("Update registration id without try", () { 
      // no id attribute 
    }); 
 
    test("Update registration id with success", () { 
      // no id attribute 
    }); 
 
    test("Update registration non id attribute with failure", () { 
      var randomRegistration = managerModel.registrations.random(); 
      var afterUpdateEntity = randomRegistration.copy(); 
      afterUpdateEntity.company = 'music'; 
      expect(afterUpdateEntity.company, equals('music')); 
      // registrations.update can only be used if oid, code or id is set. 
      expect(() => registrations.update(randomRegistration, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomRegistration = managerModel.registrations.random(); 
      randomRegistration.display(prefix:"before copy: "); 
      var randomRegistrationCopy = randomRegistration.copy(); 
      randomRegistrationCopy.display(prefix:"after copy: "); 
      expect(randomRegistration, equals(randomRegistrationCopy)); 
      expect(randomRegistration.oid, equals(randomRegistrationCopy.oid)); 
      expect(randomRegistration.code, equals(randomRegistrationCopy.code)); 
      expect(randomRegistration.company, equals(randomRegistrationCopy.company)); 
      expect(randomRegistration.user, equals(randomRegistrationCopy.user)); 
      expect(randomRegistration.platformRole, equals(randomRegistrationCopy.platformRole)); 
 
    }); 
 
    test("registration action undo and redo", () { 
      var registrationCount = registrations.length; 
      var registration = Registration(registrations.concept); 
        registration.company = 'entertainment'; 
      registration.user = 'email'; 
      registration.platformRole = 'judge'; 
      registrations.add(registration); 
      expect(registrations.length, equals(++registrationCount)); 
      registrations.remove(registration); 
      expect(registrations.length, equals(--registrationCount)); 
 
      var action = AddCommand(session, registrations, registration); 
      action.doIt(); 
      expect(registrations.length, equals(++registrationCount)); 
 
      action.undo(); 
      expect(registrations.length, equals(--registrationCount)); 
 
      action.redo(); 
      expect(registrations.length, equals(++registrationCount)); 
    }); 
 
    test("registration session undo and redo", () { 
      var registrationCount = registrations.length; 
      var registration = Registration(registrations.concept); 
        registration.company = 'cream'; 
      registration.user = 'circle'; 
      registration.platformRole = 'edition'; 
      registrations.add(registration); 
      expect(registrations.length, equals(++registrationCount)); 
      registrations.remove(registration); 
      expect(registrations.length, equals(--registrationCount)); 
 
      var action = AddCommand(session, registrations, registration); 
      action.doIt(); 
      expect(registrations.length, equals(++registrationCount)); 
 
      session.past.undo(); 
      expect(registrations.length, equals(--registrationCount)); 
 
      session.past.redo(); 
      expect(registrations.length, equals(++registrationCount)); 
    }); 
 
    test("Registration update undo and redo", () { 
      var registration = managerModel.registrations.random(); 
      var action = SetAttributeCommand(session, registration, "company", 'table'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(registration.company, equals(action.before)); 
 
      session.past.redo(); 
      expect(registration.company, equals(action.after)); 
    }); 
 
    test("Registration action with multiple undos and redos", () { 
      var registrationCount = registrations.length; 
      var registration1 = managerModel.registrations.random(); 
 
      var action1 = RemoveCommand(session, registrations, registration1); 
      action1.doIt(); 
      expect(registrations.length, equals(--registrationCount)); 
 
      var registration2 = managerModel.registrations.random(); 
 
      var action2 = RemoveCommand(session, registrations, registration2); 
      action2.doIt(); 
      expect(registrations.length, equals(--registrationCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(registrations.length, equals(++registrationCount)); 
 
      session.past.undo(); 
      expect(registrations.length, equals(++registrationCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(registrations.length, equals(--registrationCount)); 
 
      session.past.redo(); 
      expect(registrations.length, equals(--registrationCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var registrationCount = registrations.length; 
      var registration1 = managerModel.registrations.random(); 
      var registration2 = managerModel.registrations.random(); 
      while (registration1 == registration2) { 
        registration2 = managerModel.registrations.random();  
      } 
      var action1 = RemoveCommand(session, registrations, registration1); 
      var action2 = RemoveCommand(session, registrations, registration2); 
 
      var transaction = new Transaction("two removes on registrations", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      registrationCount = registrationCount - 2; 
      expect(registrations.length, equals(registrationCount)); 
 
      registrations.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      registrationCount = registrationCount + 2; 
      expect(registrations.length, equals(registrationCount)); 
 
      registrations.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      registrationCount = registrationCount - 2; 
      expect(registrations.length, equals(registrationCount)); 
 
      registrations.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var registrationCount = registrations.length; 
      var registration1 = managerModel.registrations.random(); 
      var registration2 = registration1; 
      var action1 = RemoveCommand(session, registrations, registration1); 
      var action2 = RemoveCommand(session, registrations, registration2); 
 
      var transaction = Transaction( 
        "two removes on registrations, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(registrations.length, equals(registrationCount)); 
 
      //registrations.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to registration actions", () { 
      var registrationCount = registrations.length; 
 
      var reaction = RegistrationReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var registration = Registration(registrations.concept); 
        registration.company = 'message'; 
      registration.user = 'lake'; 
      registration.platformRole = 'redo'; 
      registrations.add(registration); 
      expect(registrations.length, equals(++registrationCount)); 
      registrations.remove(registration); 
      expect(registrations.length, equals(--registrationCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, registrations, registration); 
      addCommand.doIt(); 
      expect(registrations.length, equals(++registrationCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, registration, "company", 'cash'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class RegistrationReaction implements ICommandReaction { 
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
  var registrations = managerModel.registrations; 
  testSomManagerRegistrations(somDomain, managerModel, registrations); 
} 
 
