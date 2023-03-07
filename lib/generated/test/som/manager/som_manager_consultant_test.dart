 
// test/som/manager/som_manager_consultant_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerConsultants( 
    SomDomain somDomain, ManagerModel managerModel, Consultants consultants) { 
  DomainSession session; 
  group("Testing Som.Manager.Consultant", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(consultants.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(consultants.isEmpty, isTrue); 
      expect(consultants.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("Consultant"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Consultant"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Consultant"); 
      consultants.clear(); 
      expect(consultants.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(consultants.isEmpty, isFalse); 
 
      consultants.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add consultant required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add consultant unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found consultant by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var consultant = consultants.singleWhereOid(ednetOid); 
      expect(consultant, isNull); 
    }); 
 
    test("Find consultant by oid", () { 
      var randomConsultant = managerModel.consultants.random(); 
      var consultant = consultants.singleWhereOid(randomConsultant.oid); 
      expect(consultant, isNotNull); 
      expect(consultant, equals(randomConsultant)); 
    }); 
 
    test("Find consultant by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find consultant by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find consultant by attribute", () { 
      var randomConsultant = managerModel.consultants.random(); 
      var consultant = 
          consultants.firstWhereAttribute("user", randomConsultant.user); 
      expect(consultant, isNotNull); 
      expect(consultant.user, equals(randomConsultant.user)); 
    }); 
 
    test("Select consultants by attribute", () { 
      var randomConsultant = managerModel.consultants.random(); 
      var selectedConsultants = 
          consultants.selectWhereAttribute("user", randomConsultant.user); 
      expect(selectedConsultants.isEmpty, isFalse); 
      selectedConsultants.forEach((se) => 
          expect(se.user, equals(randomConsultant.user))); 
 
      //selectedConsultants.display(title: "Select consultants by user"); 
    }); 
 
    test("Select consultants by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select consultants by attribute, then add", () { 
      var randomConsultant = managerModel.consultants.random(); 
      var selectedConsultants = 
          consultants.selectWhereAttribute("user", randomConsultant.user); 
      expect(selectedConsultants.isEmpty, isFalse); 
      expect(selectedConsultants.source?.isEmpty, isFalse); 
      var consultantsCount = consultants.length; 
 
      var consultant = Consultant(consultants.concept); 
      consultant.user = 'yellow'; 
      var added = selectedConsultants.add(consultant); 
      expect(added, isTrue); 
      expect(consultants.length, equals(++consultantsCount)); 
 
      //selectedConsultants.display(title: 
      //  "Select consultants by attribute, then add"); 
      //consultants.display(title: "All consultants"); 
    }); 
 
    test("Select consultants by attribute, then remove", () { 
      var randomConsultant = managerModel.consultants.random(); 
      var selectedConsultants = 
          consultants.selectWhereAttribute("user", randomConsultant.user); 
      expect(selectedConsultants.isEmpty, isFalse); 
      expect(selectedConsultants.source?.isEmpty, isFalse); 
      var consultantsCount = consultants.length; 
 
      var removed = selectedConsultants.remove(randomConsultant); 
      expect(removed, isTrue); 
      expect(consultants.length, equals(--consultantsCount)); 
 
      randomConsultant.display(prefix: "removed"); 
      //selectedConsultants.display(title: 
      //  "Select consultants by attribute, then remove"); 
      //consultants.display(title: "All consultants"); 
    }); 
 
    test("Sort consultants", () { 
      // no id attribute 
      // add compareTo method in the specific Consultant class 
      /* 
      consultants.sort(); 
 
      //consultants.display(title: "Sort consultants"); 
      */ 
    }); 
 
    test("Order consultants", () { 
      // no id attribute 
      // add compareTo method in the specific Consultant class 
      /* 
      var orderedConsultants = consultants.order(); 
      expect(orderedConsultants.isEmpty, isFalse); 
      expect(orderedConsultants.length, equals(consultants.length)); 
      expect(orderedConsultants.source?.isEmpty, isFalse); 
      expect(orderedConsultants.source?.length, equals(consultants.length)); 
      expect(orderedConsultants, isNot(same(consultants))); 
 
      //orderedConsultants.display(title: "Order consultants"); 
      */ 
    }); 
 
    test("Copy consultants", () { 
      var copiedConsultants = consultants.copy(); 
      expect(copiedConsultants.isEmpty, isFalse); 
      expect(copiedConsultants.length, equals(consultants.length)); 
      expect(copiedConsultants, isNot(same(consultants))); 
      copiedConsultants.forEach((e) => 
        expect(e, equals(consultants.singleWhereOid(e.oid)))); 
 
      //copiedConsultants.display(title: "Copy consultants"); 
    }); 
 
    test("True for every consultant", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random consultant", () { 
      var consultant1 = managerModel.consultants.random(); 
      expect(consultant1, isNotNull); 
      var consultant2 = managerModel.consultants.random(); 
      expect(consultant2, isNotNull); 
 
      //consultant1.display(prefix: "random1"); 
      //consultant2.display(prefix: "random2"); 
    }); 
 
    test("Update consultant id with try", () { 
      // no id attribute 
    }); 
 
    test("Update consultant id without try", () { 
      // no id attribute 
    }); 
 
    test("Update consultant id with success", () { 
      // no id attribute 
    }); 
 
    test("Update consultant non id attribute with failure", () { 
      var randomConsultant = managerModel.consultants.random(); 
      var afterUpdateEntity = randomConsultant.copy(); 
      afterUpdateEntity.user = 'account'; 
      expect(afterUpdateEntity.user, equals('account')); 
      // consultants.update can only be used if oid, code or id is set. 
      expect(() => consultants.update(randomConsultant, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomConsultant = managerModel.consultants.random(); 
      randomConsultant.display(prefix:"before copy: "); 
      var randomConsultantCopy = randomConsultant.copy(); 
      randomConsultantCopy.display(prefix:"after copy: "); 
      expect(randomConsultant, equals(randomConsultantCopy)); 
      expect(randomConsultant.oid, equals(randomConsultantCopy.oid)); 
      expect(randomConsultant.code, equals(randomConsultantCopy.code)); 
      expect(randomConsultant.user, equals(randomConsultantCopy.user)); 
 
    }); 
 
    test("consultant action undo and redo", () { 
      var consultantCount = consultants.length; 
      var consultant = Consultant(consultants.concept); 
        consultant.user = 'done'; 
    var consultantPlatform = managerModel.platforms.random(); 
    consultant.platform = consultantPlatform; 
      consultants.add(consultant); 
    consultantPlatform.consultants.add(consultant); 
      expect(consultants.length, equals(++consultantCount)); 
      consultants.remove(consultant); 
      expect(consultants.length, equals(--consultantCount)); 
 
      var action = AddCommand(session, consultants, consultant); 
      action.doIt(); 
      expect(consultants.length, equals(++consultantCount)); 
 
      action.undo(); 
      expect(consultants.length, equals(--consultantCount)); 
 
      action.redo(); 
      expect(consultants.length, equals(++consultantCount)); 
    }); 
 
    test("consultant session undo and redo", () { 
      var consultantCount = consultants.length; 
      var consultant = Consultant(consultants.concept); 
        consultant.user = 'saving'; 
    var consultantPlatform = managerModel.platforms.random(); 
    consultant.platform = consultantPlatform; 
      consultants.add(consultant); 
    consultantPlatform.consultants.add(consultant); 
      expect(consultants.length, equals(++consultantCount)); 
      consultants.remove(consultant); 
      expect(consultants.length, equals(--consultantCount)); 
 
      var action = AddCommand(session, consultants, consultant); 
      action.doIt(); 
      expect(consultants.length, equals(++consultantCount)); 
 
      session.past.undo(); 
      expect(consultants.length, equals(--consultantCount)); 
 
      session.past.redo(); 
      expect(consultants.length, equals(++consultantCount)); 
    }); 
 
    test("Consultant update undo and redo", () { 
      var consultant = managerModel.consultants.random(); 
      var action = SetAttributeCommand(session, consultant, "user", 'picture'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(consultant.user, equals(action.before)); 
 
      session.past.redo(); 
      expect(consultant.user, equals(action.after)); 
    }); 
 
    test("Consultant action with multiple undos and redos", () { 
      var consultantCount = consultants.length; 
      var consultant1 = managerModel.consultants.random(); 
 
      var action1 = RemoveCommand(session, consultants, consultant1); 
      action1.doIt(); 
      expect(consultants.length, equals(--consultantCount)); 
 
      var consultant2 = managerModel.consultants.random(); 
 
      var action2 = RemoveCommand(session, consultants, consultant2); 
      action2.doIt(); 
      expect(consultants.length, equals(--consultantCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(consultants.length, equals(++consultantCount)); 
 
      session.past.undo(); 
      expect(consultants.length, equals(++consultantCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(consultants.length, equals(--consultantCount)); 
 
      session.past.redo(); 
      expect(consultants.length, equals(--consultantCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var consultantCount = consultants.length; 
      var consultant1 = managerModel.consultants.random(); 
      var consultant2 = managerModel.consultants.random(); 
      while (consultant1 == consultant2) { 
        consultant2 = managerModel.consultants.random();  
      } 
      var action1 = RemoveCommand(session, consultants, consultant1); 
      var action2 = RemoveCommand(session, consultants, consultant2); 
 
      var transaction = new Transaction("two removes on consultants", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      consultantCount = consultantCount - 2; 
      expect(consultants.length, equals(consultantCount)); 
 
      consultants.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      consultantCount = consultantCount + 2; 
      expect(consultants.length, equals(consultantCount)); 
 
      consultants.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      consultantCount = consultantCount - 2; 
      expect(consultants.length, equals(consultantCount)); 
 
      consultants.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var consultantCount = consultants.length; 
      var consultant1 = managerModel.consultants.random(); 
      var consultant2 = consultant1; 
      var action1 = RemoveCommand(session, consultants, consultant1); 
      var action2 = RemoveCommand(session, consultants, consultant2); 
 
      var transaction = Transaction( 
        "two removes on consultants, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(consultants.length, equals(consultantCount)); 
 
      //consultants.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to consultant actions", () { 
      var consultantCount = consultants.length; 
 
      var reaction = ConsultantReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var consultant = Consultant(consultants.concept); 
        consultant.user = 'point'; 
    var consultantPlatform = managerModel.platforms.random(); 
    consultant.platform = consultantPlatform; 
      consultants.add(consultant); 
    consultantPlatform.consultants.add(consultant); 
      expect(consultants.length, equals(++consultantCount)); 
      consultants.remove(consultant); 
      expect(consultants.length, equals(--consultantCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, consultants, consultant); 
      addCommand.doIt(); 
      expect(consultants.length, equals(++consultantCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, consultant, "user", 'meter'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ConsultantReaction implements ICommandReaction { 
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
  var consultants = managerModel.consultants; 
  testSomManagerConsultants(somDomain, managerModel, consultants); 
} 
 
