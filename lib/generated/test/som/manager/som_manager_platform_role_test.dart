 
// test/som/manager/som_manager_platform_role_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerPlatformRoles( 
    SomDomain somDomain, ManagerModel managerModel, PlatformRoles platformRoles) { 
  DomainSession session; 
  group("Testing Som.Manager.PlatformRole", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(platformRoles.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(platformRoles.isEmpty, isTrue); 
      expect(platformRoles.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("PlatformRole"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("PlatformRole"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("PlatformRole"); 
      platformRoles.clear(); 
      expect(platformRoles.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(platformRoles.isEmpty, isFalse); 
 
      platformRoles.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add platformRole required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add platformRole unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found platformRole by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var platformRole = platformRoles.singleWhereOid(ednetOid); 
      expect(platformRole, isNull); 
    }); 
 
    test("Find platformRole by oid", () { 
      var randomPlatformRole = platformRoles.random(); 
      var platformRole = platformRoles.singleWhereOid(randomPlatformRole.oid); 
      expect(platformRole, isNotNull); 
      expect(platformRole, equals(randomPlatformRole)); 
    }); 
 
    test("Find platformRole by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find platformRole by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find platformRole by attribute", () { 
      var randomPlatformRole = platformRoles.random(); 
      var platformRole = 
          platformRoles.firstWhereAttribute("name", randomPlatformRole.name); 
      expect(platformRole, isNotNull); 
      expect(platformRole.name, equals(randomPlatformRole.name)); 
    }); 
 
    test("Select platformRoles by attribute", () { 
      var randomPlatformRole = platformRoles.random(); 
      var selectedPlatformRoles = 
          platformRoles.selectWhereAttribute("name", randomPlatformRole.name); 
      expect(selectedPlatformRoles.isEmpty, isFalse); 
      selectedPlatformRoles.forEach((se) => 
          expect(se.name, equals(randomPlatformRole.name))); 
 
      //selectedPlatformRoles.display(title: "Select platformRoles by name"); 
    }); 
 
    test("Select platformRoles by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select platformRoles by attribute, then add", () { 
      var randomPlatformRole = platformRoles.random(); 
      var selectedPlatformRoles = 
          platformRoles.selectWhereAttribute("name", randomPlatformRole.name); 
      expect(selectedPlatformRoles.isEmpty, isFalse); 
      expect(selectedPlatformRoles.source?.isEmpty, isFalse); 
      var platformRolesCount = platformRoles.length; 
 
      var platformRole = PlatformRole(platformRoles.concept); 
      platformRole.name = 'money'; 
      platformRole.value = 'objective'; 
      var added = selectedPlatformRoles.add(platformRole); 
      expect(added, isTrue); 
      expect(platformRoles.length, equals(++platformRolesCount)); 
 
      //selectedPlatformRoles.display(title: 
      //  "Select platformRoles by attribute, then add"); 
      //platformRoles.display(title: "All platformRoles"); 
    }); 
 
    test("Select platformRoles by attribute, then remove", () { 
      var randomPlatformRole = platformRoles.random(); 
      var selectedPlatformRoles = 
          platformRoles.selectWhereAttribute("name", randomPlatformRole.name); 
      expect(selectedPlatformRoles.isEmpty, isFalse); 
      expect(selectedPlatformRoles.source?.isEmpty, isFalse); 
      var platformRolesCount = platformRoles.length; 
 
      var removed = selectedPlatformRoles.remove(randomPlatformRole); 
      expect(removed, isTrue); 
      expect(platformRoles.length, equals(--platformRolesCount)); 
 
      randomPlatformRole.display(prefix: "removed"); 
      //selectedPlatformRoles.display(title: 
      //  "Select platformRoles by attribute, then remove"); 
      //platformRoles.display(title: "All platformRoles"); 
    }); 
 
    test("Sort platformRoles", () { 
      // no id attribute 
      // add compareTo method in the specific PlatformRole class 
      /* 
      platformRoles.sort(); 
 
      //platformRoles.display(title: "Sort platformRoles"); 
      */ 
    }); 
 
    test("Order platformRoles", () { 
      // no id attribute 
      // add compareTo method in the specific PlatformRole class 
      /* 
      var orderedPlatformRoles = platformRoles.order(); 
      expect(orderedPlatformRoles.isEmpty, isFalse); 
      expect(orderedPlatformRoles.length, equals(platformRoles.length)); 
      expect(orderedPlatformRoles.source?.isEmpty, isFalse); 
      expect(orderedPlatformRoles.source?.length, equals(platformRoles.length)); 
      expect(orderedPlatformRoles, isNot(same(platformRoles))); 
 
      //orderedPlatformRoles.display(title: "Order platformRoles"); 
      */ 
    }); 
 
    test("Copy platformRoles", () { 
      var copiedPlatformRoles = platformRoles.copy(); 
      expect(copiedPlatformRoles.isEmpty, isFalse); 
      expect(copiedPlatformRoles.length, equals(platformRoles.length)); 
      expect(copiedPlatformRoles, isNot(same(platformRoles))); 
      copiedPlatformRoles.forEach((e) => 
        expect(e, equals(platformRoles.singleWhereOid(e.oid)))); 
      copiedPlatformRoles.forEach((e) => 
        expect(e, isNot(same(platformRoles.singleWhereId(e.id!))))); 
 
      //copiedPlatformRoles.display(title: "Copy platformRoles"); 
    }); 
 
    test("True for every platformRole", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random platformRole", () { 
      var platformRole1 = platformRoles.random(); 
      expect(platformRole1, isNotNull); 
      var platformRole2 = platformRoles.random(); 
      expect(platformRole2, isNotNull); 
 
      //platformRole1.display(prefix: "random1"); 
      //platformRole2.display(prefix: "random2"); 
    }); 
 
    test("Update platformRole id with try", () { 
      // no id attribute 
    }); 
 
    test("Update platformRole id without try", () { 
      // no id attribute 
    }); 
 
    test("Update platformRole id with success", () { 
      // no id attribute 
    }); 
 
    test("Update platformRole non id attribute with failure", () { 
      var randomPlatformRole = platformRoles.random(); 
      var afterUpdateEntity = randomPlatformRole.copy(); 
      afterUpdateEntity.name = 'wheat'; 
      expect(afterUpdateEntity.name, equals('wheat')); 
      // platformRoles.update can only be used if oid, code or id is set. 
      expect(() => platformRoles.update(randomPlatformRole, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomPlatformRole = platformRoles.random(); 
      randomPlatformRole.display(prefix:"before copy: "); 
      var randomPlatformRoleCopy = randomPlatformRole.copy(); 
      randomPlatformRoleCopy.display(prefix:"after copy: "); 
      expect(randomPlatformRole, equals(randomPlatformRoleCopy)); 
      expect(randomPlatformRole.oid, equals(randomPlatformRoleCopy.oid)); 
      expect(randomPlatformRole.code, equals(randomPlatformRoleCopy.code)); 
      expect(randomPlatformRole.name, equals(randomPlatformRoleCopy.name)); 
      expect(randomPlatformRole.value, equals(randomPlatformRoleCopy.value)); 
 
    }); 
 
    test("platformRole action undo and redo", () { 
      var platformRoleCount = platformRoles.length; 
      var platformRole = PlatformRole(platformRoles.concept); 
        platformRole.name = 'plaho'; 
      platformRole.value = 'picture'; 
    var platformRoleUser = users.random(); 
    platformRole.user = platformRoleUser; 
    var platformRolePlatform = platforms.random(); 
    platformRole.platform = platformRolePlatform; 
      platformRoles.add(platformRole); 
    platformRoleUser.platformRoles.add(platformRole); 
    platformRolePlatform.roles.add(platformRole); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
      platformRoles.remove(platformRole); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      var action = AddCommand(session, platformRoles, platformRole); 
      action.doIt(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
 
      action.undo(); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      action.redo(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
    }); 
 
    test("platformRole session undo and redo", () { 
      var platformRoleCount = platformRoles.length; 
      var platformRole = PlatformRole(platformRoles.concept); 
        platformRole.name = 'baby'; 
      platformRole.value = 'test'; 
    var platformRoleUser = users.random(); 
    platformRole.user = platformRoleUser; 
    var platformRolePlatform = platforms.random(); 
    platformRole.platform = platformRolePlatform; 
      platformRoles.add(platformRole); 
    platformRoleUser.platformRoles.add(platformRole); 
    platformRolePlatform.roles.add(platformRole); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
      platformRoles.remove(platformRole); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      var action = AddCommand(session, platformRoles, platformRole); 
      action.doIt(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
 
      session.past.undo(); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      session.past.redo(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
    }); 
 
    test("PlatformRole update undo and redo", () { 
      var platformRole = platformRoles.random(); 
      var action = SetAttributeCommand(session, platformRole, "name", 'saving'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(platformRole.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(platformRole.name, equals(action.after)); 
    }); 
 
    test("PlatformRole action with multiple undos and redos", () { 
      var platformRoleCount = platformRoles.length; 
      var platformRole1 = platformRoles.random(); 
 
      var action1 = RemoveCommand(session, platformRoles, platformRole1); 
      action1.doIt(); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      var platformRole2 = platformRoles.random(); 
 
      var action2 = RemoveCommand(session, platformRoles, platformRole2); 
      action2.doIt(); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
 
      session.past.undo(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      session.past.redo(); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var platformRoleCount = platformRoles.length; 
      var platformRole1 = platformRoles.random(); 
      var platformRole2 = platformRoles.random(); 
      while (platformRole1 == platformRole2) { 
        platformRole2 = platformRoles.random();  
      } 
      var action1 = RemoveCommand(session, platformRoles, platformRole1); 
      var action2 = RemoveCommand(session, platformRoles, platformRole2); 
 
      var transaction = new Transaction("two removes on platformRoles", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      platformRoleCount = platformRoleCount - 2; 
      expect(platformRoles.length, equals(platformRoleCount)); 
 
      platformRoles.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      platformRoleCount = platformRoleCount + 2; 
      expect(platformRoles.length, equals(platformRoleCount)); 
 
      platformRoles.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      platformRoleCount = platformRoleCount - 2; 
      expect(platformRoles.length, equals(platformRoleCount)); 
 
      platformRoles.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var platformRoleCount = platformRoles.length; 
      var platformRole1 = platformRoles.random(); 
      var platformRole2 = platformRole1; 
      var action1 = RemoveCommand(session, platformRoles, platformRole1); 
      var action2 = RemoveCommand(session, platformRoles, platformRole2); 
 
      var transaction = Transaction( 
        "two removes on platformRoles, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(platformRoles.length, equals(platformRoleCount)); 
 
      //platformRoles.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to platformRole actions", () { 
      var platformRoleCount = platformRoles.length; 
 
      var reaction = PlatformRoleReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var platformRole = PlatformRole(platformRoles.concept); 
        platformRole.name = 'milk'; 
      platformRole.value = 'lunch'; 
    var platformRoleUser = users.random(); 
    platformRole.user = platformRoleUser; 
    var platformRolePlatform = platforms.random(); 
    platformRole.platform = platformRolePlatform; 
      platformRoles.add(platformRole); 
    platformRoleUser.platformRoles.add(platformRole); 
    platformRolePlatform.roles.add(platformRole); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
      platformRoles.remove(platformRole); 
      expect(platformRoles.length, equals(--platformRoleCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, platformRoles, platformRole); 
      addCommand.doIt(); 
      expect(platformRoles.length, equals(++platformRoleCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, platformRole, "name", 'privacy'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class PlatformRoleReaction implements ICommandReaction { 
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
  var platformRoles = managerModel.platformRoles; 
  testSomManagerPlatformRoles(somDomain, managerModel, platformRoles); 
} 
 
