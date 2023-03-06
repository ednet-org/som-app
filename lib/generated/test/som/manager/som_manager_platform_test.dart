 
// test/som/manager/som_manager_platform_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerPlatforms( 
    SomDomain somDomain, ManagerModel managerModel, Platforms platforms) { 
  DomainSession session; 
  group("Testing Som.Manager.Platform", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(platforms.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(platforms.isEmpty, isTrue); 
      expect(platforms.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("Platform"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("Platform"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("Platform"); 
      platforms.clear(); 
      expect(platforms.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(platforms.isEmpty, isFalse); 
 
      platforms.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add platform required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add platform unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found platform by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var platform = platforms.singleWhereOid(ednetOid); 
      expect(platform, isNull); 
    }); 
 
    test("Find platform by oid", () { 
      var randomPlatform = platforms.random(); 
      var platform = platforms.singleWhereOid(randomPlatform.oid); 
      expect(platform, isNotNull); 
      expect(platform, equals(randomPlatform)); 
    }); 
 
    test("Find platform by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find platform by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find platform by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select platforms by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select platforms by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select platforms by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select platforms by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort platforms", () { 
      // no id attribute 
      // add compareTo method in the specific Platform class 
      /* 
      platforms.sort(); 
 
      //platforms.display(title: "Sort platforms"); 
      */ 
    }); 
 
    test("Order platforms", () { 
      // no id attribute 
      // add compareTo method in the specific Platform class 
      /* 
      var orderedPlatforms = platforms.order(); 
      expect(orderedPlatforms.isEmpty, isFalse); 
      expect(orderedPlatforms.length, equals(platforms.length)); 
      expect(orderedPlatforms.source?.isEmpty, isFalse); 
      expect(orderedPlatforms.source?.length, equals(platforms.length)); 
      expect(orderedPlatforms, isNot(same(platforms))); 
 
      //orderedPlatforms.display(title: "Order platforms"); 
      */ 
    }); 
 
    test("Copy platforms", () { 
      var copiedPlatforms = platforms.copy(); 
      expect(copiedPlatforms.isEmpty, isFalse); 
      expect(copiedPlatforms.length, equals(platforms.length)); 
      expect(copiedPlatforms, isNot(same(platforms))); 
      copiedPlatforms.forEach((e) => 
        expect(e, equals(platforms.singleWhereOid(e.oid)))); 
 
      //copiedPlatforms.display(title: "Copy platforms"); 
    }); 
 
    test("True for every platform", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random platform", () { 
      var platform1 = platforms.random(); 
      expect(platform1, isNotNull); 
      var platform2 = platforms.random(); 
      expect(platform2, isNotNull); 
 
      //platform1.display(prefix: "random1"); 
      //platform2.display(prefix: "random2"); 
    }); 
 
    test("Update platform id with try", () { 
      // no id attribute 
    }); 
 
    test("Update platform id without try", () { 
      // no id attribute 
    }); 
 
    test("Update platform id with success", () { 
      // no id attribute 
    }); 
 
    test("Update platform non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomPlatform = platforms.random(); 
      randomPlatform.display(prefix:"before copy: "); 
      var randomPlatformCopy = randomPlatform.copy(); 
      randomPlatformCopy.display(prefix:"after copy: "); 
      expect(randomPlatform, equals(randomPlatformCopy)); 
      expect(randomPlatform.oid, equals(randomPlatformCopy.oid)); 
      expect(randomPlatform.code, equals(randomPlatformCopy.code)); 
 
    }); 
 
    test("platform action undo and redo", () { 
      var platformCount = platforms.length; 
      var platform = Platform(platforms.concept); 
        platforms.add(platform); 
      expect(platforms.length, equals(++platformCount)); 
      platforms.remove(platform); 
      expect(platforms.length, equals(--platformCount)); 
 
      var action = AddCommand(session, platforms, platform); 
      action.doIt(); 
      expect(platforms.length, equals(++platformCount)); 
 
      action.undo(); 
      expect(platforms.length, equals(--platformCount)); 
 
      action.redo(); 
      expect(platforms.length, equals(++platformCount)); 
    }); 
 
    test("platform session undo and redo", () { 
      var platformCount = platforms.length; 
      var platform = Platform(platforms.concept); 
        platforms.add(platform); 
      expect(platforms.length, equals(++platformCount)); 
      platforms.remove(platform); 
      expect(platforms.length, equals(--platformCount)); 
 
      var action = AddCommand(session, platforms, platform); 
      action.doIt(); 
      expect(platforms.length, equals(++platformCount)); 
 
      session.past.undo(); 
      expect(platforms.length, equals(--platformCount)); 
 
      session.past.redo(); 
      expect(platforms.length, equals(++platformCount)); 
    }); 
 
    test("Platform update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("Platform action with multiple undos and redos", () { 
      var platformCount = platforms.length; 
      var platform1 = platforms.random(); 
 
      var action1 = RemoveCommand(session, platforms, platform1); 
      action1.doIt(); 
      expect(platforms.length, equals(--platformCount)); 
 
      var platform2 = platforms.random(); 
 
      var action2 = RemoveCommand(session, platforms, platform2); 
      action2.doIt(); 
      expect(platforms.length, equals(--platformCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(platforms.length, equals(++platformCount)); 
 
      session.past.undo(); 
      expect(platforms.length, equals(++platformCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(platforms.length, equals(--platformCount)); 
 
      session.past.redo(); 
      expect(platforms.length, equals(--platformCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var platformCount = platforms.length; 
      var platform1 = platforms.random(); 
      var platform2 = platforms.random(); 
      while (platform1 == platform2) { 
        platform2 = platforms.random();  
      } 
      var action1 = RemoveCommand(session, platforms, platform1); 
      var action2 = RemoveCommand(session, platforms, platform2); 
 
      var transaction = new Transaction("two removes on platforms", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      platformCount = platformCount - 2; 
      expect(platforms.length, equals(platformCount)); 
 
      platforms.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      platformCount = platformCount + 2; 
      expect(platforms.length, equals(platformCount)); 
 
      platforms.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      platformCount = platformCount - 2; 
      expect(platforms.length, equals(platformCount)); 
 
      platforms.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var platformCount = platforms.length; 
      var platform1 = platforms.random(); 
      var platform2 = platform1; 
      var action1 = RemoveCommand(session, platforms, platform1); 
      var action2 = RemoveCommand(session, platforms, platform2); 
 
      var transaction = Transaction( 
        "two removes on platforms, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(platforms.length, equals(platformCount)); 
 
      //platforms.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to platform actions", () { 
      var platformCount = platforms.length; 
 
      var reaction = PlatformReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var platform = Platform(platforms.concept); 
        platforms.add(platform); 
      expect(platforms.length, equals(++platformCount)); 
      platforms.remove(platform); 
      expect(platforms.length, equals(--platformCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, platforms, platform); 
      addCommand.doIt(); 
      expect(platforms.length, equals(++platformCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class PlatformReaction implements ICommandReaction { 
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
  var platforms = managerModel.platforms; 
  testSomManagerPlatforms(somDomain, managerModel, platforms); 
} 
 
