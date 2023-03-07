 
// test/som/manager/som_manager_buyer_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerBuyers( 
    SomDomain somDomain, ManagerModel managerModel, Buyers buyers) { 
  DomainSession session; 
  group("Testing Som.Manager.Buyer", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(buyers.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(buyers.isEmpty, isTrue); 
      expect(buyers.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("Buyer"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Buyer"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Buyer"); 
      buyers.clear(); 
      expect(buyers.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(buyers.isEmpty, isFalse); 
 
      buyers.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add buyer required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add buyer unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found buyer by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var buyer = buyers.singleWhereOid(ednetOid); 
      expect(buyer, isNull); 
    }); 
 
    test("Find buyer by oid", () { 
      var randomBuyer = managerModel.buyers.random(); 
      var buyer = buyers.singleWhereOid(randomBuyer.oid); 
      expect(buyer, isNotNull); 
      expect(buyer, equals(randomBuyer)); 
    }); 
 
    test("Find buyer by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find buyer by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find buyer by attribute", () { 
      var randomBuyer = managerModel.buyers.random(); 
      var buyer = 
          buyers.firstWhereAttribute("user", randomBuyer.user); 
      expect(buyer, isNotNull); 
      expect(buyer.user, equals(randomBuyer.user)); 
    }); 
 
    test("Select buyers by attribute", () { 
      var randomBuyer = managerModel.buyers.random(); 
      var selectedBuyers = 
          buyers.selectWhereAttribute("user", randomBuyer.user); 
      expect(selectedBuyers.isEmpty, isFalse); 
      selectedBuyers.forEach((se) => 
          expect(se.user, equals(randomBuyer.user))); 
 
      //selectedBuyers.display(title: "Select buyers by user"); 
    }); 
 
    test("Select buyers by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select buyers by attribute, then add", () { 
      var randomBuyer = managerModel.buyers.random(); 
      var selectedBuyers = 
          buyers.selectWhereAttribute("user", randomBuyer.user); 
      expect(selectedBuyers.isEmpty, isFalse); 
      expect(selectedBuyers.source?.isEmpty, isFalse); 
      var buyersCount = buyers.length; 
 
      var buyer = Buyer(buyers.concept); 
      buyer.user = 'truck'; 
      var added = selectedBuyers.add(buyer); 
      expect(added, isTrue); 
      expect(buyers.length, equals(++buyersCount)); 
 
      //selectedBuyers.display(title: 
      //  "Select buyers by attribute, then add"); 
      //buyers.display(title: "All buyers"); 
    }); 
 
    test("Select buyers by attribute, then remove", () { 
      var randomBuyer = managerModel.buyers.random(); 
      var selectedBuyers = 
          buyers.selectWhereAttribute("user", randomBuyer.user); 
      expect(selectedBuyers.isEmpty, isFalse); 
      expect(selectedBuyers.source?.isEmpty, isFalse); 
      var buyersCount = buyers.length; 
 
      var removed = selectedBuyers.remove(randomBuyer); 
      expect(removed, isTrue); 
      expect(buyers.length, equals(--buyersCount)); 
 
      randomBuyer.display(prefix: "removed"); 
      //selectedBuyers.display(title: 
      //  "Select buyers by attribute, then remove"); 
      //buyers.display(title: "All buyers"); 
    }); 
 
    test("Sort buyers", () { 
      // no id attribute 
      // add compareTo method in the specific Buyer class 
      /* 
      buyers.sort(); 
 
      //buyers.display(title: "Sort buyers"); 
      */ 
    }); 
 
    test("Order buyers", () { 
      // no id attribute 
      // add compareTo method in the specific Buyer class 
      /* 
      var orderedBuyers = buyers.order(); 
      expect(orderedBuyers.isEmpty, isFalse); 
      expect(orderedBuyers.length, equals(buyers.length)); 
      expect(orderedBuyers.source?.isEmpty, isFalse); 
      expect(orderedBuyers.source?.length, equals(buyers.length)); 
      expect(orderedBuyers, isNot(same(buyers))); 
 
      //orderedBuyers.display(title: "Order buyers"); 
      */ 
    }); 
 
    test("Copy buyers", () { 
      var copiedBuyers = buyers.copy(); 
      expect(copiedBuyers.isEmpty, isFalse); 
      expect(copiedBuyers.length, equals(buyers.length)); 
      expect(copiedBuyers, isNot(same(buyers))); 
      copiedBuyers.forEach((e) => 
        expect(e, equals(buyers.singleWhereOid(e.oid)))); 
 
      //copiedBuyers.display(title: "Copy buyers"); 
    }); 
 
    test("True for every buyer", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random buyer", () { 
      var buyer1 = managerModel.buyers.random(); 
      expect(buyer1, isNotNull); 
      var buyer2 = managerModel.buyers.random(); 
      expect(buyer2, isNotNull); 
 
      //buyer1.display(prefix: "random1"); 
      //buyer2.display(prefix: "random2"); 
    }); 
 
    test("Update buyer id with try", () { 
      // no id attribute 
    }); 
 
    test("Update buyer id without try", () { 
      // no id attribute 
    }); 
 
    test("Update buyer id with success", () { 
      // no id attribute 
    }); 
 
    test("Update buyer non id attribute with failure", () { 
      var randomBuyer = managerModel.buyers.random(); 
      var afterUpdateEntity = randomBuyer.copy(); 
      afterUpdateEntity.user = 'celebration'; 
      expect(afterUpdateEntity.user, equals('celebration')); 
      // buyers.update can only be used if oid, code or id is set. 
      expect(() => buyers.update(randomBuyer, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomBuyer = managerModel.buyers.random(); 
      randomBuyer.display(prefix:"before copy: "); 
      var randomBuyerCopy = randomBuyer.copy(); 
      randomBuyerCopy.display(prefix:"after copy: "); 
      expect(randomBuyer, equals(randomBuyerCopy)); 
      expect(randomBuyer.oid, equals(randomBuyerCopy.oid)); 
      expect(randomBuyer.code, equals(randomBuyerCopy.code)); 
      expect(randomBuyer.user, equals(randomBuyerCopy.user)); 
 
    }); 
 
    test("buyer action undo and redo", () { 
      var buyerCount = buyers.length; 
      var buyer = Buyer(buyers.concept); 
        buyer.user = 'truck'; 
    var buyerRegistration = managerModel.registrations.random(); 
    buyer.registration = buyerRegistration; 
      buyers.add(buyer); 
    buyerRegistration.buyer.add(buyer); 
      expect(buyers.length, equals(++buyerCount)); 
      buyers.remove(buyer); 
      expect(buyers.length, equals(--buyerCount)); 
 
      var action = AddCommand(session, buyers, buyer); 
      action.doIt(); 
      expect(buyers.length, equals(++buyerCount)); 
 
      action.undo(); 
      expect(buyers.length, equals(--buyerCount)); 
 
      action.redo(); 
      expect(buyers.length, equals(++buyerCount)); 
    }); 
 
    test("buyer session undo and redo", () { 
      var buyerCount = buyers.length; 
      var buyer = Buyer(buyers.concept); 
        buyer.user = 'pattern'; 
    var buyerRegistration = managerModel.registrations.random(); 
    buyer.registration = buyerRegistration; 
      buyers.add(buyer); 
    buyerRegistration.buyer.add(buyer); 
      expect(buyers.length, equals(++buyerCount)); 
      buyers.remove(buyer); 
      expect(buyers.length, equals(--buyerCount)); 
 
      var action = AddCommand(session, buyers, buyer); 
      action.doIt(); 
      expect(buyers.length, equals(++buyerCount)); 
 
      session.past.undo(); 
      expect(buyers.length, equals(--buyerCount)); 
 
      session.past.redo(); 
      expect(buyers.length, equals(++buyerCount)); 
    }); 
 
    test("Buyer update undo and redo", () { 
      var buyer = managerModel.buyers.random(); 
      var action = SetAttributeCommand(session, buyer, "user", 'auto'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(buyer.user, equals(action.before)); 
 
      session.past.redo(); 
      expect(buyer.user, equals(action.after)); 
    }); 
 
    test("Buyer action with multiple undos and redos", () { 
      var buyerCount = buyers.length; 
      var buyer1 = managerModel.buyers.random(); 
 
      var action1 = RemoveCommand(session, buyers, buyer1); 
      action1.doIt(); 
      expect(buyers.length, equals(--buyerCount)); 
 
      var buyer2 = managerModel.buyers.random(); 
 
      var action2 = RemoveCommand(session, buyers, buyer2); 
      action2.doIt(); 
      expect(buyers.length, equals(--buyerCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(buyers.length, equals(++buyerCount)); 
 
      session.past.undo(); 
      expect(buyers.length, equals(++buyerCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(buyers.length, equals(--buyerCount)); 
 
      session.past.redo(); 
      expect(buyers.length, equals(--buyerCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var buyerCount = buyers.length; 
      var buyer1 = managerModel.buyers.random(); 
      var buyer2 = managerModel.buyers.random(); 
      while (buyer1 == buyer2) { 
        buyer2 = managerModel.buyers.random();  
      } 
      var action1 = RemoveCommand(session, buyers, buyer1); 
      var action2 = RemoveCommand(session, buyers, buyer2); 
 
      var transaction = new Transaction("two removes on buyers", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      buyerCount = buyerCount - 2; 
      expect(buyers.length, equals(buyerCount)); 
 
      buyers.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      buyerCount = buyerCount + 2; 
      expect(buyers.length, equals(buyerCount)); 
 
      buyers.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      buyerCount = buyerCount - 2; 
      expect(buyers.length, equals(buyerCount)); 
 
      buyers.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var buyerCount = buyers.length; 
      var buyer1 = managerModel.buyers.random(); 
      var buyer2 = buyer1; 
      var action1 = RemoveCommand(session, buyers, buyer1); 
      var action2 = RemoveCommand(session, buyers, buyer2); 
 
      var transaction = Transaction( 
        "two removes on buyers, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(buyers.length, equals(buyerCount)); 
 
      //buyers.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to buyer actions", () { 
      var buyerCount = buyers.length; 
 
      var reaction = BuyerReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var buyer = Buyer(buyers.concept); 
        buyer.user = 'tree'; 
    var buyerRegistration = managerModel.registrations.random(); 
    buyer.registration = buyerRegistration; 
      buyers.add(buyer); 
    buyerRegistration.buyer.add(buyer); 
      expect(buyers.length, equals(++buyerCount)); 
      buyers.remove(buyer); 
      expect(buyers.length, equals(--buyerCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, buyers, buyer); 
      addCommand.doIt(); 
      expect(buyers.length, equals(++buyerCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, buyer, "user", 'left'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class BuyerReaction implements ICommandReaction { 
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
  var buyers = managerModel.buyers; 
  testSomManagerBuyers(somDomain, managerModel, buyers); 
} 
 
