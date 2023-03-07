 
// test/som/manager/som_manager_offer_provider_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerOfferProviders( 
    SomDomain somDomain, ManagerModel managerModel, OfferProviders offerProviders) { 
  DomainSession session; 
  group("Testing Som.Manager.OfferProvider", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(offerProviders.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(offerProviders.isEmpty, isTrue); 
      expect(offerProviders.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("OfferProvider"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("OfferProvider"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("OfferProvider"); 
      offerProviders.clear(); 
      expect(offerProviders.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(offerProviders.isEmpty, isFalse); 
 
      offerProviders.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add offerProvider required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add offerProvider unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found offerProvider by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var offerProvider = offerProviders.singleWhereOid(ednetOid); 
      expect(offerProvider, isNull); 
    }); 
 
    test("Find offerProvider by oid", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      var offerProvider = offerProviders.singleWhereOid(randomOfferProvider.oid); 
      expect(offerProvider, isNotNull); 
      expect(offerProvider, equals(randomOfferProvider)); 
    }); 
 
    test("Find offerProvider by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find offerProvider by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find offerProvider by attribute", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      var offerProvider = 
          offerProviders.firstWhereAttribute("company", randomOfferProvider.company); 
      expect(offerProvider, isNotNull); 
      expect(offerProvider.company, equals(randomOfferProvider.company)); 
    }); 
 
    test("Select offerProviders by attribute", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      var selectedOfferProviders = 
          offerProviders.selectWhereAttribute("company", randomOfferProvider.company); 
      expect(selectedOfferProviders.isEmpty, isFalse); 
      selectedOfferProviders.forEach((se) => 
          expect(se.company, equals(randomOfferProvider.company))); 
 
      //selectedOfferProviders.display(title: "Select offerProviders by company"); 
    }); 
 
    test("Select offerProviders by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select offerProviders by attribute, then add", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      var selectedOfferProviders = 
          offerProviders.selectWhereAttribute("company", randomOfferProvider.company); 
      expect(selectedOfferProviders.isEmpty, isFalse); 
      expect(selectedOfferProviders.source?.isEmpty, isFalse); 
      var offerProvidersCount = offerProviders.length; 
 
      var offerProvider = OfferProvider(offerProviders.concept); 
      offerProvider.company = 'corner'; 
      offerProvider.user = 'car'; 
      var added = selectedOfferProviders.add(offerProvider); 
      expect(added, isTrue); 
      expect(offerProviders.length, equals(++offerProvidersCount)); 
 
      //selectedOfferProviders.display(title: 
      //  "Select offerProviders by attribute, then add"); 
      //offerProviders.display(title: "All offerProviders"); 
    }); 
 
    test("Select offerProviders by attribute, then remove", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      var selectedOfferProviders = 
          offerProviders.selectWhereAttribute("company", randomOfferProvider.company); 
      expect(selectedOfferProviders.isEmpty, isFalse); 
      expect(selectedOfferProviders.source?.isEmpty, isFalse); 
      var offerProvidersCount = offerProviders.length; 
 
      var removed = selectedOfferProviders.remove(randomOfferProvider); 
      expect(removed, isTrue); 
      expect(offerProviders.length, equals(--offerProvidersCount)); 
 
      randomOfferProvider.display(prefix: "removed"); 
      //selectedOfferProviders.display(title: 
      //  "Select offerProviders by attribute, then remove"); 
      //offerProviders.display(title: "All offerProviders"); 
    }); 
 
    test("Sort offerProviders", () { 
      // no id attribute 
      // add compareTo method in the specific OfferProvider class 
      /* 
      offerProviders.sort(); 
 
      //offerProviders.display(title: "Sort offerProviders"); 
      */ 
    }); 
 
    test("Order offerProviders", () { 
      // no id attribute 
      // add compareTo method in the specific OfferProvider class 
      /* 
      var orderedOfferProviders = offerProviders.order(); 
      expect(orderedOfferProviders.isEmpty, isFalse); 
      expect(orderedOfferProviders.length, equals(offerProviders.length)); 
      expect(orderedOfferProviders.source?.isEmpty, isFalse); 
      expect(orderedOfferProviders.source?.length, equals(offerProviders.length)); 
      expect(orderedOfferProviders, isNot(same(offerProviders))); 
 
      //orderedOfferProviders.display(title: "Order offerProviders"); 
      */ 
    }); 
 
    test("Copy offerProviders", () { 
      var copiedOfferProviders = offerProviders.copy(); 
      expect(copiedOfferProviders.isEmpty, isFalse); 
      expect(copiedOfferProviders.length, equals(offerProviders.length)); 
      expect(copiedOfferProviders, isNot(same(offerProviders))); 
      copiedOfferProviders.forEach((e) => 
        expect(e, equals(offerProviders.singleWhereOid(e.oid)))); 
 
      //copiedOfferProviders.display(title: "Copy offerProviders"); 
    }); 
 
    test("True for every offerProvider", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random offerProvider", () { 
      var offerProvider1 = managerModel.offerProviders.random(); 
      expect(offerProvider1, isNotNull); 
      var offerProvider2 = managerModel.offerProviders.random(); 
      expect(offerProvider2, isNotNull); 
 
      //offerProvider1.display(prefix: "random1"); 
      //offerProvider2.display(prefix: "random2"); 
    }); 
 
    test("Update offerProvider id with try", () { 
      // no id attribute 
    }); 
 
    test("Update offerProvider id without try", () { 
      // no id attribute 
    }); 
 
    test("Update offerProvider id with success", () { 
      // no id attribute 
    }); 
 
    test("Update offerProvider non id attribute with failure", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      var afterUpdateEntity = randomOfferProvider.copy(); 
      afterUpdateEntity.company = 'authority'; 
      expect(afterUpdateEntity.company, equals('authority')); 
      // offerProviders.update can only be used if oid, code or id is set. 
      expect(() => offerProviders.update(randomOfferProvider, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomOfferProvider = managerModel.offerProviders.random(); 
      randomOfferProvider.display(prefix:"before copy: "); 
      var randomOfferProviderCopy = randomOfferProvider.copy(); 
      randomOfferProviderCopy.display(prefix:"after copy: "); 
      expect(randomOfferProvider, equals(randomOfferProviderCopy)); 
      expect(randomOfferProvider.oid, equals(randomOfferProviderCopy.oid)); 
      expect(randomOfferProvider.code, equals(randomOfferProviderCopy.code)); 
      expect(randomOfferProvider.company, equals(randomOfferProviderCopy.company)); 
      expect(randomOfferProvider.user, equals(randomOfferProviderCopy.user)); 
 
    }); 
 
    test("offerProvider action undo and redo", () { 
      var offerProviderCount = offerProviders.length; 
      var offerProvider = OfferProvider(offerProviders.concept); 
        offerProvider.company = 'big'; 
      offerProvider.user = 'rice'; 
      offerProviders.add(offerProvider); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
      offerProviders.remove(offerProvider); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      var action = AddCommand(session, offerProviders, offerProvider); 
      action.doIt(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
 
      action.undo(); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      action.redo(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
    }); 
 
    test("offerProvider session undo and redo", () { 
      var offerProviderCount = offerProviders.length; 
      var offerProvider = OfferProvider(offerProviders.concept); 
        offerProvider.company = 'concern'; 
      offerProvider.user = 'family'; 
      offerProviders.add(offerProvider); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
      offerProviders.remove(offerProvider); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      var action = AddCommand(session, offerProviders, offerProvider); 
      action.doIt(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
 
      session.past.undo(); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      session.past.redo(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
    }); 
 
    test("OfferProvider update undo and redo", () { 
      var offerProvider = managerModel.offerProviders.random(); 
      var action = SetAttributeCommand(session, offerProvider, "company", 'house'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(offerProvider.company, equals(action.before)); 
 
      session.past.redo(); 
      expect(offerProvider.company, equals(action.after)); 
    }); 
 
    test("OfferProvider action with multiple undos and redos", () { 
      var offerProviderCount = offerProviders.length; 
      var offerProvider1 = managerModel.offerProviders.random(); 
 
      var action1 = RemoveCommand(session, offerProviders, offerProvider1); 
      action1.doIt(); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      var offerProvider2 = managerModel.offerProviders.random(); 
 
      var action2 = RemoveCommand(session, offerProviders, offerProvider2); 
      action2.doIt(); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
 
      session.past.undo(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      session.past.redo(); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var offerProviderCount = offerProviders.length; 
      var offerProvider1 = managerModel.offerProviders.random(); 
      var offerProvider2 = managerModel.offerProviders.random(); 
      while (offerProvider1 == offerProvider2) { 
        offerProvider2 = managerModel.offerProviders.random();  
      } 
      var action1 = RemoveCommand(session, offerProviders, offerProvider1); 
      var action2 = RemoveCommand(session, offerProviders, offerProvider2); 
 
      var transaction = new Transaction("two removes on offerProviders", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      offerProviderCount = offerProviderCount - 2; 
      expect(offerProviders.length, equals(offerProviderCount)); 
 
      offerProviders.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      offerProviderCount = offerProviderCount + 2; 
      expect(offerProviders.length, equals(offerProviderCount)); 
 
      offerProviders.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      offerProviderCount = offerProviderCount - 2; 
      expect(offerProviders.length, equals(offerProviderCount)); 
 
      offerProviders.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var offerProviderCount = offerProviders.length; 
      var offerProvider1 = managerModel.offerProviders.random(); 
      var offerProvider2 = offerProvider1; 
      var action1 = RemoveCommand(session, offerProviders, offerProvider1); 
      var action2 = RemoveCommand(session, offerProviders, offerProvider2); 
 
      var transaction = Transaction( 
        "two removes on offerProviders, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(offerProviders.length, equals(offerProviderCount)); 
 
      //offerProviders.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to offerProvider actions", () { 
      var offerProviderCount = offerProviders.length; 
 
      var reaction = OfferProviderReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var offerProvider = OfferProvider(offerProviders.concept); 
        offerProvider.company = 'hunting'; 
      offerProvider.user = 'agreement'; 
      offerProviders.add(offerProvider); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
      offerProviders.remove(offerProvider); 
      expect(offerProviders.length, equals(--offerProviderCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, offerProviders, offerProvider); 
      addCommand.doIt(); 
      expect(offerProviders.length, equals(++offerProviderCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, offerProvider, "company", 'milk'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class OfferProviderReaction implements ICommandReaction { 
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
  var offerProviders = managerModel.offerProviders; 
  testSomManagerOfferProviders(somDomain, managerModel, offerProviders); 
} 
 
