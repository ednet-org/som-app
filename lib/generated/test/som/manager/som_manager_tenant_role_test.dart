 
// test/som/manager/som_manager_tenant_role_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:som_manager/som_manager.dart"; 
 
void testSomManagerTenantRoles( 
    SomDomain somDomain, ManagerModel managerModel, TenantRoles tenantRoles) { 
  DomainSession session; 
  group("Testing Som.Manager.TenantRole", () { 
    session = somDomain.newSession();  
    setUp(() { 
      managerModel.init(); 
    }); 
    tearDown(() { 
      managerModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(managerModel.isEmpty, isFalse); 
      expect(tenantRoles.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      managerModel.clear(); 
      expect(managerModel.isEmpty, isTrue); 
      expect(tenantRoles.isEmpty, isTrue); 
      expect(tenantRoles.exceptions.isEmpty, isTrue); 
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
      var json = managerModel.fromEntryToJson("TenantRole"); 
      expect(json, isNotNull); 
 
      print(json); 
      //managerModel.displayEntryJson("TenantRole"); 
      //managerModel.displayJson(); 
      //managerModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = managerModel.fromEntryToJson("TenantRole"); 
      tenantRoles.clear(); 
      expect(tenantRoles.isEmpty, isTrue); 
      managerModel.fromJsonToEntry(json); 
      expect(tenantRoles.isEmpty, isFalse); 
 
      tenantRoles.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add tenantRole required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add tenantRole unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found tenantRole by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var tenantRole = tenantRoles.singleWhereOid(ednetOid); 
      expect(tenantRole, isNull); 
    }); 
 
    test("Find tenantRole by oid", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      var tenantRole = tenantRoles.singleWhereOid(randomTenantRole.oid); 
      expect(tenantRole, isNotNull); 
      expect(tenantRole, equals(randomTenantRole)); 
    }); 
 
    test("Find tenantRole by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find tenantRole by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find tenantRole by attribute", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      var tenantRole = 
          tenantRoles.firstWhereAttribute("name", randomTenantRole.name); 
      expect(tenantRole, isNotNull); 
      expect(tenantRole.name, equals(randomTenantRole.name)); 
    }); 
 
    test("Select tenantRoles by attribute", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      var selectedTenantRoles = 
          tenantRoles.selectWhereAttribute("name", randomTenantRole.name); 
      expect(selectedTenantRoles.isEmpty, isFalse); 
      selectedTenantRoles.forEach((se) => 
          expect(se.name, equals(randomTenantRole.name))); 
 
      //selectedTenantRoles.display(title: "Select tenantRoles by name"); 
    }); 
 
    test("Select tenantRoles by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select tenantRoles by attribute, then add", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      var selectedTenantRoles = 
          tenantRoles.selectWhereAttribute("name", randomTenantRole.name); 
      expect(selectedTenantRoles.isEmpty, isFalse); 
      expect(selectedTenantRoles.source?.isEmpty, isFalse); 
      var tenantRolesCount = tenantRoles.length; 
 
      var tenantRole = TenantRole(tenantRoles.concept); 
      tenantRole.name = 'chemist'; 
      tenantRole.value = 'craving'; 
      var added = selectedTenantRoles.add(tenantRole); 
      expect(added, isTrue); 
      expect(tenantRoles.length, equals(++tenantRolesCount)); 
 
      //selectedTenantRoles.display(title: 
      //  "Select tenantRoles by attribute, then add"); 
      //tenantRoles.display(title: "All tenantRoles"); 
    }); 
 
    test("Select tenantRoles by attribute, then remove", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      var selectedTenantRoles = 
          tenantRoles.selectWhereAttribute("name", randomTenantRole.name); 
      expect(selectedTenantRoles.isEmpty, isFalse); 
      expect(selectedTenantRoles.source?.isEmpty, isFalse); 
      var tenantRolesCount = tenantRoles.length; 
 
      var removed = selectedTenantRoles.remove(randomTenantRole); 
      expect(removed, isTrue); 
      expect(tenantRoles.length, equals(--tenantRolesCount)); 
 
      randomTenantRole.display(prefix: "removed"); 
      //selectedTenantRoles.display(title: 
      //  "Select tenantRoles by attribute, then remove"); 
      //tenantRoles.display(title: "All tenantRoles"); 
    }); 
 
    test("Sort tenantRoles", () { 
      // no id attribute 
      // add compareTo method in the specific TenantRole class 
      /* 
      tenantRoles.sort(); 
 
      //tenantRoles.display(title: "Sort tenantRoles"); 
      */ 
    }); 
 
    test("Order tenantRoles", () { 
      // no id attribute 
      // add compareTo method in the specific TenantRole class 
      /* 
      var orderedTenantRoles = tenantRoles.order(); 
      expect(orderedTenantRoles.isEmpty, isFalse); 
      expect(orderedTenantRoles.length, equals(tenantRoles.length)); 
      expect(orderedTenantRoles.source?.isEmpty, isFalse); 
      expect(orderedTenantRoles.source?.length, equals(tenantRoles.length)); 
      expect(orderedTenantRoles, isNot(same(tenantRoles))); 
 
      //orderedTenantRoles.display(title: "Order tenantRoles"); 
      */ 
    }); 
 
    test("Copy tenantRoles", () { 
      var copiedTenantRoles = tenantRoles.copy(); 
      expect(copiedTenantRoles.isEmpty, isFalse); 
      expect(copiedTenantRoles.length, equals(tenantRoles.length)); 
      expect(copiedTenantRoles, isNot(same(tenantRoles))); 
      copiedTenantRoles.forEach((e) => 
        expect(e, equals(tenantRoles.singleWhereOid(e.oid)))); 
 
      //copiedTenantRoles.display(title: "Copy tenantRoles"); 
    }); 
 
    test("True for every tenantRole", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random tenantRole", () { 
      var tenantRole1 = managerModel.tenantRoles.random(); 
      expect(tenantRole1, isNotNull); 
      var tenantRole2 = managerModel.tenantRoles.random(); 
      expect(tenantRole2, isNotNull); 
 
      //tenantRole1.display(prefix: "random1"); 
      //tenantRole2.display(prefix: "random2"); 
    }); 
 
    test("Update tenantRole id with try", () { 
      // no id attribute 
    }); 
 
    test("Update tenantRole id without try", () { 
      // no id attribute 
    }); 
 
    test("Update tenantRole id with success", () { 
      // no id attribute 
    }); 
 
    test("Update tenantRole non id attribute with failure", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      var afterUpdateEntity = randomTenantRole.copy(); 
      afterUpdateEntity.name = 'text'; 
      expect(afterUpdateEntity.name, equals('text')); 
      // tenantRoles.update can only be used if oid, code or id is set. 
      expect(() => tenantRoles.update(randomTenantRole, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomTenantRole = managerModel.tenantRoles.random(); 
      randomTenantRole.display(prefix:"before copy: "); 
      var randomTenantRoleCopy = randomTenantRole.copy(); 
      randomTenantRoleCopy.display(prefix:"after copy: "); 
      expect(randomTenantRole, equals(randomTenantRoleCopy)); 
      expect(randomTenantRole.oid, equals(randomTenantRoleCopy.oid)); 
      expect(randomTenantRole.code, equals(randomTenantRoleCopy.code)); 
      expect(randomTenantRole.name, equals(randomTenantRoleCopy.name)); 
      expect(randomTenantRole.value, equals(randomTenantRoleCopy.value)); 
 
    }); 
 
    test("tenantRole action undo and redo", () { 
      var tenantRoleCount = tenantRoles.length; 
      var tenantRole = TenantRole(tenantRoles.concept); 
        tenantRole.name = 'energy'; 
      tenantRole.value = 'darts'; 
      tenantRoles.add(tenantRole); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
      tenantRoles.remove(tenantRole); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      var action = AddCommand(session, tenantRoles, tenantRole); 
      action.doIt(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
 
      action.undo(); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      action.redo(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
    }); 
 
    test("tenantRole session undo and redo", () { 
      var tenantRoleCount = tenantRoles.length; 
      var tenantRole = TenantRole(tenantRoles.concept); 
        tenantRole.name = 'hot'; 
      tenantRole.value = 'architecture'; 
      tenantRoles.add(tenantRole); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
      tenantRoles.remove(tenantRole); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      var action = AddCommand(session, tenantRoles, tenantRole); 
      action.doIt(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
 
      session.past.undo(); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      session.past.redo(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
    }); 
 
    test("TenantRole update undo and redo", () { 
      var tenantRole = managerModel.tenantRoles.random(); 
      var action = SetAttributeCommand(session, tenantRole, "name", 'chairman'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(tenantRole.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(tenantRole.name, equals(action.after)); 
    }); 
 
    test("TenantRole action with multiple undos and redos", () { 
      var tenantRoleCount = tenantRoles.length; 
      var tenantRole1 = managerModel.tenantRoles.random(); 
 
      var action1 = RemoveCommand(session, tenantRoles, tenantRole1); 
      action1.doIt(); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      var tenantRole2 = managerModel.tenantRoles.random(); 
 
      var action2 = RemoveCommand(session, tenantRoles, tenantRole2); 
      action2.doIt(); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
 
      session.past.undo(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      session.past.redo(); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var tenantRoleCount = tenantRoles.length; 
      var tenantRole1 = managerModel.tenantRoles.random(); 
      var tenantRole2 = managerModel.tenantRoles.random(); 
      while (tenantRole1 == tenantRole2) { 
        tenantRole2 = managerModel.tenantRoles.random();  
      } 
      var action1 = RemoveCommand(session, tenantRoles, tenantRole1); 
      var action2 = RemoveCommand(session, tenantRoles, tenantRole2); 
 
      var transaction = new Transaction("two removes on tenantRoles", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      tenantRoleCount = tenantRoleCount - 2; 
      expect(tenantRoles.length, equals(tenantRoleCount)); 
 
      tenantRoles.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      tenantRoleCount = tenantRoleCount + 2; 
      expect(tenantRoles.length, equals(tenantRoleCount)); 
 
      tenantRoles.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      tenantRoleCount = tenantRoleCount - 2; 
      expect(tenantRoles.length, equals(tenantRoleCount)); 
 
      tenantRoles.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var tenantRoleCount = tenantRoles.length; 
      var tenantRole1 = managerModel.tenantRoles.random(); 
      var tenantRole2 = tenantRole1; 
      var action1 = RemoveCommand(session, tenantRoles, tenantRole1); 
      var action2 = RemoveCommand(session, tenantRoles, tenantRole2); 
 
      var transaction = Transaction( 
        "two removes on tenantRoles, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(tenantRoles.length, equals(tenantRoleCount)); 
 
      //tenantRoles.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to tenantRole actions", () { 
      var tenantRoleCount = tenantRoles.length; 
 
      var reaction = TenantRoleReaction(); 
      expect(reaction, isNotNull); 
 
      somDomain.startCommandReaction(reaction); 
      var tenantRole = TenantRole(tenantRoles.concept); 
        tenantRole.name = 'tape'; 
      tenantRole.value = 'head'; 
      tenantRoles.add(tenantRole); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
      tenantRoles.remove(tenantRole); 
      expect(tenantRoles.length, equals(--tenantRoleCount)); 
 
      var session = somDomain.newSession(); 
      var addCommand = AddCommand(session, tenantRoles, tenantRole); 
      addCommand.doIt(); 
      expect(tenantRoles.length, equals(++tenantRoleCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, tenantRole, "name", 'job'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      somDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TenantRoleReaction implements ICommandReaction { 
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
  var tenantRoles = managerModel.tenantRoles; 
  testSomManagerTenantRoles(somDomain, managerModel, tenantRoles); 
} 
 
